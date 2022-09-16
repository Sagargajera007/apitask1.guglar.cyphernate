import 'dart:convert';

import 'package:apitask1/homepage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({Key? key}) : super(key: key);

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  TextEditingController temail = TextEditingController();
  TextEditingController tpassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.white,
          ),
          backgroundColor: Colors.white,
          shadowColor: Colors.transparent,
          leading: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              )),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset("assets/undraw_Access_account_re_8spm (1).png"),
              SizedBox(
                height: 30,
              ),
              Container(
                width: double.infinity,
                decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25))),
                    color: Color(0xffe65100)),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 30, bottom: 8),
                      child: Text(
                        "Sign In",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 8, bottom: 8, left: 20, right: 20),
                      child: SizedBox(
                        height: 50,
                        child: TextFormField(
                          cursorColor: Colors.black,
                          controller: temail,
                          decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(),
                                borderRadius: const BorderRadius.all(
                                    const Radius.circular(50)),
                              ),
                              hintText: "Email",
                              hintStyle:
                                  TextStyle(color: Colors.black, fontSize: 15),
                              border: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                    const Radius.circular(50)),
                              ),
                              fillColor: Colors.white,
                              filled: true),
                          style: TextStyle(fontSize: 15.0, color: Colors.black),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 8, bottom: 8, left: 20, right: 20),
                      child: SizedBox(
                        height: 50,
                        child: TextFormField(
                          cursorColor: Colors.black,
                          controller: tpassword,
                          decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(),
                                borderRadius: const BorderRadius.all(
                                    const Radius.circular(50)),
                              ),
                              hintText: "Password",
                              hintStyle: TextStyle(color: Colors.black),
                              border: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                    const Radius.circular(50)),
                              ),
                              fillColor: Colors.white,
                              filled: true),
                          style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 20),
                      child: Text(
                        "Forgot your Password?",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: SizedBox(
                        width: 330,
                        height: 50,
                        child: ElevatedButton(
                            onPressed: () async {
                              String email = temail.text;
                              String password = tpassword.text;

                              Map map = {'email': email, 'password': password};
                              var url = Uri.parse('https://gluggler.app/glugglerBackend/public/api/phone/login');

                              http.Response response = await http.post(url, body: map);
                              Map m = jsonDecode(response.body);
                              var result = m['Data'];
                              print(result);
                              print('Response status: ${response.statusCode}');

                              if (response.statusCode == 200 && result != null) {
                                var phone_token = m["Data"]["token"];
                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                prefs.setString('token', phone_token);
                                prefs.setString('email', email);
                                prefs.setString('password', password);
                                print(phone_token);

                                print('Response body: ${response.body}');

                                print(m);
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    return Homepage();
                                  },
                                ));
                              } else {
                                print(
                                    'Request failed with status: ${response.statusCode}');
                              }
                              // print(response.body);
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xffffab00),
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0),
                              ),
                            ),
                            child: Text(
                              "Sign In",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            )),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class User {
  String? token;
  String? tokenType;
  int? expiresIn;

  User({this.token, this.tokenType, this.expiresIn});

  User.fromJson(Map json) {
    token = json['token'];
    tokenType = json['token_type'];
    expiresIn = json['expires_in'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['token_type'] = this.tokenType;
    data['expires_in'] = this.expiresIn;
    return data;
  }
}
