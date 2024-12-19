/*import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'cart_screen.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({Key? key}) : super(key: key);

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  List<dynamic> _medicineList = [];
  List<Map<String, dynamic>> _cart = [];
  int _cartItemCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchMedicineData();
  }

  Future<void> _fetchMedicineData() async {
    const url =
        'https://api.myjson.online/v1/records/9458b4fa-9bdc-4c39-816d-6a17ec881800';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _medicineList = data['data']['medicines'] ?? [];
        });
      } else {
        throw Exception('Failed to load medicines');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  void _addToCart(Map<String, dynamic> medicine) {
    final existingItem = _cart.firstWhere(
            (item) => item['id'] == medicine['id'],
        orElse: () => {});
    if (existingItem.isNotEmpty) {
      setState(() {
        existingItem['quantity'] = (existingItem['quantity'] as int) + 1;
      });
    } else {
      setState(() {
        _cart.add({
          'id': medicine['id'],
          'name': medicine['name'],
          'price': (medicine['price'] as num).toInt(), // Explicitly cast to int
          'quantity': 1,
        });
      });
    }

    setState(() {
      _cartItemCount++;
    });
  }

  void _updateQuantity(Map<String, dynamic> medicine, int change) {
    final existingItem = _cart.firstWhere(
            (item) => item['id'] == medicine['id'],
        orElse: () => {});
    if (existingItem.isNotEmpty) {
      setState(() {
        existingItem['quantity'] = (existingItem['quantity'] as int) + change;
        if (existingItem['quantity'] <= 0) {
          _cart.remove(existingItem);
        }
      });
    }

    setState(() {
      _cartItemCount = _cart.fold<int>(
          0, (sum, item) => sum + (item['quantity'] as int)); // Use fold
    });
  }

  void _openCartScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            CartScreen(cart: _cart, onCartUpdate: _updateCart),
      ),
    );
  }

  void _updateCart(List<Map<String, dynamic>> updatedCart) {
    setState(() {
      _cart = updatedCart;
      _cartItemCount = _cart.fold<int>(
          0, (sum, item) => sum + (item['quantity'] as int)); // Use fold
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medicine Shop'),
        backgroundColor: Colors.green,
      ),
      body: _medicineList.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2 / 2.5,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: _medicineList.length,
          itemBuilder: (context, index) {
            final medicine = _medicineList[index];
            final inCart = _cart
                .where((item) => item['id'] == medicine['id'])
                .isNotEmpty;

            return Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network(
                        medicine['icon'],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                        Image.asset('assets/images/napa.jpg',fit: BoxFit.contain,),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      medicine['name'],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      '\$${(medicine['price'] as num).toInt()}',
                      style: const TextStyle(
                          fontSize: 14, color: Colors.green),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: inCart
                        ? Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle,
                              color: Colors.red),
                          onPressed: () =>
                              _updateQuantity(medicine, -1),
                        ),
                        Text(
                          '${_cart.firstWhere((item) => item['id'] == medicine['id'])['quantity']}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_circle,
                              color: Colors.green),
                          onPressed: () =>
                              _updateQuantity(medicine, 1),
                        ),
                      ],
                    )
                        : ElevatedButton(
                      onPressed: () => _addToCart(medicine),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: const Text('Add'),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: Stack(
        children: [
          FloatingActionButton(
            onPressed: _openCartScreen,
            backgroundColor: Colors.green,
            child: const Icon(Icons.shopping_cart),
          ),
          if (_cartItemCount > 0)
            Positioned(
              right: 0,
              child: CircleAvatar(
                radius: 10,
                backgroundColor: Colors.red,
                child: Text(
                  '$_cartItemCount',
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}*/
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'cart_screen.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({Key? key}) : super(key: key);

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  List<dynamic> _medicineList = [];
  List<dynamic> _filteredMedicineList = [];
  List<Map<String, dynamic>> _cart = [];
  int _cartItemCount = 0;
  bool _isSearching = false;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchMedicineData();
  }

  Future<void> _fetchMedicineData() async {
    const url =
        'https://api.myjson.online/v1/records/9458b4fa-9bdc-4c39-816d-6a17ec881800';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _medicineList = data['data']['medicines'] ?? [];
          _filteredMedicineList = _medicineList; // Initialize filtered list
        });
      } else {
        throw Exception('Failed to load medicines');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  void _addToCart(Map<String, dynamic> medicine) {
    final existingItem = _cart.firstWhere(
            (item) => item['id'] == medicine['id'],
        orElse: () => {});
    if (existingItem.isNotEmpty) {
      setState(() {
        existingItem['quantity'] = (existingItem['quantity'] as int) + 1;
      });
    } else {
      setState(() {
        _cart.add({
          'id': medicine['id'],
          'name': medicine['name'],
          'price': (medicine['price'] as num).toInt(),
          'quantity': 1,
        });
      });
    }

    setState(() {
      _cartItemCount++;
    });
  }

  void _updateQuantity(Map<String, dynamic> medicine, int change) {
    final existingItem = _cart.firstWhere(
            (item) => item['id'] == medicine['id'],
        orElse: () => {});
    if (existingItem.isNotEmpty) {
      setState(() {
        existingItem['quantity'] = (existingItem['quantity'] as int) + change;
        if (existingItem['quantity'] <= 0) {
          _cart.remove(existingItem);
        }
      });
    }

    setState(() {
      _cartItemCount = _cart.fold<int>(
          0, (sum, item) => sum + (item['quantity'] as int));
    });
  }

  void _openCartScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            CartScreen(cart: _cart, onCartUpdate: _updateCart),
      ),
    );
  }

  void _updateCart(List<Map<String, dynamic>> updatedCart) {
    setState(() {
      _cart = updatedCart;
      _cartItemCount = _cart.fold<int>(
          0, (sum, item) => sum + (item['quantity'] as int));
    });
  }

  void _startSearch() {
    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearch() {
    setState(() {
      _isSearching = false;
      _searchController.clear();
      _filteredMedicineList = _medicineList;
    });
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredMedicineList = _medicineList;
      });
      return;
    }
    setState(() {
      _filteredMedicineList = _medicineList
          .where((medicine) =>
          medicine['name'].toString().toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
          controller: _searchController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search medicines...',
            border: InputBorder.none,
          ),
          onChanged: _performSearch,
        )
            : const Text('Medicine Shop'),
        backgroundColor: Colors.green,
        actions: [
          if (_isSearching)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: _stopSearch,
            )
          else
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: _startSearch,
            ),
        ],
      ),
      body: _filteredMedicineList.isEmpty
          ? const Center(child: Text('Not available'))
          : Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2 / 2.5,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: _filteredMedicineList.length,
          itemBuilder: (context, index) {
            final medicine = _filteredMedicineList[index];
            final inCart = _cart
                .where((item) => item['id'] == medicine['id'])
                .isNotEmpty;

            return Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network(
                        medicine['icon'],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Image.asset(
                              'assets/images/napa.jpg',
                              fit: BoxFit.contain,
                            ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      medicine['name'],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      '\$${(medicine['price'] as num).toInt()}',
                      style: const TextStyle(
                          fontSize: 14, color: Colors.green),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: inCart
                        ? Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle,
                              color: Colors.red),
                          onPressed: () =>
                              _updateQuantity(medicine, -1),
                        ),
                        Text(
                          '${_cart.firstWhere((item) => item['id'] == medicine['id'])['quantity']}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_circle,
                              color: Colors.green),
                          onPressed: () =>
                              _updateQuantity(medicine, 1),
                        ),
                      ],
                    )
                        : ElevatedButton(
                      onPressed: () => _addToCart(medicine),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: const Text('Add'),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: Stack(
        children: [
          FloatingActionButton(
            onPressed: _openCartScreen,
            backgroundColor: Colors.green,
            child: const Icon(Icons.shopping_cart),
          ),
          if (_cartItemCount > 0)
            Positioned(
              right: 0,
              child: CircleAvatar(
                radius: 10,
                backgroundColor: Colors.red,
                child: Text(
                  '$_cartItemCount',
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

