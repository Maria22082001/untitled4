import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,

    home: MyApp(),
  ));
}


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String input = "";
  String description = "";

  createTest() {
    DocumentReference documentReference =
    FirebaseFirestore.instance.collection("Test2").doc(input);

    Map<String, String> test = {"testTitle": input,"testDesc": description};
    documentReference.set(test).whenComplete(() {
      print("$input created");
    });
  }
  deleteTest(item) {
    DocumentReference documentReference =
    FirebaseFirestore.instance.collection("Test2").doc(item);

    documentReference.delete().whenComplete(() {
      print("$item deleted");
    });
  }
  final firestone = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
      AppBar(backgroundColor: Colors.deepPurple, centerTitle: true,
          title: Text("Firebase Note") ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.deepPurple,
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    title: Text("Add Notes"),
                    content: Container(
                      width: 300,
                      height: 200,
                      child: Column(
                        children: [
                          TextField(
                              maxLines: 1,
                              onChanged: (String value) {
                                input = value;
                              },
                              decoration: InputDecoration(
                                  fillColor: Colors.grey.shade100,
                                  filled: true,
                                  hintText: "Title",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ))),
                          SizedBox(height: 20),
                          TextField(
                              maxLines:4 ,
                              onChanged: (String value) {
                                description = value;
                              },
                              decoration: InputDecoration(
                                  fillColor: Colors.grey.shade100,
                                  filled: true,
                                  hintText: "Description",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )))
                        ],
                      ),

                    ),

                    actions: <Widget>[
                      ElevatedButton(
                          onPressed: () {
                            createTest();
                            Navigator.of(context).pop(); // closes the dialog
                          },
                          child: Text("Add")),
                      TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('cancel'))
                    ]
                );
              });
        },
        label: Text('Add Note '),
        icon: Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection("Test2").snapshots(),
          builder: (context, snapshot) {
            return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot documentSnapshot =
                  snapshot.data!.docs[index];
                  return Dismissible(
                      onDismissed: (direction) {
                        deleteTest(documentSnapshot["testTitle"]);
                      },
                      key: Key(documentSnapshot["testTitle"]),
                      child: Card(
                        elevation: 4,
                        margin: EdgeInsets.all(8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        child: ListTile(
                          title: Text(documentSnapshot["testTitle"]),
                          subtitle: Text((documentSnapshot != null)
                              ? ((documentSnapshot["testDesc"] != null)
                              ? documentSnapshot["testDesc"]
                              : "")
                              : ""),
                          trailing: IconButton(
                              icon: Icon(Icons.delete_forever, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  deleteTest(documentSnapshot["testTitle"]);
                                });
                              }),
                        ),
                      ));
                });
          }),
    );
  }
}