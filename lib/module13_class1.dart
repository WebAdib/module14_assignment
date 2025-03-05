import 'package:flutter/material.dart';
import 'package:module14_assignment/productController.dart';

class Module13Class1 extends StatefulWidget {
  const Module13Class1({super.key});

  @override
  State<Module13Class1> createState() => _Module13Class1State();
}

class _Module13Class1State extends State<Module13Class1> {
  final ProductController _productController = ProductController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    try {
      await _productController.fetchProducts();
    } catch (e) {
      debugPrint("Error in _fetchProducts: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _addProduct(Map<String, dynamic> product) {
    setState(() {
      _productController.addProduct(product);
    });
  }

  void _deleteProduct(int index) {
    setState(() {
      _productController.deleteProduct(index);
    });
  }

  void _showAddProductDialog() {
    TextEditingController nameController = TextEditingController();
    TextEditingController imgController = TextEditingController();
    TextEditingController qtyController = TextEditingController();
    TextEditingController unitPriceController = TextEditingController();
    TextEditingController totalPriceController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add Product"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: "Product Name"),
                ),
                TextField(
                  controller: imgController,
                  decoration: InputDecoration(labelText: "Image URL"),
                ),
                TextField(
                  controller: qtyController,
                  decoration: InputDecoration(labelText: "Quantity"),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: unitPriceController,
                  decoration: InputDecoration(labelText: "Unit Price"),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: totalPriceController,
                  decoration: InputDecoration(labelText: "Total Price"),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                int qty = int.tryParse(qtyController.text) ?? 0;
                int unitPrice = int.tryParse(unitPriceController.text) ?? 0;
                int totalPrice = qty * unitPrice;

                Map<String, dynamic> newProduct = {
                  "ProductName": nameController.text,
                  "ProductCode":
                      DateTime.now().millisecondsSinceEpoch, // Auto-generated
                  "Img": imgController.text,
                  "Qty": qty,
                  "UnitPrice": unitPrice,
                  "TotalPrice": totalPrice,
                };

                _addProduct(newProduct);
                _fetchProducts();
                Navigator.pop(context);
              },
              child: Text("Add Product"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Products')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _productController.products.isEmpty
              ? Center(child: Text("No products available."))
              : ListView.builder(
                  itemCount: _productController.products.length,
                  itemBuilder: (context, index) {
                    final product = _productController.products[index];
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      elevation: 3,
                      child: ListTile(
                        contentPadding: EdgeInsets.all(10),
                        leading: Image.network(
                          product["Img"],
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Icon(Icons.image),
                        ),
                        title: Text(product["ProductName"],
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(
                          "Code: ${product["ProductCode"]} | Qty: ${product["Qty"]} | Price: \$${product["UnitPrice"]}",
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                onPressed: () {}, icon: Icon(Icons.edit)),
                            IconButton(
                              onPressed: () => _deleteProduct(index),
                              icon: Icon(Icons.delete, color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddProductDialog,
        tooltip: 'Add',
        child: Icon(Icons.add),
      ),
    );
  }
}
