import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProductDetailPage extends StatefulWidget {
  final String productID;

  const ProductDetailPage({Key? key, required this.productID}) : super(key: key);

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int orderQuantity = 1;
  int minimumQuantityLocal = 1;

  @override
  void initState() {
    super.initState();
    fetchProductDetails().then((product) {
      if (product.exists) {
        int minimumQuantity = int.parse(product['minimumQuantity'].toString());
        setState(() {
          orderQuantity = minimumQuantity;
          minimumQuantityLocal = minimumQuantity;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
      ),
      body: FutureBuilder(
        future: fetchProductDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          var product = snapshot.data;
          if (product == null || !product.exists) {
            return const Center(child: Text('Product not found'));
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  product['imageURL'],
                  width: double.infinity,
                  height: 200.0,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Each vendor has some minimum order demands and hence the minimum possible is set at first.',
                        style: TextStyle(fontSize: 14.0),
                      ),
                      const SizedBox(height: 36.0),
                      Text(
                        product['productTitle'],
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'Category: ${product['category'] ?? ''}',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'Price: \$${calculateTotalPrice(product)}',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.cyan),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'Description: ${product['productDescription'] ?? ''}',
                        style: const TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  if (orderQuantity > minimumQuantityLocal) {
                    orderQuantity--;
                  }
                });
              },
              icon: const Icon(Icons.remove),
            ),
            Text(
              'Quantity: $orderQuantity',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  orderQuantity++;
                });
              },
              icon: const Icon(Icons.add),
            ),
            ElevatedButton(
              onPressed: () {
                addToCart(context, widget.productID, orderQuantity);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyan,
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              ),
              child: const Text(
                'Add to Cart',
                style: TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<DocumentSnapshot> fetchProductDetails() async {
    try {
      return await FirebaseFirestore.instance.collection('products').doc(widget.productID).get();
    } catch (e) {
      print("Error fetching product details: $e");
      rethrow;
    }
  }

  String calculateTotalPrice(DocumentSnapshot product) {
    double priceOfOneItem = double.parse(product['priceOfOneItem'].toString());
    int minimumQuantity = int.parse(product['minimumQuantity'].toString());
    double totalPrice = priceOfOneItem * minimumQuantity;
    return totalPrice.toStringAsFixed(2);
  }

  void addToCart(BuildContext context, String productID, int orderQuantity) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        String buyerId = user.uid;

        CollectionReference buyerCollection = FirebaseFirestore.instance.collection('buyers');
        QuerySnapshot buyerQuery = await buyerCollection.where('buyerId', isEqualTo: buyerId).get();

        if (buyerQuery.docs.isNotEmpty) {
          CollectionReference cartCollection = buyerCollection.doc(buyerId).collection('cart');

          await cartCollection.add({
            'productID': productID,
            'orderQuantity': orderQuantity,
            'timestamp': FieldValue.serverTimestamp(),
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Product added to cart')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Buyer not found')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not logged in')),
        );
      }
    } catch (e) {
      print("Error adding to cart: $e");
    }
  }
}
