import 'package:flutter/material.dart';

import 'thank_screen.dart';

class CartScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cart;
  final Function(List<Map<String, dynamic>>) onCartUpdate;

  const CartScreen({Key? key, required this.cart, required this.onCartUpdate})
      : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Map<String, dynamic>> _cart = [];

  @override
  void initState() {
    super.initState();
    _cart = List<Map<String, dynamic>>.from(widget.cart);
  }

  void _updateQuantity(int index, int change) {
    setState(() {
      _cart[index]['quantity'] += change;
      if (_cart[index]['quantity'] <= 0) {
        _cart.removeAt(index);
      }
    });
    widget.onCartUpdate(_cart);
  }

  void _deleteItem(int index) {
    setState(() {
      _cart.removeAt(index);
    });
    widget.onCartUpdate(_cart);
  }

  double _calculateTotal() {
    return _cart.fold(0, (sum, item) => sum + (item['price'] * item['quantity']));
  }

  void _proceedToCheckout() {
    if (_cart.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ThanksScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Medicine Cart'),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _cart.length,
              itemBuilder: (context, index) {
                final item = _cart[index];
                return Card(
                  margin:
                  const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: NetworkImage(
                                    item['image'] ??
                                        'https://via.placeholder.com/60',
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['name'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '\$${item['price']}',
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove_circle,
                                      color: Colors.red),
                                  onPressed: () => _updateQuantity(index, -1),
                                ),
                                Text(
                                  '${item['quantity']}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add_circle,
                                      color: Colors.green),
                                  onPressed: () => _updateQuantity(index, 1),
                                ),
                              ],
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteItem(index),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Cart Total:',
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '\$${_calculateTotal().toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _cart.isNotEmpty ? _proceedToCheckout : null,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Proceed to Checkout',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


