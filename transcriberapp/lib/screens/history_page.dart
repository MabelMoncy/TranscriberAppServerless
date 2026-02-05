import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:share_plus/share_plus.dart'; // Import Share
import 'dart:io';
import '../models/transcription_record.dart';
import '../services/database_service.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late Future<List<TranscriptionRecord>> _historyList;
  final AudioPlayer _audioPlayer = AudioPlayer();
  int? _playingIndex; 
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _refreshHistory();
    
    _audioPlayer.onPlayerComplete.listen((event) {
      if (mounted) {
        setState(() {
          _playingIndex = null;
          _isPlaying = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.stop();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _refreshHistory() {
    setState(() {
      _historyList = DatabaseService.instance.readAllHistory();
    });
  }

  Future<void> _toggleAudio(String filePath, int index) async {
    try {
      if (!await File(filePath).exists()) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Audio file not found on device.")),
          );
        }
        return;
      }

      if (_playingIndex == index && _isPlaying) {
        await _audioPlayer.pause();
        setState(() => _isPlaying = false);
      } else {
        await _audioPlayer.stop(); 
        await _audioPlayer.play(DeviceFileSource(filePath));
        setState(() {
          _playingIndex = index;
          _isPlaying = true;
        });
      }
    } catch (e) {
      debugPrint("Audio Error: $e");
    }
  }

  Future<void> _deleteRecord(int id, String filePath, int index) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Recording?'),
        content: const Text('This will permanently delete the audio file and transcript.'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    // 1. Stop Audio if playing this file
    if (_playingIndex == index) {
      await _audioPlayer.stop();
      setState(() {
        _playingIndex = null;
        _isPlaying = false;
      });
    }

    // 2. PHYSICAL DELETION
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete(); 
        debugPrint("Deleted file: $filePath");
      }
    } catch (e) {
      debugPrint("Error deleting file: $e");
    }

    // 3. Database Deletion
    await DatabaseService.instance.delete(id);
    
    _refreshHistory();
  }

  void _shareTranscript(String text) {
    Share.share(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Ensure background matches the new main theme
      backgroundColor: const Color(0xFFF5F7FA), 
      appBar: AppBar(
        title: const Text(
          "History",
          style: TextStyle(color: Color(0xFF2D3436), fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF2D3436)),
      ),
      body: FutureBuilder<List<TranscriptionRecord>>(
        future: _historyList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history_toggle_off_rounded, size: 80, color: Colors.blueGrey.withOpacity(0.3)),
                  const SizedBox(height: 16),
                  Text(
                    "No history yet", 
                    style: TextStyle(fontSize: 18, color: Colors.blueGrey.withOpacity(0.6), fontWeight: FontWeight.w500)
                  ),
                ],
              ),
            );
          }

          final records = snapshot.data!;
          
          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            itemCount: records.length,
            separatorBuilder: (c, i) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final record = records[index];
              final isThisPlaying = _playingIndex == index && _isPlaying;
              final dateStr = DateFormat.yMMMd().add_jm().format(record.dateCreated);

              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20), // Soft rounded corners
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blueGrey.withOpacity(0.08), // Diffused shadow
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.fromLTRB(20, 16, 12, 16),
                      
                      // --- PLAY BUTTON (Gradient) ---
                      leading: GestureDetector(
                        onTap: () => _toggleAudio(record.filePath, index),
                        child: Container(
                          width: 50, height: 50,
                          decoration: BoxDecoration(
                            // Electric Blue -> Cyan Gradient
                            gradient: isThisPlaying 
                              ? const LinearGradient(colors: [Colors.orangeAccent, Colors.deepOrange]) 
                              : const LinearGradient(colors: [Color(0xFF448AFF), Color(0xFF00BCD4)]),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: (isThisPlaying ? Colors.orange : const Color(0xFF448AFF)).withOpacity(0.4),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              )
                            ],
                          ),
                          child: Icon(
                            isThisPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                            color: Colors.white,
                            size: 26,
                          ),
                        ),
                      ),
                      
                      // --- TITLE & DATE ---
                      title: Text(
                        record.fileName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700, 
                          fontSize: 16, 
                          color: Color(0xFF2D3436)
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 6.0),
                        child: Text(
                          dateStr,
                          style: TextStyle(fontSize: 12, color: Colors.blueGrey.shade400, fontWeight: FontWeight.w500),
                        ),
                      ),
                      
                      // --- DELETE BUTTON ---
                      trailing: IconButton(
                        icon: Icon(Icons.delete_outline_rounded, color: Colors.grey.shade400),
                        onPressed: record.id == null 
                            ? null 
                            : () => _deleteRecord(record.id!, record.filePath, index),
                      ),
                    ),
                    
                    // --- TRANSCRIPT PREVIEW ---
                    InkWell(
                      onTap: () => _showFullTranscription(context, record),
                      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Divider(color: Colors.grey.shade100, height: 1),
                            const SizedBox(height: 12),
                            Text(
                              record.transcription,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14, 
                                color: Color(0xFF535c68), // Softer text color
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "Read Full",
                                  style: TextStyle(
                                    fontSize: 12, 
                                    color: Theme.of(context).primaryColor, 
                                    fontWeight: FontWeight.w600
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Icon(Icons.arrow_forward_rounded, size: 14, color: Theme.of(context).primaryColor)
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showFullTranscription(BuildContext context, TranscriptionRecord record) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, 
      backgroundColor: Colors.transparent, // Transparent to show rounded corners
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, controller) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle Bar
              Center(
                child: Container(
                  width: 40, height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300, 
                    borderRadius: BorderRadius.circular(10)
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Transcription", 
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF2D3436))
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      onPressed: () => _shareTranscript(record.transcription),
                      icon: const Icon(Icons.share_rounded, color: Color(0xFF448AFF)),
                      tooltip: "Share",
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              
              // Content
              Expanded(
                child: SingleChildScrollView(
                  controller: controller,
                  child: SelectableText(
                    record.transcription,
                    style: const TextStyle(fontSize: 16, height: 1.7, color: Color(0xFF2D3436)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}