// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shopping_app/screens/checkout.dart';

class Cart extends StatefulWidget {
  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  int count = 1;
  List prices = [];
  final Stream<QuerySnapshot> _cartStream =
      FirebaseFirestore.instance.collection('cart').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_sharp)),
        centerTitle: true,
        title: const Text("Cart"),
      ),
      bottomNavigationBar: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) {
                return CheckOut();
              },
            ),
          );
        },
        child: Text("Checkout"),
      ),
      body: SingleChildScrollView(
        child: StreamBuilder<QuerySnapshot>(
          stream: _cartStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              return ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map data = document.data()! as Map;
                  prices.add(data["price"]);
                  return Card(
                    elevation: 0.8,
                    child: Row(
                      children: [
                        Container(
                          child: Card(
                            shape: BeveledRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            elevation: 1,
                            child: Image.network(
                              data["image"],
                              width: MediaQuery.of(context).size.width * 0.30,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    data["name"],
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      try {
                                        FirebaseFirestore db =
                                            FirebaseFirestore.instance;
                                        await db
                                            .collection("cart")
                                            .doc(document.id)
                                            .delete();

                                        print("Successfully Deleted");
                                      } catch (e) {
                                        print("delete Error ===>  $e");
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                  )
                                ],
                              ),
                              Text(
                                data["brand"],
                                style: const TextStyle(fontSize: 15),
                              ),
                              Text(
                                "\$ ${data["price"]}",
                                style: const TextStyle(
                                    fontSize: 15, color: Colors.black54),
                              ),
                              const SizedBox(height: 5),
                              Container(
                                height: 30,
                                width: 80,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: Colors.green,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (count > 1) count -= 1;
                                        });
                                      },
                                      child: Icon(Icons.remove),
                                    ),
                                    Text(
                                      "$count",
                                      style:
                                          Theme.of(context).textTheme.headline6,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          count += 1;
                                        });
                                      },
                                      child: Icon(Icons.add),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text("Error"),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
