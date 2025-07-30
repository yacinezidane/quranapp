import 'package:flutter/material.dart';
import 'package:quran/quran.dart' as quran;
import 'package:audioplayers/audioplayers.dart';
import 'package:google_fonts/google_fonts.dart';

class SurahScreen extends StatefulWidget {
  final int surahNumber;
  SurahScreen({required this.surahNumber});

  @override
  _SurahScreenState createState() => _SurahScreenState();
}

class _SurahScreenState extends State<SurahScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false; // حالة التشغيل

  void toggleAudio() async {
    if (isPlaying) {
      await _audioPlayer.pause();
      setState(() {
        isPlaying = false;
      });
    } else {
      String url = "https://server8.mp3quran.net/afs/${widget.surahNumber.toString().padLeft(3, '0')}.mp3";
      try {
        await _audioPlayer.setSourceUrl(url);
        await _audioPlayer.resume();
        setState(() {
          isPlaying = true;
        });

        // الاستماع لنهاية الصوت لإعادة ضبط الزر
        _audioPlayer.onPlayerComplete.listen((event) {
          setState(() {
            isPlaying = false;
          });
        });
      } catch (e) {
        print("خطأ في تشغيل الصوت: $e");
      }
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[100],
      appBar: AppBar(
        title: Text(quran.getSurahNameArabic(widget.surahNumber),
            style: GoogleFonts.amiri(fontSize: 26)),
        centerTitle: true,
        backgroundColor: Colors.teal[700],
      ),
      body:  Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: quran.getVerseCount(widget.surahNumber),
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 6),
                    color: Colors.teal[300],
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        quran.getVerse(widget.surahNumber, index + 1,
                            verseEndSymbol: true),
                        textAlign: TextAlign.right,
                        style: GoogleFonts.amiri(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            FloatingActionButton(
              onPressed: toggleAudio,
              child: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
              backgroundColor: Colors.teal[800],
            ),
          ],
        ),
    );
  }
}
