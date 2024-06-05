import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'models/employes_data.dart';

class RatingPage extends StatefulWidget {
  const RatingPage({super.key});

  @override
  State<RatingPage> createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  List<employes_data> aa = [];

  @override
  void initState() {
    super.initState();

    getUser();
  }

  FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "ISHCHILAR REYTINGI",
                textAlign: TextAlign.start,
                style: TextStyle(fontFamily: 'Inika', fontSize: 17),
              ),
            ],
          ),
        ),
        body: ListView.builder(
            itemCount: aa.length,
            itemBuilder: (BuildContext context, index) {
              return listShow(aa[index], index);
            }));
  }

  Future<void> getUser() async {
    List<String> a = [];
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('MMMM').format(now);
    await db.collection("last_month").get().then((event) {
      for (var doc in event.docs) {
          a.add(doc.data()['oy']);
      }
      setState(() {
        if (a[0] == formattedDate) {
          getData();
        } else {
          print(a[0]);
          updateAllDocuments();
        }
      });
    });
  }

  void update() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('MMMM').format(now);
    final washingtonRef = db.collection("last_month").doc("oy");
    washingtonRef.update({
      "oy": formattedDate,
    }).then((value) => print("DocumentSnapshot successfully updated!"),
        onError: (e) => print("Error updating document $e"));
  }

  Future<void> updateAllDocuments() async {
    WriteBatch batch = db.batch();

    try {
      QuerySnapshot querySnapshot = await db.collection("workers").get();

      for (QueryDocumentSnapshot document in querySnapshot.docs) {
        DocumentReference documentRef =
            db.collection("workers").doc(document.id);
        batch.update(documentRef, {"procimity": 0,
        "add_time":""});
      }

      await batch.commit();
      update();
      getData();
    } catch (e) {
      print("Error updating documents: $e");
    }
  }

  void addData() async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('MMMM').format(now);
    // Create a new user with a first and last name
    final user = <String, dynamic>{
      "oy": formattedDate,
    };

    db.collection("last_month").doc("oy").set(user).then((_) {
      print('Document added with ID: ');
    }).catchError((error) {
      print('Failed to add document: $error');
    });
  }

  Future<void> getData() async {
    List<employes_data> a = [];
    await db.collection("workers").get().then((event) {
      for (var doc in event.docs) {
        setState(() {
          print("object");
          if (doc.data()['procimity'] != 0) {
            a.add(employes_data(
                name: doc.data()['name'],
                degree: doc.data()['degree'],
                add_time: doc.data()['add_time'],
                procimity: doc.data()['procimity'],
                days: doc.data()['days']));
          }
          a.sort((x, y) => x.procimity.compareTo(y.procimity));
          print(a.toString());
          aa = a.reversed.toList();
        });
        // print(employes_data(
        //     name: doc.data()['name'], degree: doc.data()['degree']));
      }
    });
  }

  Widget listShow(employes_data data, int index) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
      child: Container(
          height: 90,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15.0,
                              ),
                              child: Icon(
                                Icons.person,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              "${data.name}",
                              style:
                                  TextStyle(fontFamily: 'Inika', fontSize: 16),
                            ),
                          ],
                        ),
                        Row(children: [
                          Image.asset(
                            'assets/ic_case.png',
                            height: 18,
                            width: 18,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15.0,
                            ),
                            child: Text(
                              "${data.degree}",
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ]),
                      ]),
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15.0,
                            ),
                            child: Icon(
                              Icons.calendar_month_sharp,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            "${data.add_time}",
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      Row(children: [
                        Icon(Icons.bar_chart),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15.0,
                          ),
                          child: Text(
                            "${data.procimity.toStringAsFixed(2)}",
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ]),
                    ]),
              ],
            ),
          )),
    );
  }
}
