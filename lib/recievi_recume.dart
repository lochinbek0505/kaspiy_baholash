import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:talim/models/resume_data.dart';

class RecieveResume extends StatefulWidget {
  const RecieveResume({super.key});

  @override
  State<RecieveResume> createState() => _RecieveResumeState();
}

class _RecieveResumeState extends State<RecieveResume> {
  List<resume_data> aa = [];

  @override
  void initState() {
    super.initState();

    getData();
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
                "NOMZODLAR RESUMESI",
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
    // String formattedDate = DateFormat('MMMM').format(now);
    await db.collection("last_month").get().then((event) {
      for (var doc in event.docs) {
        a.add(doc.data()['oy']);
      }
      setState(() {
        getData();

        // } else {
        //   print(a[0]);
        //   // updateAllDocuments();
        // }
      });
    });
  }
  Future<void> deleteUser(String userId) async {
    try {
      await FirebaseFirestore.instance
          .collection('resume')
          .doc(userId)
          .delete();
    } catch (e) {
    }
  }
  void update(String uid) {
    final washingtonRef = db.collection("check").doc(uid);
    washingtonRef.update({
      "pos": true,
    }).then((value) => print("DocumentSnapshot successfully updated!"),
        onError: (e) => print("Error updating document $e"));
  }

  // Future<void> updateAllDocuments() async {
  //   WriteBatch batch = db.batch();
  //
  //   try {
  //     QuerySnapshot querySnapshot = await db.collection("workers").get();
  //
  //     for (QueryDocumentSnapshot document in querySnapshot.docs) {
  //       DocumentReference documentRef =
  //           db.collection("workers").doc(document.id);
  //       batch.update(documentRef, {"procimity": 0, "add_time": ""});
  //     }
  //
  //     await batch.commit();
  //     update();
  //     getData();
  //   } catch (e) {
  //     print("Error updating documents: $e");
  //   }
  // }

  // void addData() async {
  //   DateTime now = DateTime.now();
  //   // Create a new user with a first and last name
  //
  //   db.collection().doc("oy").set(user).then((_) {
  //     print('Document added with ID: ');
  //   }).catchError((error) {
  //     print('Failed to add document: $error');
  //   });
  // }

  // final user = <String, dynamic>{
  //   "name": name,
  //   "age": age,
  //   "specialty": specialty,
  //   "edu_level": edu_level,
  //   "place": place,
  //   "where_sdudeit": where_sdudeit,
  //   "language": language,
  //   "token":uid
  // };

  Future<void> getData() async {
    List<resume_data> a = [];
    await db.collection("resume").get().then((event) async {
      for (var doc in event.docs) {
        final docRef = db.collection("check").doc(doc.data()['token']);
        docRef.get().then((DocumentSnapshot doc1) {
          try {
            final data = doc1.data() as Map<String, dynamic>;
            String aa = data['pos'].toString();
            if (aa != "true") {
              setState(() {
                print(doc.data()['name']);

                a.add(resume_data(
                    name: doc.data()['name'],
                    age: doc.data()['age'],
                    specialty: doc.data()['specialty'],
                    edu_level: doc.data()['edu_level'],
                    place: doc.data()['place'],
                    where_sdudeit: doc.data()['where_sdudeit'],
                    language: doc.data()['language'],
                    uid: doc.data()['token'],
                    data: doc.data()['data']));
              });
            }
          } catch (e) {
            print(e);
          }
        });
      }

      aa = a;
    });
  }

  Widget listShow(resume_data data, int index) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
      child: Container(
          height: 370,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15.0,
                        ),
                        child: Text(
                          "F.I.O  - ",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        "${data.name}",
                        style: TextStyle(fontFamily: 'Inika', fontSize: 16),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15.0,
                        ),
                        child: Text(
                          "YOSHI  - ",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        "${data.age} yosh",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15.0,
                        ),
                        child: Text(
                          "TUG'ILGAN JOYI  - ",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        "${data.place}",
                        style: TextStyle(fontFamily: 'Inika', fontSize: 16),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15.0,
                        ),
                        child: Text(
                          "ILMIY DARAJASI  - ",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        "${data.edu_level}",
                        style: TextStyle(fontFamily: 'Inika', fontSize: 16),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15.0,
                        ),
                        child: Text(
                          "BILADIGAN TILLARI  - ",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        "${data.language}",
                        style: TextStyle(fontFamily: 'Inika', fontSize: 16),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15.0,
                        ),
                        child: Text(
                          "MUTAXASISLIGI  - ",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        "${data.specialty}",
                        style: TextStyle(fontFamily: 'Inika', fontSize: 16),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15.0,
                        ),
                        child: Text(
                          "O'QIGAN JOYI  - ",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        "${data.where_sdudeit}",
                        style: TextStyle(fontFamily: 'Inika', fontSize: 16),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15.0,
                        ),
                        child: Text(
                          "LAVOZIMI  - ",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        "Sinov muddatida ",
                        style: TextStyle(fontFamily: 'Inika', fontSize: 16),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: SizedBox(
                            height: 30,
                            child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    deleteUser(data.uid);
                                    aa.remove(data);
                                  });
                                },
                                child: Text("RAD ETISH")),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                          child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  update(data.uid);
                                  aa.remove(data);
                                });
                              },
                              child: Text("IMTIHONGA RUHSAT BERISH")),
                        )
                      ]),
                ),
              ],
            ),
          )),
    );
  }
}
