import 'dart:convert';
import 'dart:io';
import 'package:apitask1/model/products.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Homepage extends StatefulWidget {
  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  var phone_token = "";
  List alldata = [];

  getproduct() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    phone_token = prefs.getString("token")!;
    print("$phone_token");

    Uri url = Uri.parse(
        "https://gluggler.app/glugglerBackend/public/api/phone/category/homeScreen");
    var response = await http.get(
      url,
      headers: {
        'Contant-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $phone_token'
      },
    );
    if (response.statusCode == 200) {
      Map m = jsonDecode(response.body);
      alldata = m['Data'];
    }
  }

  int currentPos = 0;
  bool status = false;
  List images = [
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQTIZccfNPnqalhrWev-Xo7uBhkor57_rKbkw&usqp=CAU",
    "https://wallpaperaccess.com/full/2637581.jpg"
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getproduct();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.black, size: 30),
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Color(0xffe65100),
            ),
            backgroundColor: Colors.white,
            shadowColor: Colors.transparent,
            actions: [
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.shopping_cart,
                    color: Colors.black,
                    size: 30,
                  ))
            ],
          ),
          drawer: Drawer(),
          body: (alldata != null)
              ? SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          child: TextField(
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: Icon(
                                Icons.search,
                                color: Colors.black,
                              ),
                              hintText: 'Search',
                              contentPadding: EdgeInsets.all(20),
                            ),
                          ),
                        ),
                      ),
                      CarouselSlider.builder(
                        itemCount: images.length,
                        itemBuilder: (context, index, realIdx) {
                          return Container(
                            margin: EdgeInsets.all(6.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              image: DecorationImage(
                                image: NetworkImage(images[index]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                        options: CarouselOptions(
                            autoPlay: true,
                            aspectRatio: 2.3,
                            enlargeCenterPage: true,
                            viewportFraction: 0.9,
                            // initialPage: 2,
                            onPageChanged: (index, reason) {
                              setState(() {
                                currentPos = index;
                              });
                            }),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: images.map((url) {
                          int index = images.indexOf(url);
                          return Container(
                            width: 8.0,
                            height: 8.0,
                            margin: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 2.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: currentPos == index
                                  ? Color(0xffe65100)
                                  : Color.fromRGBO(0, 0, 0, 0.4),
                            ),
                          );
                        }).toList(),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              "Categories",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          itemCount: alldata.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 8,
                                  childAspectRatio: 0.7),
                          itemBuilder: (context, index) {
                            Map m = alldata[index];

                            Products user = Products.fromJson(m);
                            return Container(
                                child: Stack(
                              children: [
                                Container(
                                  height: 200,
                                  width: 100,
                                ),
                                Positioned(
                                  top: 50,
                                  child: Card(
                                    child: Container(
                                      alignment: Alignment.bottomCenter,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8),
                                        child: Text(
                                          "${user.name}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      height: 100,
                                      width: 100,
                                    ),
                                  ),
                                ),
                                // Container(height: 50,width: 100,),
                                Image.network(
                                  "${user.images![0]}",
                                  fit: BoxFit.fitHeight,
                                  height: 120,
                                  width: 120,
                                ),
                              ],
                            ));
                          },
                        ),
                      )
                    ],
                  ),
                )
              : Center(
                  child: CircularProgressIndicator(),
                )),
    );
  }
}
