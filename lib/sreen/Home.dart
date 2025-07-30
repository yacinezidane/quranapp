import 'package:flutter/material.dart';
import 'package:quran/quran.dart' as quran;

import 'Shared.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController searchController = TextEditingController();
  List<int> filteredSurahs = List.generate(114, (index) => index + 1);

  @override
  void initState() {
    super.initState();
    searchController.addListener(_filterSurahs);
  }

  void _filterSurahs() {
    String query = searchController.text.trim();
    setState(() {
      if (query.isEmpty) {
        filteredSurahs = List.generate(114, (index) => index + 1);
      } else {
        filteredSurahs = List.generate(114, (index) => index + 1).where((number) {
          final surahName = quran.getSurahNameArabic(number);
          return surahName.contains(query);
        }).toList();
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[400],
      appBar: AppBar(
        title: const Text(
          "📖 القرآن الكريم",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal[700],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: searchController,
              textAlign: TextAlign.right,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'ابحث عن سورة...',
                hintStyle: const TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.teal[600],
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: filteredSurahs.isEmpty
                ? const Center(
              child: Text(
                'لا توجد نتائج',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: filteredSurahs.length,
              itemBuilder: (context, index) {
                final surahNumber = filteredSurahs[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SurahScreen(surahNumber: surahNumber),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.teal[200]!, Colors.teal[400]!],
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6,
                          offset: const Offset(2, 4),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 9),
                      title: Text(
                        quran.getSurahNameArabic(surahNumber),
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          height: 1.4,
                        ),
                      ),
                      subtitle: Text(
                        "${quran.getVerseCount(surahNumber)} آية",
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                        ),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios,
                          color: Colors.black),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
