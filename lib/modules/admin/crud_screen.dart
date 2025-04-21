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

  void openPresentBox({
    String? docID,
    Map<String, dynamic>? existingData,
  }) async {
    if (existingData != null) {
      nameController.text = existingData['name'] ?? '';
      priceController.text = (existingData['price'] ?? '').toString();
      imagePathController.text = existingData['imagePath'] ?? '';
      quantityController.text = (existingData['quantity'] ?? '').toString();
      categoryController.text = existingData['category'] ?? '';
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
                  TextField(
                    controller: categoryController,
                    decoration: const InputDecoration(labelText: "Categoria"),
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
                    category: categoryController.text,
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
                  borderSide: BorderSide(
                    color: const Color.fromARGB(255, 196, 196, 196),
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: const Color.fromARGB(255, 5, 104, 61),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                fillColor: Colors.white,
                filled: true,
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: firestoreService.getPresentsStream(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final docs = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final doc = docs[index];
                      final data = doc.data() as Map<String, dynamic>;

                      return Container(
                        margin: EdgeInsets.only(top: 10, left: 12, right: 12),
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
