

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';


void main() {
  runApp(const MyApp());
}
final FlutterTts flutterTts=FlutterTts();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch:Colors.amber,
      ),
      home:const SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget  {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
        splash: Column(
          children: [
            Image.asset('assets/images/note.png'),
            const Text(
              'MyNotes',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 40,
                color: Colors.amber,
              ),
            )
          ],
        ),
        backgroundColor:Colors.white,
      nextScreen: Home(),
      splashIconSize: 350,
      duration: 3000,
      splashTransition: SplashTransition.slideTransition,
    );

  }
}

class Home extends StatefulWidget{
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String txt='';
  String time='';
  Map myList= Map<String, String>();
  speak(String text)async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1);
    await flutterTts.speak(text);
  }
   String detail='';
   String times='';
  void ToogleState(text1,text2){
    setState(() {
      detail=text1;
      times=text2;
    });
  }


  Future<String?>openDialog(BuildContext context){
    TextEditingController mycontroller = TextEditingController();
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Add new note'),
            content: TextField(
              autofocus: true,
              decoration: InputDecoration(hintText: 'enter a note'),
              controller: mycontroller,
            ),
            actions: <Widget>[
              MaterialButton(
                onPressed: () {
                  time=DateTime.now().toString();
                  Navigator.of(context).pop(mycontroller.text);
                },
                elevation: 5.0,
                child: Text('submit'),
                color: Colors.amber,


              ),
            ],
          );
        }
    );
  }

  void Delete( String item) {

    showDialog(

        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Delete"),
            content: Text("Are you sure?"),
            actions: <Widget>[
              MaterialButton(
                color: Colors.green,
                child: Text("Confirm", style: TextStyle(color: Colors.white)),
                onPressed: () {
                  myList.remove(item);
                  setState(() {});
                  Navigator.pop(context);
                },
              ),
              MaterialButton(
                color: Colors.red,
                child: Text("Cancel", style: TextStyle(color: Colors.white)),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
  }


  @override
  Widget build(BuildContext context) {
    var entryList =myList.entries.toList();

              return Scaffold(
              appBar:AppBar (
              title: const Text('MyNotes'),
              actions:<Widget> [
              IconButton(
              onPressed: () async{
              final txt= await openDialog(context);
              if(txt==null || txt.isEmpty) return;
              setState(()=> myList[time]=txt);

    },
              icon: const Icon(Icons.add)
              ),


              ],



              ),


              body: OrientationBuilder(
                builder: (context, orientation) {
                  if (orientation==Orientation.landscape){
                    return Row(
                        children: <Widget>[
                    Expanded(
                        child:ListView.builder(
                            itemCount: myList.length,
                            itemBuilder: (context, position) {
                              return Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: ListTile(
                                    leading: const CircleAvatar(
                                      radius:25,
                                      backgroundImage: AssetImage('assets/images/note.png'),
                                    ),
                                    title:const Text('Fellah Asma'),
                                    subtitle:Text(entryList[position].value.length > 10 ? '${entryList[position].value.substring(0, 10)}...' : entryList[position].value),
                                    trailing: const Icon(Icons.arrow_forward),
                                    onTap: (){
                                      ToogleState( entryList[position].value,entryList[position].key);
                                    },
                                    onLongPress: () {
                                      Delete(entryList[position].key);
                                    },

                                  ),
                                ),
                              );
                            }
                        ),
                  ),
                        if(detail!='')  Column(
                            children: [

                              Image.asset('assets/images/note.png',
                                height: 100,
                                width: 500,),

                              Text('Fellah Asma'),
                              Text(detail),
                              Text(times),
                              MaterialButton(
                                color: Colors.amber,
                                child: Text("text to speech", style: TextStyle(color: Colors.white)),
                                onPressed: () {
                                  speak(detail);

                                },
                              ),

                            ],

                          )
                  ],


                    );
                  }else{
                    return ListView.builder(
                        itemCount: myList.length,
                        itemBuilder: (context, position) {
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: ListTile(
                                leading: const CircleAvatar(
                                  radius:25,
                                  backgroundImage: AssetImage('assets/images/note.png'),
                                ),
                                title:const Text('Fellah Asma'),
                                subtitle:Text(entryList[position].value.length > 3 ? '${entryList[position].value.substring(0, 3)}...' : entryList[position].value),
                                trailing: const Icon(Icons.arrow_forward),
                                onTap: (){
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>DetailPage(detail: entryList[position].value,times:entryList[position].key)));
                                },
                                onLongPress: () {
                                  Delete(entryList[position].key);
                                },

                              ),
                            ),
                          );
                        }
                    );

                  }




                },
              ),




    );



  }
}



class DetailPage  extends StatelessWidget{

  final String detail;
  final String times;

  const DetailPage({super.key, required this.detail, required this.times});
  speak(String text)async{
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1);
    await flutterTts.speak(text);



  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar:AppBar (
        title: const Text('MyNotes'),
        actions:<Widget> [
        ],


      ),
      body:Center(
        child:Column(
          children: [

            Image.asset('assets/images/note.png',
              height: 100,
              width: 500,),

            Text('Fellah Asma'),
            Text(detail),
            Text(times),
            MaterialButton(
              color: Colors.amber,
              child: Text("text to speech", style: TextStyle(color: Colors.white)),
              onPressed: () {
                speak(detail);

              },
            ),

          ],
        ),


      ),
    );
  }
}





