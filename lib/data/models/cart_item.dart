import 'package:lista_de_presentes/data/models/present.dart';

class CartItem {
  final Present present;
  final String presentId;
  int selectedQuantity;

  CartItem({
    required this.present,
    required this.presentId,
    required this.selectedQuantity,
  });
}
