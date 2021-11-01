import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/screens/carts.dart';
import 'package:shopping_app/screens/favourite.dart';
import 'package:shopping_app/screens/login_page.dart';
import 'package:shopping_app/screens/profile_screen.dart';
import 'details.dart';

List items = [];

class HomePage extends StatelessWidget {
  final Stream<QuerySnapshot> _itemStream =
      FirebaseFirestore.instance.collection('items').snapshots();

  Future signOut() async {
    await FirebaseAuth.instance.signOut();
    return LoginPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SafeArea(
        child: Drawer(
          child: ListView(
            children: [
              const DrawerHeader(
                margin: EdgeInsets.all(0),
                padding: EdgeInsets.all(0),
                child: UserAccountsDrawerHeader(
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: AssetImage("assets/images/user.jpg"),
                  ),
                  accountName: Text("Ahmed Yaqoob"),
                  accountEmail: Text(""),
                ),
              ),
              ListTile(
                selected: true,
                leading: Icon(Icons.home),
                title: Text("Home"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) {
                        return HomePage();
                      },
                    ),
                  );
                },
              ),
              ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) {
                        return Cart();
                      },
                    ),
                  );
                },
                leading: const Icon(Icons.shopping_cart),
                title: const Text("Carts"),
              ),
              ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) {
                        return Favourite();
                      },
                    ),
                  );
                },
                leading: const Icon(Icons.favorite),
                title: const Text("Favourite"),
              ),
              ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) {
                        return ProfileScreen();
                      },
                    ),
                  );
                },
                leading: const Icon(Icons.person),
                title: const Text("Profile"),
              ),
              const ListTile(
                leading: Icon(Icons.home_max),
                title: Text("Old Previous Order"),
              ),
              const ListTile(
                leading: Icon(Icons.location_city),
                title: Text("Edit Address"),
              ),
              const ListTile(
                leading: Icon(Icons.policy),
                title: Text("Policies"),
              ),
              const ListTile(
                leading: Icon(Icons.info),
                title: Text("About"),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Text("Ecommerce App"),
        actions: [
          IconButton(
              onPressed: () {
                showSearch(context: context, delegate: SearchItems());
              },
              icon: const Icon(Icons.search)),
        ],
      ),
      body: SingleChildScrollView(
        child: StreamBuilder<QuerySnapshot>(
          stream: _itemStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            } else if (snapshot.hasData) {
              return GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 0.5,
                crossAxisSpacing: 2,
                mainAxisSpacing: 3,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                physics: const NeverScrollableScrollPhysics(),
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map data = document.data()! as Map;
                  items.add(data);
                  return Container(
                    width: MediaQuery.of(context).size.width * 0.45,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(.5),
                            offset: const Offset(3, 2),
                            blurRadius: 7)
                      ],
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) {
                              return Details(
                                data["name"],
                                data["itemImage"],
                                data["brand"],
                                data["price"],
                              );
                            },
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                              ),
                              child: Hero(
                                tag: data["name"],
                                child: Image.network(
                                  data["itemImage"],
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  height:
                                      MediaQuery.of(context).size.height * 0.30,
                                ),
                              ),
                            ),
                          ),
                          Text(
                            data["name"],
                            style: const TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.normal),
                          ),
                          Text(
                            data["brand"],
                            style: const TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                                fontWeight: FontWeight.normal),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  data["price"],
                                  style: const TextStyle(
                                      fontSize: 22,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.favorite_border,
                                  color: Colors.red,
                                ),
                                onPressed: () async {
                                  if (FirebaseAuth.instance.currentUser !=
                                      null) {
                                    FirebaseFirestore db =
                                        FirebaseFirestore.instance;
                                    await db.collection("favourite").add({
                                      "image": data["itemImage"],
                                      "name": data["name"],
                                      "brand": data["brand"],
                                      "price": data["price"],
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Added to Favourite"),
                                        backgroundColor: Colors.red,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                      ),
                                    );
                                    print("Favourite Succesfully Inserted");
                                  } else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) {
                                          return LoginPage();
                                        },
                                      ),
                                    );
                                  }
                                },
                              ),
                              const SizedBox(
                                width: 30,
                              ),
                              IconButton(
                                icon: const Icon(Icons.add_shopping_cart),
                                onPressed: () async {
                                  if (FirebaseAuth.instance.currentUser !=
                                      null) {
                                    FirebaseFirestore db =
                                        FirebaseFirestore.instance;
                                    await db.collection("cart").add({
                                      "image": data["itemImage"],
                                      "name": data["name"],
                                      "brand": data["brand"],
                                      "price": data["price"],
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Added to Cart"),
                                        backgroundColor: Colors.green,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                      ),
                                    );
                                    print("Cart Succesfully Inserted");
                                  } else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) {
                                          return LoginPage();
                                        },
                                      ),
                                    );
                                  }
                                },
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}

class SearchItems extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = "";
        },
        icon: Icon(Icons.close),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (_, index) {
        return ListTile(
          leading: Image.network(
            items[index]["itemImage"],
            width: 70,
          ),
          title: Text(items[index]["name"]),
          subtitle: Text(items[index]["brand"]),
        );
      },
    );
  }
}
