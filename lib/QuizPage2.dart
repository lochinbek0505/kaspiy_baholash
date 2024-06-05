import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:talim/main.dart';
import 'package:talim/main_page.dart';
import 'package:talim/models/employes_data.dart';
import 'package:talim/user_resume.dart';

class QuizPage extends StatefulWidget {
  final employes_data data;

  QuizPage({required this.data});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  FirebaseFirestore db = FirebaseFirestore.instance;

  final List<Map<String, Object>> _questions = [
    {
      'questionText': 'Berilgan so‘zlar ichidan mantiqan ortiqchasini belgilang',
      'answers': ['A. Parij', 'B. London', 'C. Nyu-York', 'D. Tokio', 'E. Pekin'],
      'correctAnswer': 'C. Nyu-York',
    },
    {
      'questionText': '“Son” va “raqam” so‘z juftligi ma’nolaridan kelib chiqib, javoblar orasidan “so‘z” so‘zining juftini tanlang.',
      'answers': ['A. xarf', 'B. jumla', 'C. xikoya', 'D. o‘qish', 'E. kitob'],
      'correctAnswer': 'A. xarf',
    },
    {
      'questionText': 'Agar bugun shanba bo‘lsa, 29 kundan keyin xaftaning qaysi kuni bo‘ladi?',
      'answers': ['A. juma', 'B. shanba', 'C. yakshanba', 'D. dushanba', 'E. seshanba'],
      'correctAnswer': 'B. shanba',
    },
    {
      'questionText': 'Agar xozir vaqt 09:46 bo‘lsa, 43 daqiqadan keyin soat necha bo‘ladi?',
      'answers': ['A. 10:19', 'B. 22:19', 'C. 10:29', 'D. 22:29', 'E. 09:03'],
      'correctAnswer': 'C. 10:29',
    },
    {
      'questionText': 'Ishchining maoshi dastlab 20% ga, so‘ngra yana 20% ga oshirilgan bo‘lsa, uning maoshi necha foizga oshgan?',
      'answers': ['A. 44', 'B. 50', 'C. 42', 'D. 40', 'E. 46'],
      'correctAnswer': 'A. 44',
    },
    {
      'questionText': 'Chakana savdo sotuvchisi ulgurji savdogardan olgan mahsulotini 20 % lik ustama bilan sotdi. Agar jami tushum 240 ming bo‘lsa, u holda foyda qanchani tashkil qilgan.',
      'answers': ['A. 4,8 ming', 'B. 20 ming', 'C. 40 ming', 'D. 48 ming', 'E. 50 ming'],
      'correctAnswer': 'D. 48 ming',
    },
    {
      'questionText': 'Agar A harfi B harfidan 9 marta katta va B esa V dan 4 marta kichik bo‘lsa, u holda harflar orasidagi munosabatni toping',
      'answers': ['A. A>V', 'B. A<V', 'C. A=B', 'D. Aniqlab bo‘lmaydi'],
      'correctAnswer': 'A. A>V',
    },
    {
      'questionText': 'Buvasi nabirasining birinchi tug‘ilgan kuniga bitta kitob sovg‘a qildi. Ikkinchi tug‘ilgan kuniga – 3 ta, uchinchisiga – 9 ta, to‘rtinchisiga - 27 va hokazo. Nabirasi 5 yoshga to‘ldi. Unda qancha kitobi buldi?',
      'answers': ['A. 121', 'B. 100', 'C. 68', 'D. 98', 'E. 81'],
      'correctAnswer': 'E. 81',
    },
    {
      'questionText': 'Angliyaga amaliyot o‘tash uchun kelgan jami 22 talabaning 12 tasi ingliz tilida, 14 tasi nemis tilida gaplashadi. Qancha talaba ikkala tilda xam so‘zlashadi?',
      'answers': ['A. 11', 'B. 15', 'C. 5', 'D. 4', 'E. 7'],
      'correctAnswer': 'C. 5',
    },
    {
      'questionText': 'Oilaning 5 nafar a’zolari yoshlari yig‘indisi 78 ga teng. 4 yil avval 61 ga teng bo‘lgan. Oilaning eng kichik a’zosi necha yoshda?',
      'answers': ['A. 3', 'B. 4', 'C. 1', 'D. 2', 'E. 6'],
      'correctAnswer': 'A. 3',
    },
  ];


  int _currentQuestionIndex = 0;
  Map<int, String> _answers = {};

  void _answerQuestion(String answer) {
    setState(() {
      _answers[_currentQuestionIndex] = answer;
      if (_currentQuestionIndex < _questions.length - 1) {
        _currentQuestionIndex++;
      } else {
        _showResult();
      }
    });
  }

  void _showResult() {
    int correctAnswers = 0;
    for (int i = 0; i < _questions.length; i++) {
      if (_questions[i]['correctAnswer'] == _answers[i]) {
        correctAnswers++;
      }
    }

    double scorePercentage = (correctAnswers / _questions.length) * 100;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('NATIJA'),
        content: Text(
            'Siz  ${_questions.length} ta savoldan $correctAnswers tasiga to\'g\'ri javob berdingiz ! Sizning  natijangiz: ${scorePercentage.toStringAsFixed(2)}%'),
        actions: <Widget>[
          TextButton(
            child:
                Text(scorePercentage > 60 ? 'Davom etish' : 'Chiqish'),
            onPressed: () {
              Navigator.of(ctx).pop();
              setState(() {
                if (scorePercentage > 59) {
                  _showNextOperationDialog();
                } else {
                  navigateBackToFirstPage();

                  // _currentQuestionIndex = 0;
                  // _answers = {};
                }
              });
            },
          ),
        ],
      ),
    );
  }

  void navigateBackToFirstPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MainPage()),
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

  void _showNextOperationDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('TABRIKLAYMIZ',style: TextStyle(color: Colors.green),),
        content: Text(
            'TABRIKLAYMIZ , Siz sinov testidan yetarli ball oldingiz va xodimlarimiz  safiga qo\'shildingiz.'),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () {
              addData(widget.data.name, widget.data.degree, "", 0, 0);
              navigateBackToFirstPage();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz App'),
      ),
      body: _currentQuestionIndex < _questions.length
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Quiz(
                  questionData: _questions[_currentQuestionIndex],
                  answerQuestion: _answerQuestion,
                ),
              ),
            )
          : Center(
              child: Text('No more questions!'),
            ),
    );
  }
}

class Quiz extends StatelessWidget {
  final Map<String, Object> questionData;
  final Function(String) answerQuestion;

  Quiz({
    required this.questionData,
    required this.answerQuestion,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          questionData['questionText'] as String,
          style: TextStyle(fontSize: 24),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 20),
        ...(questionData['answers'] as List<String>).map((answer) {
          return Card(
            color: Colors.white,
            elevation: 4,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
              child: TextButton(
                child: Text(answer),
                onPressed: () => answerQuestion(answer),
              ),
            ),
          );
        }).toList(),
      ],
    );
  }
}
