import 'package:flutter/foundation.dart';
import '../models/cart_line.dart';
import '../models/dish.dart';

/// Local mock cart state: tracks the configured dish lines the customer has
/// added, until they check out (see [OrdersProvider]).
class CartProvider extends ChangeNotifier {
  final List<CartLine> _lines = [];

  List<CartLine> get lines => List.unmodifiable(_lines);

  bool get isEmpty => _lines.isEmpty;

  int get totalItems => _lines.fold(0, (sum, line) => sum + line.quantity);

  double get totalPrice => _lines.fold(0, (sum, line) => sum + line.subtotal);

  int quantityOf(String dishId) => _lines
      .where((line) => line.dish.id == dishId)
      .fold(0, (sum, line) => sum + line.quantity);

  /// Adds [dish] to the cart. Matching lines (same dish and unit price -
  /// i.e. same size/extras configuration) merge into one instead of
  /// duplicating.
  void add(Dish dish, {int quantity = 1, double? unitPrice}) {
    final price = unitPrice ?? dish.price;
    final index = _lines.indexWhere(
      (line) => line.dish.id == dish.id && line.unitPrice == price,
    );
    if (index != -1) {
      _lines[index] = _lines[index].copyWith(
        quantity: _lines[index].quantity + quantity,
      );
    } else {
      _lines.add(CartLine(dish: dish, quantity: quantity, unitPrice: price));
    }
    notifyListeners();
  }

  void removeLine(CartLine line) {
    _lines.remove(line);
    notifyListeners();
  }

  /// Sets [line]'s quantity directly, removing it if the new quantity is
  /// zero or less.
  void updateQuantity(CartLine line, int quantity) {
    final index = _lines.indexOf(line);
    if (index == -1) return;
    if (quantity <= 0) {
      _lines.removeAt(index);
    } else {
      _lines[index] = _lines[index].copyWith(quantity: quantity);
    }
    notifyListeners();
  }

  void clear() {
    _lines.clear();
    notifyListeners();
  }
}
