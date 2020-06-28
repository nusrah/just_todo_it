import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(MaterialApp(
  debugShowCheckedModeBanner: false,
  theme: ThemeData(
    brightness: Brightness.light,
  primaryColor: Colors.deepPurple,
  accentColor: Colors.deepPurple),
  home: MyApp()
  
));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  String input = "";

  createTodos(){
      DocumentReference documentReference = 
      Firestore.instance.collection("MyTodos").document(input);

      //Map
      Map<String, String> todos = { "todoTitle":input};

      documentReference.setData(todos).whenComplete ( () {
        print("$input created");
      });
       }
  

  deleteTodos(item){
     DocumentReference documentReference = 
      Firestore.instance.collection("MyTodos").document(item);

      documentReference.delete().whenComplete ( () {
        print("deleted");
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Todos"),),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            showDialog(context: context,
            builder: (BuildContext context){
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius:BorderRadius.circular(8)
                ),
                title: Text("Add Todo List"),
                content: TextField(
                  onChanged: (String value){
                    input=value;}
                  ),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: (){
                      createTodos();
                        Navigator.of(context).pop();
                      },
                      child: Text("Add"),
                    )
                  ],
                );
            });
            },
            child: Icon(
            Icons.add,
            color: Colors.white,),
            ),

        
    


        body: StreamBuilder(
          stream: Firestore.instance.collection("MyTodos").snapshots(),
          builder: (context,snapshots){
          return  ListView.builder(
            shrinkWrap: true,
          itemCount: snapshots.data.documents.length,
          itemBuilder: (context, index){
            DocumentSnapshot documentSnapshot = snapshots.data.documents[index];
            return Dismissible(
            

              key: Key(documentSnapshot["todoTitle"]), 
                child: Card(
                  elevation: 4,
                  margin: EdgeInsets.all(8),
                  shape: RoundedRectangleBorder(borderRadius:
                   BorderRadius.circular(8)
                   ),
                  child: ListTile(
                    title: Text(documentSnapshot["todoTitle"]),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Colors.deepPurple),
                        onPressed:(){
                          deleteTodos(documentSnapshot
                          ["todoTitle"]);
                        } ,)
                        )
            ),
            );

          }
        
        );}
        )
    );
  
}
}
