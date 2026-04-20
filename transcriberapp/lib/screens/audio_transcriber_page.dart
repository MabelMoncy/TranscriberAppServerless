import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
// ignore: unnecessary_import
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:record/record.dart';
import 'package:path/path.dart' as p;

import '../models/app_state.dart';
import '../services/gemini_service.dart';
import '../services/theme_service.dart'; 
import '../widgets/initial_view.dart';
import '../widgets/loading_view.dart'; 
import '../widgets/success_view.dart';
import '../widgets/error_view.dart';
import '../widgets/recording_view.dart';
import 'history_page.dart';
import '../models/transcription_record.dart';
import '../services/database_service.dart';
import '../services/network_helper.dart';

class AudioTranscriberPage extends StatefulWidget {
  const AudioTranscriberPage({super.key});

  @override
  State<AudioTranscriberPage> createState() => _AudioTranscriberPageState();
}

class _AudioTranscriberPageState extends State<AudioTranscriberPage> {
  final GeminiService _geminiService = GeminiService();
  final AudioRecorder _audioRecorder = AudioRecorder();

  AppState _appState = AppState.initial;
  
  // Results list to show in SuccessView
  final List<TranscriptionRecord> _completedResults = [];
  
  String? _errorMessage;
  String _statusMessage = "";
  
  String? _recordingPath;
  Timer? _recordingTimer;
  int _recordingDuration = 0;

  @override
  void initState() {
    super.initState();
    _initSharingListener();
  }

  void _initSharingListener() {
    ReceiveSharingIntent.instance.getMediaStream().listen((List<SharedMediaFile> value) {
      if (value.isNotEmpty) _processFiles(value);
    });
    
    ReceiveSharingIntent.instance.getInitialMedia().then((List<SharedMediaFile> value) {
      if (value.isNotEmpty) _processFiles(value);
    });
  }

  // --- PROCESSING LOGIC ---
  Future<void> _processFiles(List<SharedMediaFile> files) async {
    setState(() {
      _completedResults.clear();
      _appState = AppState.transcribing;
    });

    try {
      if (!await NetworkHelper.hasInternetConnection()) {
        throw Exception("No Internet Connection");
      }

      for (int i = 0; i < files.length; i++) {
        File file = File(files[i].path);
        String fileName = file.path.split('/').last;

        setState(() {
          _statusMessage = "Processing ${i + 1} of ${files.length}...\n$fileName";
        });

        // 1. Transcribe
        final transcription = await _geminiService.transcribeAudio(file);
        
        // 2. Save Permanently
        final safeName = "${DateTime.now().millisecondsSinceEpoch}_$fileName";
        final permanentPath = await _saveAudioPermanently(file, safeName);
        
        // 3. Create Record
        final record = TranscriptionRecord(
          fileName: fileName,
          filePath: permanentPath,
          transcription: transcription,
          dateCreated: DateTime.now(),
          isAccidental: false,
        );

        // 4. Save to DB & List
        await DatabaseService.instance.create(record);
        _completedResults.add(record);
      }

      setState(() {
        _appState = AppState.success;
        _statusMessage = "";
      });

    } catch (e) {
      debugPrint("Error processing files: $e");
      if (_completedResults.isNotEmpty) {
        setState(() => _appState = AppState.success);
      } else {
        _showError("Processing failed: $e");
      }
    }
  }

  Future<String> _saveAudioPermanently(File tempFile, String fileName) async {
    final appDir = await getApplicationDocumentsDirectory();
    final newPath = p.join(appDir.path, 'recordings', fileName);
    final savedFile = File(newPath);
    
    if (!await savedFile.parent.exists()) {
      await savedFile.parent.create(recursive: true);
    }
    
    await tempFile.copy(newPath);
    return newPath;
  }

  // --- RECORDING LOGIC ---
  Future<void> _startLiveRecording() async {
    final status = await Permission.microphone.request();
    if (!status.isGranted) {
      _showError("Microphone permission required");
      return;
    }
    try {
      final directory = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      _recordingPath = '${directory.path}/recording_$timestamp.m4a';
      
      await _audioRecorder.start(
        const RecordConfig(encoder: AudioEncoder.aacLc, bitRate: 128000, sampleRate: 44100),
        path: _recordingPath!,
      );
      
      setState(() {
        _appState = AppState.liveRecording;
        _recordingDuration = 0;
      });
      
      _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() => _recordingDuration++);
      });
    } catch (e) {
      _showError("Start recording failed: $e");
    }
  }

  Future<void> _stopLiveRecording() async {
    _recordingTimer?.cancel();
    _recordingTimer = null;
    final path = await _audioRecorder.stop();
    
    if (path != null) {
      _processFiles([SharedMediaFile(path: path, type: SharedMediaType.file)]);
    }
  }

  void _showError(String msg) {
    setState(() {
      _errorMessage = msg;
      _appState = AppState.error;
    });
  }

  void _resetApp() {
    setState(() {
      _appState = AppState.initial;
      _completedResults.clear();
      _errorMessage = null;
    });
  }

  @override
  void dispose() {
    _recordingTimer?.cancel();
    _audioRecorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor, 
      appBar: AppBar(
        title: Text(
          'Audio Transcriber', 
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          // Theme Toggle
          IconButton(
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark 
                  ? Icons.light_mode_rounded 
                  : Icons.dark_mode_rounded,
              color: Theme.of(context).iconTheme.color,
            ),
            onPressed: () {
              ThemeService.instance.toggleTheme();
            },
          ),
          
          IconButton(
            icon: Icon(Icons.history_rounded, color: Theme.of(context).iconTheme.color),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const HistoryPage())),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: _buildStatusUI(),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusUI() {
    switch (_appState) {
      case AppState.initial:
        return InitialView(onStartRecording: _startLiveRecording);
        
      case AppState.transcribing:
      case AppState.liveTranscribing:
        return LoadingView(statusMessage: _statusMessage);
        
      case AppState.success:
        return SuccessView(
          results: _completedResults,
          onReset: _resetApp,
        );
        
      case AppState.error:
        return ErrorView(
          errorMessage: _errorMessage,
          isAccidental: false,
          onRetry: _resetApp,
        );
        
      case AppState.liveRecording:
        return RecordingView(
          duration: _recordingDuration,
          onStopRecording: _stopLiveRecording,
        );
        
      default:
        return Container();
    }
  }
}
