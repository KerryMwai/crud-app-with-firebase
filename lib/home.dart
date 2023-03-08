import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> addCountry(name, city, population) async {
    await firebaseFirestore
        .collection("countries")
        .add({"name": name, "city": city, "population": population});
  }

  Future<void> deleteCountry(String countryId)async{
      await firebaseFirestore.collection("countries").doc(countryId).delete();
  }

  Future<void>updateCountry(id,name, city, population)async{
    await firebaseFirestore.collection("countries").doc(id).set({
      "name":name,
      "city":city,
      "population":population
    });
  }

  TextEditingController namecotroller = TextEditingController();
  TextEditingController citycotroller = TextEditingController();
  TextEditingController populationcotroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
  var snapshot=firebaseFirestore.collection("countries").orderBy("name");
    return Scaffold(
      appBar: AppBar(
        title: const Text("Countries Data"),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: snapshot.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
        if(snapshot.hasError){
          return const Center(child: Text("An error occured"),);
        }else if(snapshot.connectionState==ConnectionState.waiting){
          return const Center(child: Text("Loading"),);
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document){
            Map<String, dynamic> data=document.data()! as Map<String, dynamic>;
            return Card(
              color: Colors.white12,
              margin:const  EdgeInsets.only(top: 20.0, left: 20, right: 20),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children:  [
                        Text(data['name']),
                        const SizedBox(height: 20,),
                        Text(data['city'])
                      ],
                    ),
                    Text(data['population']),
                   Row(
                    children: [
                       IconButton(onPressed: (){
                        namecotroller.text=data['name'];
                        citycotroller.text=data['city'];
                        populationcotroller.text=data['population'];
                        showDialog(context: context, builder: (context){
                          return AlertDialog(
                            title:const Text("Update country"),
                            content: SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: TextField(
                                controller: namecotroller,
                              
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: TextField(
                                controller: citycotroller,
                                decoration: const InputDecoration(
                                    hintText: "Enter country city"),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: TextField(
                                controller: populationcotroller,
                                keyboardType:TextInputType.number,
                                decoration: const InputDecoration(
                                    hintText: "Enter country population",),
                              ),
                            ),
                          ],
                        ),
                      ),
                       actions: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("Cancel")),
                        ElevatedButton(
                            onPressed: () {
                              if (namecotroller.text.isEmpty &&
                                  citycotroller.text.isEmpty &&
                                  populationcotroller.text.isEmpty) {
                                return;
                              } else {
                                updateCountry(document.id, namecotroller.text, citycotroller.text,
                                        populationcotroller.text)
                                   .then((value) =>Navigator.pop(context));
                              }
                            },
                            child: const Text("Update")),
                      ],
                          );
                        });
                       },
                     icon: const Icon(Icons.edit, color: Colors.green,)),
                      IconButton(onPressed: (){
                        deleteCountry(document.id);
                      },
                     icon: const Icon(Icons.delete, color: Colors.red,)),
                    ],
                   )
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          namecotroller.text="";
          citycotroller.text="";
          populationcotroller.text="";

          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: const Text("Enter and add country"),
                    content: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: TextField(
                              controller: namecotroller,
                              decoration: const InputDecoration(
                                  hintText: "Enter country name"),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: TextField(
                              controller: citycotroller,
                              decoration: const InputDecoration(
                                  hintText: "Enter country city"),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: TextField(
                              keyboardType: TextInputType.number,
                              controller: populationcotroller,
                              decoration: const InputDecoration(
                                  hintText: "Enter country population"),
                            ),
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Cancel")),
                      ElevatedButton(
                          onPressed: () {
                            if (namecotroller.text.isEmpty &&
                                citycotroller.text.isEmpty &&
                                populationcotroller.text.isEmpty) {
                              return;
                            } else {
                              addCountry(namecotroller.text, citycotroller.text,
                                      populationcotroller.text)
                                  .then((value) {
                                namecotroller.clear();
                                citycotroller.clear();
                                populationcotroller.clear();
                              }).then((value) =>Navigator.pop(context));
                            }
                          },
                          child: const Text("add")),
                    ],
                  ));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
