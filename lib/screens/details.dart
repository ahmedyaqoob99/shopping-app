import 'package:flutter/material.dart';

import 'carts.dart';

class Details extends StatefulWidget {
  final String name;
  final String image;
  final String brand;
  final String price;

  Details(this.name, this.image, this.brand, this.price);

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  int count = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_sharp)),
        centerTitle: true,
        title: Text("Detail"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: Center(
                child: Hero(
                  tag: "${widget.name}",
                  child: Card(
                    shape: BeveledRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 1,
                    child: Image.network(
                      "${widget.image}",
                      width: MediaQuery.of(context).size.height * 0.40,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Product Name",
                    style: TextStyle(fontSize: 17),
                  ),
                  Text(
                    "${widget.name}",
                    style: TextStyle(fontSize: 17, color: Colors.black54),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Product Price",
                    style: TextStyle(fontSize: 17),
                  ),
                  Text(
                    "\$ ${widget.price}",
                    style: TextStyle(fontSize: 17, color: Colors.black54),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Description",
                    style: TextStyle(fontSize: 17),
                  ),
                  Text(
                    "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout ",
                    style: TextStyle(fontSize: 15, color: Colors.black54),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Quantity",
                    style: TextStyle(fontSize: 17),
                  ),
                  SizedBox(height: 5),
                  Container(
                    height: 40,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.green,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                          style: Theme.of(context).textTheme.headline5,
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
      ),
    );
  }
}
