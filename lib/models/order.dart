import 'cart_line.dart';

enum OrderStatus { preparing, onTheWay, delivered }

extension OrderStatusLabel on OrderStatus {
  String get label => switch (this) {
    OrderStatus.preparing => 'En préparation',
    OrderStatus.onTheWay => 'En livraison',
    OrderStatus.delivered => 'Livrée',
  };
}

/// A placed order: a snapshot of the cart's lines at checkout time.
class Order {
  final String id;
  final DateTime placedAt;
  final List<CartLine> lines;
  final double total;
  final OrderStatus status;

  const Order({
    required this.id,
    required this.placedAt,
    required this.lines,
    required this.total,
    this.status = OrderStatus.preparing,
  });

  int get itemCount => lines.fold(0, (sum, line) => sum + line.quantity);
}
