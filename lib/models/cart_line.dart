import 'dish.dart';

/// A single configured line in the cart or a placed order: a dish, how many
/// of it, and the price per unit (which may differ from [Dish.price] once a
/// size/extras were chosen on the dish details page).
class CartLine {
  final Dish dish;
  final int quantity;
  final double unitPrice;

  const CartLine({
    required this.dish,
    required this.quantity,
    required this.unitPrice,
  });

  double get subtotal => unitPrice * quantity;

  CartLine copyWith({int? quantity}) {
    return CartLine(
      dish: dish,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice,
    );
  }
}
