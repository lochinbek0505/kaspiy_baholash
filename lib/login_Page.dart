import 'package:flutter/material.dart';

import 'main_page.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginpAGEState();
}

class _LoginpAGEState extends State<LoginPage> {
  String name = "";
  String degrree = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "KASPIY REYTING",
              textAlign: TextAlign.start,
              style: TextStyle(fontFamily: 'Inika', fontSize: 17),
            ),
          ],
        ),
      ),
      body: Center(
        child: Card(
          elevation: 5,
          child: Container(
            height: 290,
            width: 500,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 30.0),
                    child: Text("Iltimos login va parolni kiriting",
                        style: TextStyle(
                            fontFamily: 'Inika',
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 30.0),
                    child: TextField(
                      onChanged: (text) {
                        name = text;
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Login',
                          hintText: 'Loginni kiritish'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 30.0),
                    child: TextField(
                      onChanged: (text) {
                        degrree = text;
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Parol',
                          hintText: 'Parolni kiritish'),
                    ),
                  ),
                  SizedBox(
                    width: 220.0,
                    height: 37.0,
                    child: ElevatedButton(
                      onPressed: () {
                        if (name.isNotEmpty && degrree.isNotEmpty) {
                          if (name == "KI20-02" && degrree == "BOBORAXIMOV") {
                          // if (name == "k" && degrree == "b") {

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage()),
                            );
                          }else{
                            showToast2();

                          }

                        } else {
                          showToast();
                        }
                      },
                      child: Text(
                        "SAQLASH",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  void showToast2() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Login yoki parol xato"),
        duration: Duration(seconds: 2),
      ),
    );
  }
  void showToast() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Iltimos hamma maydonlarni to'ldiring"),
        duration: Duration(seconds: 2),
      ),
    );
  }
}