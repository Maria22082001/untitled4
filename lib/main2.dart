import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: FirstScreen(),
    );
  }
}

class FirstScreen extends StatefulWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  final firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Firebase',
          ),
        ),
        body:Center(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  firestore.collection('Test').add({

                    'name': 'Hello',

                  });
                },
                child: const Text('Send'),
              ),
            ],
          ),
        )
















      // StreamBuilder<QuerySnapshot>(
      //   stream: firestore.collection('notes').snapshots(),
      //   builder: (context, snapshot) {
      //     return snapshot.hasData
      //         ? ListView.builder(
      //             itemCount: snapshot.data!.docs.length,
      //             itemBuilder: (context, index) {
      //               return ListTile(
      //                 title: Text(
      //                   snapshot.data!.docs[index]['name'],
      //                 ),
      //               );
      //             },
      //           )
      //         : snapshot.hasError
      //             ? Text('Error is Happened')
      //             : CircularProgressIndicator();
      //   },
      // ),
    );
  }
}
