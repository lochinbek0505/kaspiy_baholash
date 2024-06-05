import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:talim/QuizPage.dart';
import 'package:talim/models/employes_data.dart';
import 'package:talim/models/resume_data.dart';

class ResumeForm extends StatefulWidget {
  final String uidd;

  ResumeForm({required this.uidd});

  @override
  _ResumeFormState createState() => _ResumeFormState();
}

class _ResumeFormState extends State<ResumeForm> {
  FirebaseFirestore db = FirebaseFirestore.instance;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _specialtyController = TextEditingController();
  final TextEditingController _educationLevelController =
      TextEditingController();
  final TextEditingController _residenceController = TextEditingController();
  final TextEditingController _studyPlaceController = TextEditingController();
  final TextEditingController _languagesController = TextEditingController();
  String posis = "false";
  String send = "false";
  employes_data daaad =
      employes_data(add_time: "", procimity: 0, days: 0, name: "", degree: "");
  String _name = '';
  String _age = '';
  String _specialty = '';
  String _educationLevel = '';
  String _residence = '';
  String _studyPlace = '';
  String _languages = '';

  @override
  void initState() {
    super.initState();
    pos();
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _name = _nameController.text;
        _age = _ageController.text;
        _specialty = _specialtyController.text;
        _educationLevel = _educationLevelController.text;
        _residence = _residenceController.text;
        _studyPlace = _studyPlaceController.text;
        _languages = _languagesController.text;

        addData(widget.uidd, _name, _age, _specialty, _educationLevel,
            _residence, _studyPlace, _languages);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "KASPIY BAHOLASH",
              textAlign: TextAlign.start,
              style: TextStyle(fontFamily: 'Inika', fontSize: 17),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: GestureDetector(
                  onTap: () {
                    // pos();
                    if (posis == "true") {
                      setState(() {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => QuizPage(data: daaad)),
                        );
                      });
                    }else{
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Hali resume tasdiqlanmagan')),
                      );
                    }
                  },
                  child: Icon(Icons.question_answer)),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              _buildTextField(
                controller: _nameController,
                labelText: 'F.I.O',
                validator: (value) =>
                    value?.isEmpty ?? true ? 'F.I.O ni kiriting' : null,
              ),
              _buildTextField(
                controller: _ageController,
                labelText: 'Yoshi',
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Yoshingizni kiriting' : null,
              ),
              _buildTextField(
                controller: _specialtyController,
                labelText: 'Mutaxasisligi',
                validator: (value) => value?.isEmpty ?? true
                    ? 'Iltimos mutaxasisligingizni kiriting'
                    : null,
              ),
              _buildTextField(
                controller: _educationLevelController,
                labelText: 'Ilmiy darajangizni kiriting',
                validator: (value) => value?.isEmpty ?? true
                    ? 'Ilmiy darajangizni kiriting'
                    : null,
              ),
              _buildTextField(
                controller: _residenceController,
                labelText: 'Yashash joyi',
                validator: (value) => value?.isEmpty ?? true
                    ? 'Yashash joyingizni kiriting'
                    : null,
              ),
              _buildTextField(
                controller: _studyPlaceController,
                labelText: 'Tamomlagan OTMi',
                validator: (value) => value?.isEmpty ?? true
                    ? 'Qaysi OTM ni tamomlagansiz'
                    : null,
              ),
              _buildTextField(
                controller: _languagesController,
                labelText: 'So\'zlasha oladigan tillari',
                validator: (value) => value?.isEmpty ?? true
                    ? 'So\'zlasha oladigan tillarizni kiriting'
                    : null,
              ),
              SizedBox(height: 20),
              SizedBox(
                height: 40,
                child: ElevatedButton(
                  onPressed: () {
                    print(posis);
                    if (send == 'true') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Siz resume yuborgansiz')),
                      );
                    } else {
                      _submitForm();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Siz muoffaqiyatli so\'rov yubordinggiz!')),
                      );
                    }
                  },
                  child: Text(
                    'Tasdiqlash',
                    style: TextStyle(fontSize: 17),
                  ),
                ),
              ),
              SizedBox(height: 20),
              if (_name.isNotEmpty)
                ResumeDisplay(
                  name: _name,
                  age: _age,
                  specialty: _specialty,
                  educationLevel: _educationLevel,
                  residence: _residence,
                  studyPlace: _studyPlace,
                  languages: _languages,
                ),
            ],
          ),
        ),
      ),
    );
  }

  void pos() {
    final docRef = db.collection("check").doc(widget.uidd);
    docRef.get().then(
      (DocumentSnapshot doc1) async {
        try {
          final data = doc1.data() as Map<String, dynamic>;
          String aa = data['pos'].toString();
          print(aa);
          posis = aa;
          send = data['send'].toString();
          if (posis == 'true') {
            print("ONE");
            DocumentSnapshot docc =
                await db.collection("resume").doc(widget.uidd).get();
            final dataa = docc.data() as Map<String, dynamic>;
            print("ONE2");

            resume_data dd = resume_data(
              name: dataa['name'].toString(),
              age: dataa['age'].toString(),
              specialty: dataa['specialty'].toString(),
              edu_level: dataa['edu_level'].toString(),
              place: dataa['place'].toString(),
              where_sdudeit: dataa['where_sdudeit'].toString(),
              language: dataa['language'].toString(),
              uid: dataa['token'].toString(),
              data: dataa['data'].toString(),
            );
            daaad = employes_data(
              add_time: "",
              procimity: 0,
              days: 0,
              name: dd.name,
              degree: "Sinov muddati",
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Hali resume tasdiqlanmagan')),
            );
          }
        } catch (e) {
          print(e);
        }
      },
      onError: (e) => print("Error getting document: $e"),
    );
  }

  void addData(
      String uid,
      String name,
      String age,
      String specialty,
      String edu_level,
      String place,
      String where_sdudeit,
      String language) async {
    DateTime now = DateTime.now();
    // Create a new user with a first and last name
    String formattedDate = DateFormat('MMMM').format(now);

    final user = <String, dynamic>{
      "name": name,
      "age": age,
      "specialty": specialty,
      "edu_level": edu_level,
      "place": place,
      "where_sdudeit": where_sdudeit,
      "language": language,
      "token": uid,
      "data": now.millisecond.toString(),

    };

    final dat = <String, dynamic>{"pos": false, "send": true};
    send="true";
    db.collection("check").doc(uid).set(dat).then((_) {
      print('Document added with ID: ');
    }).catchError((error) {
      print('Failed to add document: $error');
    });
    db.collection("resume").doc(uid).set(user).then((_) {
      print('Document added with ID: ');
    }).catchError((error) {
      print('Failed to add document: $error');
    });
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    TextInputType keyboardType = TextInputType.text,
    required String? Function(String?) validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: labelText,
        ),
        keyboardType: keyboardType,
        validator: validator,
      ),
    );
  }
}

class ResumeDisplay extends StatelessWidget {
  final String name;
  final String age;
  final String specialty;
  final String educationLevel;
  final String residence;
  final String studyPlace;
  final String languages;

  ResumeDisplay({
    required this.name,
    required this.age,
    required this.specialty,
    required this.educationLevel,
    required this.residence,
    required this.studyPlace,
    required this.languages,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildInfoRow('Name', name),
            _buildInfoRow('Age', age),
            _buildInfoRow('Specialty', specialty),
            _buildInfoRow('Educational Level', educationLevel),
            _buildInfoRow('Place of Residence', residence),
            _buildInfoRow('Where You Studied', studyPlace),
            _buildInfoRow('Languages Known', languages),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text('$label: $value'),
    );
  }
}
