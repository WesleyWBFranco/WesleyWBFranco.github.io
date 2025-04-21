import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lista_de_presentes/services/cart_services.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartService>(context);
    final total = cart.items.fold<double>(
      0,
      (sum, item) => sum + (item.present.price * item.selectedQuantity),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.only(
          bottom: 100,
        ), 
        children:
            cart.items.map((item) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: const Color.fromARGB(255, 5, 104, 61),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.network(
                      item.present.imagePath,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    item.present.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    'R\$ ${(item.present.price * item.selectedQuantity).toStringAsFixed(2)}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.remove,
                          color: Color.fromARGB(255, 5, 104, 61),
                        ),
                        onPressed: () => cart.decreaseQuantity(item),
                      ),
                      Text('${item.selectedQuantity}'),
                      IconButton(
                        icon: const Icon(
                          Icons.add,
                          color: Color.fromARGB(255, 5, 104, 61),
                        ),
                        onPressed: () => cart.increaseQuantity(item),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
        width: MediaQuery.of(context).size.width * 0.6,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 5, 104, 61),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder:
                  (context) => AlertDialog(
                    title: const Text('Confirmar Presentes'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Total: R\$ ${total.toStringAsFixed(2)}'),
                        const SizedBox(height: 12),
                        const Text('Chave Pix:'),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Expanded(
                              child: SelectableText(
                                '08699181922',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () async {
                                await Clipboard.setData(
                                  const ClipboardData(
                                    text: 'sua_chave_pix_aqui',
                                  ),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Chave Pix copiada!'),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.copy),
                              label: const Text('Copiar Chave'),
                            ),
                          ],
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        child: const Text('Cancelar'),
                        onPressed: () => Navigator.pop(context),
                      ),
                      TextButton(
                        child: const Text('Confirmar'),
                        onPressed: () async {
                          final cart = Provider.of<CartService>(
                            context,
                            listen: false,
                          );

                          final List<Map<String, dynamic>> itemsData =
                              cart.items.map((item) {
                                return {
                                  'name': item.present.name,
                                  'price': item.present.price,
                                  'quantity': item.selectedQuantity,
                                  'total':
                                      item.present.price *
                                      item.selectedQuantity,
                                };
                              }).toList();

                          final double totalPrice = itemsData.fold<double>(
                            0,
                            (sum, item) => sum + (item['total'] as double),
                          );

                          Navigator.pop(context);
                          await cart.confirmPurchaseAndUpdateFirebase();
                          final firestore = FirebaseFirestore.instance;
                          await firestore.collection('compras').add({
                            'items': itemsData,
                            'total': totalPrice,
                            'timestamp': FieldValue.serverTimestamp(),
                          });
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Presentes confirmados!'),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
            );
          },
          child: Text(
            'Confirmar - Total R\$ ${total.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
