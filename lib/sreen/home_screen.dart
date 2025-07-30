import 'package:flutter/material.dart';
import '../models/athkar_model.dart';
import '../services/api_service.dart';
import 'athkar_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Athkar> allCategories = [];
  List<Athkar> filteredCategories = [];
  TextEditingController searchController = TextEditingController();
  bool isLoading = true; // 🆕 متغير لتحديد حالة التحميل

  @override
  void initState() {
    super.initState();
    _loadAthkar();
    searchController.addListener(_filterCategories);
  }

  void _loadAthkar() async {
    try {
      final data = await ApiService.fetchAthkar();
      setState(() {
        allCategories = data;
        filteredCategories = data;
        isLoading = false; // ✅ انتهاء التحميل
      });
    } catch (e) {
      print('خطأ أثناء تحميل البيانات: $e');
      setState(() {
        isLoading = false; // حتى عند الخطأ
      });
    }
  }

  void _filterCategories() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredCategories = allCategories
          .where((athkar) => athkar.category.toLowerCase().contains(query))
          .toList();
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
        backgroundColor: Colors.teal[700],
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'حصن المسلم',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
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
                hintText: 'ابحث عن قسم...',
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
            child: isLoading
                ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.white),
                  SizedBox(height: 12),
                  Text(
                    'جاري تحميل الأذكار...',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            )
                : filteredCategories.isEmpty
                ? const Center(
              child: Text(
                'لا توجد نتائج',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: filteredCategories.length,
              itemBuilder: (context, index) {
                final athkar = filteredCategories[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            AthkarScreen(athkar: athkar),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.teal[200]!,
                          Colors.teal[400]!
                        ],
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
                      contentPadding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
                      title: Text(
                        athkar.category,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          height: 1.4,
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
