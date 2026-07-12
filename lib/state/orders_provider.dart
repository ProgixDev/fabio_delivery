import 'package:flutter/foundation.dart';
import '../models/cart_line.dart';
import '../models/order.dart';

/// Local mock order history: orders placed from the cart, most recent
/// first.
class OrdersProvider extends ChangeNotifier {
  final List<Order> _orders = [];

  List<Order> get orders => List.unmodifiable(_orders.reversed);

  int get activeCount =>
      _orders.where((order) => order.status != OrderStatus.delivered).length;

  Order placeOrder({required List<CartLine> lines, required double total}) {
    final placedAt = DateTime.now();
    final order = Order(
      id: 'o${_orders.length + 1}-${placedAt.millisecondsSinceEpoch}',
      placedAt: placedAt,
      lines: lines,
      total: total,
    );
    _orders.add(order);
    notifyListeners();
    return order;
  }
}
