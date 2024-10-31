import 'package:flutter/material.dart';
import 'package:food_app/common/color_extension.dart';
import 'package:food_app/common_widget/direct_button.dart';
import 'package:food_app/payment/option_payment.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  State<Cart> createState() => _CartState();
  static List<Map<String, dynamic>> cartItems = [];
}

class _CartState extends State<Cart> {
  void checkout() {
    _saveReceiptToPreferences();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => OptionPayment()));
  }

  void _clearCart() {
    setState(() {
      Cart.cartItems.clear();
    });
  }

  void _increaseQuantity(int index) {
    setState(() {
      Cart.cartItems[index]['quantity']++;
    });
  }

  void _decreaseQuantity(int index) {
    setState(() {
      if (Cart.cartItems[index]['quantity'] > 1) {
        Cart.cartItems[index]['quantity']--;
      }
    });
  }

  double _calculateTotal() {
    double total = 0.0;
    for (var cartItem in Cart.cartItems) {
      double price = cartItem['price'] ?? 0.0;
      total += price * cartItem['quantity'];
    }
    return total;
  }

  String totalFormatted() {
    NumberFormat currencyFormat =
        NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ');
    var formattedPrice = currencyFormat.format(_calculateTotal());
    return formattedPrice;
  }

  Future<void> _saveReceiptToPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final receipt = displayCartReceipt();
    await prefs.setString('cartReceipt', receipt);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Cart"),
          actions: [
            IconButton(
              icon: const Icon(color: Colors.red, Icons.delete),
              onPressed: _clearCart,
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
                child: Container(
              child: ListView.builder(
                itemCount: Cart.cartItems.length,
                itemBuilder: (context, index) {
                  var cartItem = Cart.cartItems[index];
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: TColor.alertBackColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            cartItem['item']['tenSP'],
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () => _decreaseQuantity(index),
                              ),
                              Text('Quantity: ${cartItem['quantity']}'),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () => _increaseQuantity(index),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )),
            Container(
              color: TColor.primary,
              padding: const EdgeInsets.all(25),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total: ",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                      Text(
                        "${totalFormatted()}",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  DirectButton(text: "Check out", onTap: checkout)
                ],
              ),
            )
          ],
        ));
  }

  String displayCartReceipt() {
    final receipt = StringBuffer();
    receipt.writeln("Hóa đơn của bạn");
    receipt.writeln();
    //
    String formattedDate =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

    receipt.writeln(formattedDate);
    receipt.writeln();
    receipt.writeln("-------------");
    for (final cartItem in Cart.cartItems) {
      receipt.writeln(
          "${cartItem['quantity']} x ${cartItem['item']['tenSP']} - ${cartItem['price']}");
    }
    receipt.writeln("-------------");
    receipt.writeln();
    receipt.writeln("Tổng tiền: ${totalFormatted()}");

    return receipt.toString();
  }
}
