import 'package:flutter/material.dart';
import 'package:lista_de_presentes/services/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lista_de_presentes/data/models/present.dart';

class CrudScreen extends StatefulWidget {
  const CrudScreen({super.key});

  @override
  State<CrudScreen> createState() => _CrudScreenState();
}

class _CrudScreenState extends State<CrudScreen> {
  final FirestoreService firestoreService = FirestoreService();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController imagePathController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();

  String selectedCategory = 'Todas';
  List<String> categories = ['Todas'];
  List<String> _existingCategories = [];
  String? _selectedExistingCategory;

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _loadExistingCategories();
  }

  Future<void> _loadCategories() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('presents').get();
    final uniqueCategories =
        snapshot.docs
            .map((doc) => doc['category']?.toString() ?? '')
            .where((category) => category.isNotEmpty)
            .toSet()
            .toList();

    setState(() {
      categories = ['Todas', ...uniqueCategories];
    });
  }

  Future<void> _loadExistingCategories() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('presents').get();
    final uniqueCategories =
        snapshot.docs
            .map((doc) => doc['category']?.toString() ?? '')
            .where((category) => category.isNotEmpty)
            .toSet()
            .toList()
          ..sort();

    setState(() {
      _existingCategories = uniqueCategories;
    });
  }

  void openPresentBox({
    String? docID,
    Map<String, dynamic>? existingData,
  }) async {
    _selectedExistingCategory = null;
    if (existingData != null) {
      nameController.text = existingData['name'] ?? '';
      priceController.text = (existingData['price'] ?? '').toString();
      imagePathController.text = existingData['imagePath'] ?? '';
      quantityController.text = (existingData['quantity'] ?? '').toString();
      categoryController.text = existingData['category'] ?? '';
      _selectedExistingCategory = existingData['category'];
    } else {
      nameController.clear();
      priceController.clear();
      imagePathController.clear();
      quantityController.clear();
      categoryController.clear();
    }

    await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              docID == null ? "Adicionar Presente" : "Editar Presente",
            ),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: "Nome"),
                  ),
                  TextField(
                    controller: priceController,
                    decoration: const InputDecoration(labelText: "Preço"),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: imagePathController,
                    decoration: const InputDecoration(
                      labelText: "Caminho da Imagem",
                    ),
                  ),
                  TextField(
                    controller: quantityController,
                    decoration: const InputDecoration(labelText: "Quantidade"),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Categoria:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: "Selecionar Categoria Existente (opcional)",
                      border: OutlineInputBorder(),
                    ),
                    value: _selectedExistingCategory,
                    items:
                        _existingCategories.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedExistingCategory = newValue;
                        if (newValue != null) {
                          categoryController.text = newValue;
                        }
                      });
                    },
                    isExpanded: true,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: categoryController,
                    decoration: const InputDecoration(
                      labelText: "Ou digite uma nova categoria",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () async {
                  final present = Present(
                    name: nameController.text,
                    price: double.tryParse(priceController.text) ?? 0.0,
                    imagePath: imagePathController.text,
                    quantity: int.tryParse(quantityController.text) ?? 0,
                    category: categoryController.text.trim(),
                  );

                  if (docID == null) {
                    await firestoreService.addPresent(present);
                  } else {
                    await firestoreService.updatePresent(docID, present);
                  }

                  Navigator.pop(context);
                },
                child: const Text("Salvar"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 5, 104, 61),
        onPressed: () => openPresentBox(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
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
                  borderSide: const BorderSide(
                    color: Color.fromARGB(255, 196, 196, 196),
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Color.fromARGB(255, 5, 104, 61),
                    width: 2,
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
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      showCheckmark: false,
                      onSelected: (bool selected) {
                        setState(() {
                          selectedCategory = selected ? category : 'Todas';
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
              stream: firestoreService.getPresentsStream(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final docs =
                      snapshot.data!.docs.where((doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        final category = data['category']?.toString() ?? '';
                        return selectedCategory == 'Todas' ||
                            category == selectedCategory;
                      }).toList();

                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final doc = docs[index];
                      final data = doc.data() as Map<String, dynamic>;

                      return Container(
                        margin: const EdgeInsets.only(
                          top: 10,
                          left: 12,
                          right: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: const Color.fromARGB(255, 5, 104, 61),
                            width: 2.0,
                          ),
                        ),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: SizedBox(
                              width: 50,
                              height: 50,
                              child: Image.network(
                                data['imagePath'] ?? '',
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (context, error, stackTrace) =>
                                        const Icon(Icons.image_not_supported),
                              ),
                            ),
                          ),
                          title: Text(
                            data['name'] ?? 'Sem nome',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            'R\$ ${data['price']?.toStringAsFixed(2) ?? '0.00'}',
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed:
                                    () => openPresentBox(
                                      docID: doc.id,
                                      existingData: data,
                                    ),
                                icon: const Icon(
                                  Icons.edit,
                                  color: Color.fromARGB(255, 5, 104, 61),
                                ),
                              ),
                              IconButton(
                                onPressed:
                                    () =>
                                        firestoreService.deletePresent(doc.id),
                                icon: const Icon(
                                  Icons.delete,
                                  color: Color.fromARGB(255, 5, 104, 61),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
