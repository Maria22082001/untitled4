import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
//alert dialogue  -  bottom sheet 
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
  final firestone = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        // AsyncSnapshot - QuerySnapshot
        stream: firestone.collection('notes').snapshots(),
        builder: (context, snapshot){
         return  snapshot.hasData
         ? ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  snapshot.data!.docs[index]['name'])
              );
            },
          )
            : const Text('Error has happened');
        },
      ),
    );
  }
}