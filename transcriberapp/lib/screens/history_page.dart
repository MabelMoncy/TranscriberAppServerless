import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:share_plus/share_plus.dart'; 
import 'dart:io';
import '../models/transcription_record.dart';
import '../services/database_service.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late Future<List<TranscriptionRecord>> _historyFuture;
  List<TranscriptionRecord> _allRecords = []; 
  
  final AudioPlayer _audioPlayer = AudioPlayer();
  int? _playingIndex; 
  bool _isPlaying = false;

  bool _isSelectionMode = false;
  final Set<int> _selectedIds = {}; 

  @override
  void initState() {
    super.initState();
    _refreshHistory();
    _audioPlayer.onPlayerComplete.listen((event) {
      if (mounted) setState(() { _playingIndex = null; _isPlaying = false; });
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
      _historyFuture = DatabaseService.instance.readAllHistory().then((data) {
        _allRecords = data;
        return data;
      });
    });
  }

  void _toggleSelection(int id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
        if (_selectedIds.isEmpty) _isSelectionMode = false;
      } else {
        _selectedIds.add(id);
      }
    });
  }

  void _selectAll() {
    setState(() {
      if (_selectedIds.length == _allRecords.length) {
        _selectedIds.clear(); 
        _isSelectionMode = false;
      } else {
        _selectedIds.addAll(_allRecords.map((e) => e.id!).toList());
        _isSelectionMode = true;
      }
    });
  }

  Future<void> _deleteSelected() async {
    if (_selectedIds.isEmpty) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: Theme.of(context).cardColor, // Dynamic Background
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), shape: BoxShape.circle),
                child: const Icon(Icons.delete_forever_rounded, color: Colors.red, size: 40),
              ),
              const SizedBox(height: 20),
              Text(
                "Delete Recordings?", 
                style: TextStyle(
                  fontSize: 20, 
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyLarge?.color
                )
              ),
              const SizedBox(height: 12),
              Text(
                "Permanently delete ${_selectedIds.length} item(s)?",
                textAlign: TextAlign.center,
                style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context, false),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: Theme.of(context).dividerColor)
                      ),
                      child: Text("Cancel", style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, padding: const EdgeInsets.symmetric(vertical: 16)),
                      child: const Text("Delete", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );

    if (confirmed != true) return;

    for (var id in _selectedIds) {
      final record = _allRecords.firstWhere((r) => r.id == id);
      try {
        final file = File(record.filePath);
        if (await file.exists()) await file.delete();
        await DatabaseService.instance.delete(id);
      } catch (e) {
        debugPrint("Deletion error: $e");
      }
    }

    setState(() {
      _selectedIds.clear();
      _isSelectionMode = false;
    });
    _refreshHistory();
  }

  Future<void> _toggleAudio(String filePath, int index) async {
    if (_isSelectionMode) return; 
    try {
      if (!await File(filePath).exists()) return;

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

  void _shareTranscript(String text) {
    Share.share(text);
  }

  void _showFullTranscription(TranscriptionRecord record) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, 
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, controller) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor, // Dynamic Background
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Container(width: 40, height: 5, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)))),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Transcription", 
                    style: TextStyle(
                      fontSize: 22, 
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyLarge?.color
                    )
                  ),
                  IconButton(
                    onPressed: () => _shareTranscript(record.transcription),
                    icon: const Icon(Icons.share_rounded, color: Color(0xFF448AFF)),
                  )
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  controller: controller,
                  child: SelectableText(
                    record.transcription, 
                    style: TextStyle(
                      fontSize: 16, 
                      height: 1.7,
                      color: Theme.of(context).textTheme.bodyLarge?.color
                    )
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          _isSelectionMode ? "${_selectedIds.length} Selected" : "History",
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyLarge?.color,
            fontWeight: FontWeight.bold
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: _isSelectionMode 
          ? IconButton(
              icon: Icon(Icons.close, color: Theme.of(context).iconTheme.color),
              onPressed: () => setState(() { _isSelectionMode = false; _selectedIds.clear(); }),
            )
          : BackButton(color: Theme.of(context).iconTheme.color),
        actions: [
          if (_isSelectionMode) ...[
            IconButton(
              icon: Icon(
                _selectedIds.length == _allRecords.length ? Icons.select_all : Icons.check_box_outline_blank, 
                color: Colors.blueAccent
              ),
              onPressed: _selectAll,
            ),
            IconButton(
              icon: const Icon(Icons.delete_rounded, color: Colors.redAccent),
              onPressed: _deleteSelected,
            ),
          ]
        ],
      ),
      body: FutureBuilder<List<TranscriptionRecord>>(
        future: _historyFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No history yet", style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color)));
          }

          final records = snapshot.data!;
          
          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            itemCount: records.length,
            separatorBuilder: (c, i) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final record = records[index];
              final isSelected = _selectedIds.contains(record.id);
              final isThisPlaying = _playingIndex == index && _isPlaying;

              return GestureDetector(
                onLongPress: () {
                  setState(() {
                    _isSelectionMode = true;
                    _toggleSelection(record.id!);
                  });
                },
                onTap: () {
                  if (_isSelectionMode) {
                    _toggleSelection(record.id!);
                  }
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.blue.withOpacity(0.1) : Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(20),
                    border: isSelected ? Border.all(color: Colors.blueAccent, width: 2) : null,
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).shadowColor,
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      // --- TOP PART ---
                      ListTile(
                        contentPadding: const EdgeInsets.fromLTRB(20, 16, 12, 16),
                        leading: GestureDetector(
                          onTap: () => _toggleAudio(record.filePath, index),
                          child: Container(
                            width: 50, height: 50,
                            decoration: BoxDecoration(
                              gradient: isThisPlaying 
                                ? const LinearGradient(colors: [Colors.orangeAccent, Colors.deepOrange]) 
                                : const LinearGradient(colors: [Color(0xFF448AFF), Color(0xFF00BCD4)]),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isThisPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        title: Text(
                          record.fileName, 
                          maxLines: 1, 
                          overflow: TextOverflow.ellipsis, 
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textTheme.bodyLarge?.color
                          )
                        ),
                        subtitle: Text(
                          DateFormat.yMMMd().format(record.dateCreated), 
                          style: TextStyle(fontSize: 12, color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7))
                        ),
                        trailing: _isSelectionMode 
                          ? Icon(isSelected ? Icons.check_circle : Icons.circle_outlined, color: isSelected ? Colors.blueAccent : Colors.grey)
                          : null, 
                      ),
                      
                      // --- BOTTOM PART ---
                      if (!_isSelectionMode)
                        InkWell(
                          onTap: () => _showFullTranscription(record),
                          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Divider(color: Theme.of(context).dividerColor.withOpacity(0.1)),
                                const SizedBox(height: 8),
                                Text(
                                  record.transcription,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 14, 
                                    // Use body color instead of fixed grey so it works in dark mode
                                    color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.8), 
                                    height: 1.5
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    const Text("Read Full", style: TextStyle(fontSize: 12, color: Color(0xFF448AFF), fontWeight: FontWeight.bold)),
                                    const SizedBox(width: 4),
                                    const Icon(Icons.arrow_forward_rounded, size: 14, color: Color(0xFF448AFF))
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}