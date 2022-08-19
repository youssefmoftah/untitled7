import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:untitled7/youssef.dart';
import 'goods_model.dart';
import 'package:dio/dio.dart';
import 'youssef.dart';

import 'itemlist.dart';
main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FirstScreen(),
    );
  }
}class FirstScreen extends StatefulWidget {
  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  Dio dio = Dio();
  String url = "https://fakestoreapi.com/products";
  List<dynamic> itemList = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<List<dynamic>> getData() async {
    Response response = await dio.get(url);
    print(response.statusCode);
    print(response.data);
    itemList =
        response.data.map((product) => GoodsModel.fromJson(product)).toList();
    return itemList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
            future: getData(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 4,
                    ),
                    itemCount: itemList.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              scrollable: true,
                              title: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Text(itemList[index].title)),
                              content: Column(
                                children: [
                                  Text(itemList[index].description),
                                  Text(itemList[index].rating.toString())
                                ],
                              ),
                            ),
                          );


                        },

                        child: Card(
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(20),
                                child: Text(
                                  itemList[index].title,
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                              Container(
                                height: 200,
                                width: 200,
                                child: Image(
                                  height: 300,
                                  width: 300,
                                  image: NetworkImage(itemList[index].image),
                                ),
                              ),
                              Text(itemList[index].rating.toString()),
                              Container(
                                  alignment: Alignment.bottomCenter,
                                  child: Text(
                                    "${itemList[index].price.toString()}\$",
                                    style: TextStyle(fontSize: 30),

                                  )),
                              TextButton(onPressed: (){}, child: Text("Buy Now",style: TextStyle(fontSize: 20),))
                            ],

                          ),
                        ),
                      );
                    });
              } else if (snapshot.hasError) {
                return Center(child: Icon(Icons.error_outline));
              } else {
                return CircularProgressIndicator();
              }
            }));
  }
}