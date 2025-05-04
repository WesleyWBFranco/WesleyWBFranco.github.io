import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
          color: Color.fromARGB(255, 253, 243, 222),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color: const Color.fromARGB(255, 39, 93, 80),
              width: 2,
            ),
          ),
          margin: const EdgeInsets.all(10),
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
                      style: GoogleFonts.cormorantSc(
                        color: Color.fromARGB(255, 39, 93, 80),
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    isComplete
                        ? SizedBox(height: 50)
                        : SizedBox(
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
                                  child: Text(
                                    'Quantidade: $quantity',
                                    style: GoogleFonts.cormorantSc(
                                      color: Color.fromARGB(255, 39, 93, 80),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                );
                              });
                            },
                            color: Color.fromARGB(255, 253, 243, 222),
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
                                style: GoogleFonts.cormorantSc(
                                  color: Color.fromARGB(255, 39, 93, 80),
                                  fontWeight: FontWeight.w600,
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
                          style: GoogleFonts.rajdhani(
                            color: Color.fromARGB(255, 39, 93, 80),
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'R\$ ${totalPrice.toStringAsFixed(2)}',
                      style: GoogleFonts.rajdhani(
                        color: Color.fromARGB(255, 39, 93, 80),
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
                                  color: Color.fromARGB(255, 39, 93, 80),
                                  size: 16,
                                ),
                                label: Text(
                                  'Presenteado',
                                  style: GoogleFonts.cormorantSc(
                                    color: Color.fromARGB(255, 39, 93, 80),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  disabledBackgroundColor: Color.fromARGB(
                                    255,
                                    253,
                                    243,
                                    222,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    side: BorderSide(
                                      color: const Color.fromARGB(
                                        255,
                                        39,
                                        93,
                                        80,
                                      ),
                                      width: 1.5,
                                    ),
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
                                      content: Text('Adicionado ao carrinho!'),
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  FontAwesomeIcons.gift,
                                  color: Color.fromARGB(255, 253, 243, 222),
                                  size: 16,
                                ),
                                label: Text(
                                  'Presentear',
                                  style: GoogleFonts.cormorantSc(
                                    color: Color.fromARGB(255, 253, 243, 222),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
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

        if (isComplete)
          Padding(
            padding: const EdgeInsets.all(12),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset('assets/images/laço.png'),
            ),
          ),
      ],
    );
  }
}
