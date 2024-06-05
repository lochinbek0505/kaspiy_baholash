import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:talim/QuizPage.dart';
import 'package:talim/recievi_recume.dart';
import 'package:talim/reyting_page.dart';

import 'models/employes_data.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  TextEditingController _controller = TextEditingController();

  FirebaseFirestore db = FirebaseFirestore.instance;

  String a = "";
  List<employes_data> aa = [];
  List<double> time = [-1, -1, -1, -1];
  String dropdownValue = 'Yaxshi'; // Initial selected value

  List<String> items = [
    'Yomon',
    'Qoniqarli',
    'Yaxshi',
    'A\'lo',
  ];
  final ValueNotifier<String> dropdownValueNotifier =
      ValueNotifier<String>('Yaxshi');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "KASPIY BAHOLASH",
              textAlign: TextAlign.start,
              style: TextStyle(fontFamily: 'Inika', fontSize: 17),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RatingPage()),
                );
              },
              child: Image.asset(
                'assets/chart.png',
                height: 27,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RecieveResume()),
                    );
                  },
                  child: Icon(Icons.group)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: GestureDetector(
                onTap: () {
                  dialog();
                },
                child: Image.asset(
                  'assets/add.png',
                  height: 27,
                ),
              ),
            ),
          ],
        ),
      ),
      body: ListView.builder(
          itemCount: aa.length,
          itemBuilder: (BuildContext context, index) {
            return listShow(aa[index], index);
          }),
    );
  }

  void addData(String name, String degree, String add_time, int days,
      int procimity) async {
    // Create a new user with a first and last name
    final user = <String, dynamic>{
      "name": name,
      "degree": degree,
      "add_time": add_time,
      "days": days,
      "procimity": procimity
    };

    db.collection("workers").doc(name).set(user).then((_) {
      print('Document added with ID: ');
    }).catchError((error) {
      print('Failed to add document: $error');
    });
  }

  Future<void> getData() async {
    await db.collection("workers").get().then((event) {
      for (var doc in event.docs) {
        setState(() {
          aa.add(employes_data(
              name: doc.data()['name'],
              degree: doc.data()['degree'],
              add_time: doc.data()['add_time'],
              procimity: doc.data()['procimity'],
              days: doc.data()['days']));
        });
        // print(employes_data(
        //     name: doc.data()['name'], degree: doc.data()['degree']));
      }
    });
  }

  Widget listShow(employes_data data, int index) {
    return GestureDetector(
      onTap: () {
        listdialog(data, index);
      },
      child: Card(
        elevation: 4,
        margin: EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
        child: Container(
          height: 50,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
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
                  style: TextStyle(fontFamily: 'Inika', fontSize: 16),
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
      ),
    );
  }

  void dialog() {
    String name = "";
    String degrree = "";
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Container(
              height: 230,
              width: 500,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 30.0),
                      child: TextField(
                        onChanged: (text) {
                          name = text;
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'F.I.O',
                            hintText: 'Xodim ismi va sharifini kiriting'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 30.0),
                      child: TextField(
                        onChanged: (text) {
                          degrree = text;
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Lavozimi',
                            hintText: 'Xodim lavozimini kiriting'),
                      ),
                    ),
                    SizedBox(
                      width: 220.0,
                      height: 37.0,
                      child: ElevatedButton(
                        onPressed: () {
                          if (name.isNotEmpty && degrree.isNotEmpty) {
                            // setState(() {
                            // print("");
                            // aa.add(employes_data(
                            //     name: name,
                            //     degree: degrree,
                            //     add_time: "",
                            //     days: 0,
                            //     procimity: 0));

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => QuizPage(
                                    data: employes_data(
                                        name: name,
                                        degree: degrree,
                                        add_time: "",
                                        days: 0,
                                        procimity: 0)),
                              ),
                            ).then((_) {
                              // showToast("Yangi xodim qo'shildi");
                              Navigator.of(context).pop();
                            });

                            // showToast2("Yangi xodim qo'shildi");
                            // addData(name, degrree, "", 0, 0);
                            // });
                            // Navigator.of(context).pop();
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
          );
        });
  }

  void showToast2(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
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

  double calculus(double start_h, double start_m, double end_h, double end_m,
      double rest_time, double useful, double responsibility) {
    double penalty = 0;
    if (start_h - 9 >= 0) {
      if (start_m > 0) {
        penalty = ((start_h - 9) * 60 + start_m) * 0.01;
      } else {
        penalty = ((start_h - 9) * 60) * 0.01;
      }
    }

    double work_time = 0;
    if (end_h < start_h) {
      work_time = ((end_h - start_h - 1) * 60 + 60 + end_m - start_m) * 0.01;
    } else {
      work_time = ((end_h - start_h) * 60 + end_m - start_m) * 0.01;
    }
    double penl = 0;
    if (rest_time > 120) {
      penl = (rest_time - 120) * 0.01;
    } else if (rest_time == 120) {
      penl = -1;
    } else {
      penl = -(120 - rest_time) * 0.01;
    }

    double use = useful * 0.1;

    return work_time - penalty - penl + use + responsibility;
  }

  void update(double rey, employes_data data, int index) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('MM-dd-yyyy').format(now);
    print(data.add_time);
    if (formattedDate != data.add_time) {
      final washingtonRef = db.collection("workers").doc(data.name);
      washingtonRef.update({
        "procimity": FieldValue.increment(rey),
        "days": FieldValue.increment(1),
        "add_time": formattedDate
      }).then((value) => print("DocumentSnapshot successfully updated!"),
          onError: (e) => print("Error updating document $e"));
      setState(() {
        aa[index] = employes_data(
            add_time: formattedDate,
            procimity: rey,
            days: data.days,
            name: data.name,
            degree: data.degree);
      });

      showToast2("Samaradorlik  hisoblandi");
    } else {
      showToast2("Bugun bu ishchi samaradorligi hisoblandi");
    }
  }

  void listdialog(employes_data data, int index) {
    String rest = "";
    String respons = "";

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Container(
              height: 520,
              width: 500,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 15.0, horizontal: 30),
                      child: Container(
                        width: 500,
                        // Set width as needed
                        height: 45,
                        // Set height as needed
                        decoration: BoxDecoration(
                          color: Colors.white,
                          // Background color
                          borderRadius: BorderRadius.circular(10),
                          // Rounded corners
                          border: Border.all(
                            color: Colors.grey, // Border color
                            width: 1, // Border width
                          ),
                        ),

                        child: ElevatedButton(
                          onPressed: () {
                            _selectTime(context, "E");
                          },
                          child: Text(
                            'Ishga kelgan vaqti',
                            style: TextStyle(color: Colors.black),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.transparent,
                            // Make button transparent
                            shadowColor:
                                Colors.transparent, // Hide button shadow
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 15.0, horizontal: 30),
                      child: Container(
                        width: 500,
                        // Set width as needed
                        height: 45,
                        // Set height as needed
                        decoration: BoxDecoration(
                          color: Colors.white,
                          // Background color
                          borderRadius: BorderRadius.circular(10),
                          // Rounded corners
                          border: Border.all(
                            color: Colors.grey, // Border color
                            width: 1, // Border width
                          ),
                        ),

                        child: ElevatedButton(
                          onPressed: () {
                            _selectTime(context, "K");
                          },
                          child: Text(
                            'Ishdan ketgan vaqti',
                            style: TextStyle(color: Colors.black),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.transparent,
                            // Make button transparent
                            shadowColor:
                                Colors.transparent, // Hide button shadow
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 30.0),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(3),
                          // Replace 5 with your desired maximum value
                        ],
                        onChanged: (text) {
                          rest = text;
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Ishdagi tanaffuslar',
                            hintText: 'Minutlarda kiriting'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 30.0),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: _controller,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(3),
                          // Replace 5 with your desired maximum value
                        ],
                        onChanged: (text) {
                          if (int.parse(text) < 101) {
                            respons = text;
                          } else {
                            _controller.text = "100";
                          }
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Berilgan vazifani qanchalik bajargani',
                            hintText: 'Foizlarda kiriting'),
                      ),
                    ),
                    Container(
                      width: 420,
                      height: 50,
                      // Set width as needed
                      decoration: BoxDecoration(
                        color: Colors.white,
                        // Background color
                        borderRadius: BorderRadius.circular(10),
                        // Rounded corners
                        border: Border.all(
                          color: Colors.grey, // Border color
                          width: 1, // Border width
                        ),
                      ),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
                        child: ValueListenableBuilder<String>(
                          valueListenable: dropdownValueNotifier,
                          builder: (context, value, child) {
                            return DropdownButton<String>(
                              // Initial Value
                              value: value,

                              // Down Arrow Icon
                              icon: const Icon(Icons.keyboard_arrow_down),

                              // Array list of items
                              items: items.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),

                              // After selecting the desired option, it will
                              // change button value to selected value
                              onChanged: (String? newValue) {
                                dropdownValueNotifier.value = newValue!;
                                dropdownValue = newValue;
                              },
                              // Customize the dropdown button's underline
                              underline: Container(),
                            );
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: SizedBox(
                        width: 220.0,
                        height: 35.0,
                        child: ElevatedButton(
                          onPressed: () {
                            print(time);
                            if (time[0] != -1 &&
                                time[1] != -1 &&
                                time[2] != -1 &&
                                time[3] != -1 &&
                                rest.isNotEmpty &&
                                respons.isNotEmpty) {
                              double respon = 0;
                              //   'Yomon',
                              // 'Qoniqarli',
                              // 'Yaxshi',
                              // 'A\'lo',
                              switch (dropdownValue) {
                                case 'Yomon':
                                  respon = -2;
                                  break;
                                case 'Qoniqarli':
                                  respon = 0;
                                  break;
                                case 'Yaxshi':
                                  respon = 2;
                                  break;
                                case 'A\'lo':
                                  respon = 4;
                                  break;
                              }
                              _controller.clear();

                              update(
                                  calculus(
                                      time[0],
                                      time[1],
                                      time[2],
                                      time[3],
                                      double.parse(rest),
                                      double.parse(respons),
                                      respon),
                                  data,
                                  index);
                              Navigator.of(context).pop();
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
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: SizedBox(
                        width: 220.0,
                        height: 35.0,
                        child: ElevatedButton(
                          onPressed: () {
                            print(time);

                            deleteUser(data.name);
                            Navigator.of(context).pop();
                            setState(() {
                              aa.remove(data);
                            });
                          },
                          child: Text(
                            "Xodimni o'chirish",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget _hourFormatBuilder(BuildContext context, Widget? child) {
    final mediaQueryData = MediaQuery.of(context);

    return MediaQuery(
      data: mediaQueryData.alwaysUse24HourFormat
          ? mediaQueryData
          : mediaQueryData.copyWith(alwaysUse24HourFormat: true),
      child: child!,
    );
  }

  Future<void> deleteUser(String userId) async {
    try {
      await FirebaseFirestore.instance
          .collection('workers')
          .doc(userId)
          .delete();
      showToast2('Xodim muofaqqiyatli o\'chirildi');
    } catch (e) {
      showToast2('Xodimni o\'chirishda xatolik: $e');
    }
  }

  Future<List<int>> _selectTime(BuildContext context, String times) async {
    List<int> ss = [];
    final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        initialEntryMode: TimePickerEntryMode.input,
        builder: _hourFormatBuilder);

    if (pickedTime != null) {
      if (times == "E") {
        time[0] = pickedTime.hour.toDouble();
        time[1] = pickedTime.minute.toDouble();
      } else {
        time[2] = pickedTime.hour.toDouble();
        time[3] = pickedTime.minute.toDouble();
      }
      print('Selected time: ${pickedTime.format(context)}');
    }

    return ss;
  }
}
