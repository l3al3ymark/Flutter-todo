import 'package:flutter/material.dart';
import './detail/add.dart';
import './listcard.dart';
import './listmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Listmodel> lists = List<Listmodel>();


  @override
  void initState() {
    super.initState();
    lists.add(Listmodel(title: "ios",isDone: false));
    lists.add(Listmodel(title: "web",isDone: false));
    lists.add(Listmodel(title: "andoird",isDone: false));
    lists.add(Listmodel(title: "backend",isDone: false));
  }

  Firestore db = Firestore.instance;
  
  void _composeEmail()async{
    setState(() async {
      final result = await  Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Add(),
        ),
      );
      var data = new Map<String, dynamic>();
      data['title'] = result;
      data['isDone'] = false;
      if (result.toString().length > 0) {
        db.collection('Todo').add(data);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var child = Container(
      child: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection("Todo").snapshots(),
          builder:(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
            if (!snapshot.hasData) return LinearProgressIndicator();
            return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (buildContext, position) {
                  return GestureDetector(
                      child: Listcard(Listmodel(title: snapshot.data.documents[position].data['title'],
                          isDone: snapshot.data.documents[position].data['isDone'])),
                  );
                });
          },
      )
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title)
        ,
      ),
      body: child,
      floatingActionButton: FloatingActionButton(
        onPressed: _composeEmail,
        tooltip: 'Compose Email',
        child: Icon(Icons.add),
      ),
    );
  }
}
