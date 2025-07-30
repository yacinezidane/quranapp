import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../models/athkar_model.dart';

class AthkarScreen extends StatefulWidget {
  final Athkar athkar;

  const AthkarScreen({super.key, required this.athkar});

  @override
  State<AthkarScreen> createState() => _AthkarScreenState();
}

class _AthkarScreenState extends State<AthkarScreen> {
  final AudioPlayer _player = AudioPlayer();
  int? _currentPlayingIndex;

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  void _togglePlay(String url, int index) async {
    if (_currentPlayingIndex == index && _player.playing) {
      await _player.pause();
      setState(() {
        _currentPlayingIndex = null;
      });
    } else {
      try {
        setState(() {
          _currentPlayingIndex = index;
        });

        await _player.setUrl(url);
        await _player.play();
      } catch (e) {
        print('خطأ أثناء تشغيل الصوت: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[100],
      appBar: AppBar(
        backgroundColor: Colors.teal[800],
        title: Text(
          widget.athkar.category,
          style: const TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<PlayerState>(
        stream: _player.playerStateStream,
        builder: (context, snapshot) {
          final isPlaying = snapshot.data?.playing ?? false;

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: widget.athkar.array.length,
            itemBuilder: (context, index) {
              final thikr = widget.athkar.array[index];
              final audioUrl =
                  'https://raw.githubusercontent.com/rn0x/Adhkar-json/main${thikr.audio}';
              final isCurrent = _currentPlayingIndex == index && isPlaying;

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 6,
                color: Colors.teal[300],
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        thikr.text,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.8,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.teal[800],
                            child: IconButton(
                              icon: Icon(
                                isCurrent ? Icons.pause : Icons.play_arrow,
                                color: Colors.white,
                              ),
                              onPressed: () => _togglePlay(audioUrl, index),
                            ),
                          ),
                          Text(
                            'عدد التكرار: ${thikr.count}',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      )
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





