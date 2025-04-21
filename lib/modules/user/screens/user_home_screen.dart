import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lista_de_presentes/data/models/present.dart';
import 'package:lista_de_presentes/modules/user/widgets/present_card.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  String selectedCategory = 'Todos';
  List<String> categories = ['Todos'];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  void _loadCategories() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('presents').get();
    final uniqueCategories =
        snapshot.docs
            .map((doc) => doc['category']?.toString() ?? '')
            .where((category) => category.isNotEmpty)
            .toSet()
            .toList();

    setState(() {
      categories = ['Todos', ...uniqueCategories];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Pesquisar por nome ou preço',
                hintStyle: TextStyle(color: Colors.grey[500]),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: const Color.fromARGB(255, 196, 196, 196),
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: const Color.fromARGB(255, 6, 112, 61),
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                fillColor: Colors.white,
                filled: true,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final isSelected = selectedCategory == category;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: FilterChip(
                      label: Text(category),
                      selected: isSelected,
                      selectedColor: const Color.fromARGB(255, 6, 112, 61),
                      backgroundColor: Colors.white,
                      labelStyle: TextStyle(
                        color:
                            isSelected
                                ? Colors.white
                                : const Color.fromARGB(255, 6, 112, 61),
                        fontWeight: FontWeight.bold,
                      ),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: const Color.fromARGB(255, 6, 112, 61),
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      showCheckmark: false,
                      onSelected: (bool selected) {
                        setState(() {
                          selectedCategory = selected ? category : 'Todos';
                        });
                      },
                    ),
                  );
                },
              ),
            ),
          ),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance
                      .collection('presents')
                      .orderBy('price')
                      .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text('Nenhum presente encontrado'),
                  );
                }

                final docs = snapshot.data!.docs;

                final presents =
                    docs
                        .map((doc) {
                          final data = doc.data() as Map<String, dynamic>;
                          return Present(
                            name: data['name'] ?? '',
                            price: (data['price'] ?? 0).toDouble(),
                            imagePath: data['imagePath'] ?? '',
                            quantity: data['quantity'] ?? 0,
                            category: data['category'] ?? '',
                          );
                        })
                        .where(
                          (present) =>
                              selectedCategory == 'Todos' ||
                              present.category == selectedCategory,
                        )
                        .toList();

                return GridView.builder(
                  itemCount: presents.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.53,
                  ),
                  itemBuilder: (context, index) {
                    final present = presents[index];
                    final doc = getDocForPresent(present, docs);

                    if (doc == null) return const SizedBox.shrink();

                    return PresentCard(present: present, documentId: doc.id);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

QueryDocumentSnapshot? getDocForPresent(
  Present present,
  List<QueryDocumentSnapshot> docs,
) {
  try {
    return docs.firstWhere((d) => d['name'] == present.name);
  } catch (e) {
    return null;
  }
}