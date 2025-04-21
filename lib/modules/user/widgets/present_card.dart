import 'package:flutter/material.dart';
import 'package:lista_de_presentes/data/models/present.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lista_de_presentes/services/cart_services.dart';
import 'package:provider/provider.dart';

class PresentCard extends StatefulWidget {
  final Present present;
  final String documentId;
  final double imageHeight;

  const PresentCard({
    super.key,
    required this.present,
    required this.documentId,
    this.imageHeight = 150.0,
  });

  @override
  State<PresentCard> createState() => _PresentCardState();
}

class _PresentCardState extends State<PresentCard> {
  int selectedQuantity = 1;

  @override
  Widget build(BuildContext context) {
    final totalPrice = widget.present.price * selectedQuantity;
    final isComplete = widget.present.quantity == 0;

    return Stack(
      children: [
        Card(
          color: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color: const Color.fromARGB(255, 39, 93, 80),
              width: 2,
            ),
          ),
          margin: const EdgeInsets.all(10),
          child: Opacity(
            opacity: isComplete ? 0.5 : 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(8),
                  ),
                  child: SizedBox(
                    height: widget.imageHeight,
                    width: double.infinity,
                    child:
                        widget.present.imagePath.isNotEmpty
                            ? Image.network(
                              widget.present.imagePath,
                              fit: BoxFit.scaleDown,
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(
                                  child: Icon(Icons.image_not_supported),
                                );
                              },
                            )
                            : const Center(child: Icon(Icons.image)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.present.name,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      if (!isComplete)
                        SizedBox(
                          width: double.infinity,
                          child: PopupMenuButton<int>(
                            onSelected: (value) {
                              setState(() {
                                selectedQuantity = value;
                              });
                            },
                            itemBuilder: (context) {
                              return List.generate(widget.present.quantity, (
                                index,
                              ) {
                                final quantity = index + 1;
                                return PopupMenuItem(
                                  value: quantity,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  child: Text('Quantidade: $quantity'),
                                );
                              });
                            },
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: const BorderSide(
                                color: Color.fromARGB(255, 39, 93, 80),
                                width: 2,
                              ),
                            ),
                            child: OutlinedButton(
                              onPressed: null,
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                  color: Color.fromARGB(255, 39, 93, 80),
                                  width: 2,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                              ),
                              child: Text(
                                'Quantidade: $selectedQuantity',
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 39, 93, 80),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Disponível: ${widget.present.quantity}',
                            style: const TextStyle(
                              color: Color.fromARGB(255, 39, 93, 80),
                              fontWeight: FontWeight.w500,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'R\$ ${totalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child:
                            isComplete
                                ? ElevatedButton.icon(
                                  onPressed: null,
                                  icon: const Icon(
                                    Icons.check_circle_outline,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  label: const Text(
                                    'Presenteado',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                    ),
                                  ),
                                )
                                : ElevatedButton.icon(
                                  onPressed: () {
                                    final cart = Provider.of<CartService>(
                                      context,
                                      listen: false,
                                    );
                                    cart.addToCart(
                                      widget.present,
                                      widget.documentId,
                                      selectedQuantity,
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Adicionado ao carrinho!',
                                        ),
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    FontAwesomeIcons.gift,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  label: const Text(
                                    'Presentear',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color.fromARGB(
                                      255,
                                      39,
                                      93,
                                      80,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                    ),
                                  ),
                                ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Banner de presente completo
        if (isComplete)
          Positioned(
            top: 12,
            left: -30,
            child: Transform.rotate(
              angle: -0.5,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 4,
                ),
                color: Colors.green.shade700,
                child: const Text(
                  'COMPLETO',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
