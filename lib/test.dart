import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:creative_test/mechanics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:process_run/shell.dart';
import 'package:window_manager/window_manager.dart';
import 'package:url_launcher/url_launcher.dart';


TestHigh testHigh = TestHigh();

class Test extends StatefulWidget {
  const Test({ Key? key }) : super(key: key);

  @override
  _TestState createState() => _TestState();
}

abstract class SimpleListener {
  void onLoadingFinished(int code, Shell shell, String port);
}

class _TestState extends State<Test> with WindowListener, TickerProviderStateMixin, SimpleListener{

  late Animation<double> scala01;
  late AnimationController scalaController;
  late Animation<double> fade;
  late AnimationController fadeController;
  late MaterialColor baseColor ;

  late AnimationController testTimeController;

  
  List<Color> dotColors = [];
  List<Color> dotColors0 = [];
  List<Color> dotColors2 = [];

  int buttonPos = 0;

  @override
  void onLoadingFinished(int code, Shell shell, String port) {
    if(code == 0){
      setState(() {
        loaded = true;
        loaded2 = false; 
      });
      this.shell = shell;
      this.port = port;
    }else{
      error(code);
    }
  }

  @override
  void initState() {
    super.initState();

    //int cs = Random().nextInt(4);
    baseColor = Colors.blue;
    dotColors.add(baseColor);
    dotColors0.add(baseColor);
    dotColors2.add(Colors.grey[100]!);
    for (var i = 1; i < 8; i++) {
      dotColors.add(Colors.grey[100]!);
      dotColors0.add(Colors.grey[100]!);
      dotColors2.add(Colors.grey[100]!); 
    }

    scalaController = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    scalaController.addListener(() {setState(() {
      
    });});
    scala01 = Tween(begin: 0.0, end: 1.0).animate(scalaController);

    fadeController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    fade = Tween(begin: 1.0, end: 0.0).animate(fadeController);

    testTimeController = AnimationController(
      vsync: this,
      duration: const Duration(minutes: 4),
    )..addStatusListener((status) {
      if(status == AnimationStatus.completed  && testRunningB == 0){

        //close methods
        setState(() {
          timeOver = true;
        });
      }
    });

    windowManager.addListener(this);
  }

  bool left = false;
  bool timeOver = false;

  @override
  void onWindowLeaveFullScreen() async{
    super.onWindowLeaveFullScreen();
    left = true;
    await showDialog(context: context, builder: (c){
      return Container(
        width: 400,
        height: 300,
        decoration: const BoxDecoration(
          color: Color.fromARGB(250, 245, 245, 245)
        ),
        child: Center(
          child: Text("Bitte aktiviere den Vollbild-Modus.", style: Theme.of(context).textTheme.headline2!.apply(
            color: Colors.grey[350]
          ),),
        ),
      );
    });
  }

  @override
  void onWindowEnterFullScreen() {
    if (kDebugMode) {
      print("enter");
    }
    if(left){
      Navigator.of(context).pop();
    } 
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    finishTest(); 
    super.dispose();
  }
  int current = 0;
  void nextTask() async{
    current++;
    if(current < dotColors.length){
      if(!loaded2){
        loaded = true;
      }
      dotColors[current] = baseColor[100 * current + 100]!;
      await scalaController.forward(from: 0.0);
      dotColors2[current] = baseColor[100 * current + 100]!;
    }
  }
  Shell shell = Shell();
  String port = "24232";
  void finishTest() async{
    shell.kill();
    if (kDebugMode) {
      print("finsihed");
    }
    //stop all processes
  }

  void error(int code){
    //on error page 
  }

  bool testTimeView = false;
  int testRunningA = 0;
  void testBase(){
    //add time view
    setState(() {
      testTimeView = true;
    });
  }

  void testA(){
    if(testRunningA == 0){
      testRunningA = 1;
      testTimeView = true;
      testTimeController.forward();
    }
  }

  bool loaded = false;
  bool checkTestAWords = false;
  bool showNext = false;

  int testRunningB = 0;
  void testB(){
    if(testRunningB == 0){
      timeOver = false;
      testRunningB = 1;
      testTimeView = true;
      // showNext = false;
      testTimeController.stop();
      testTimeController = AnimationController(vsync: this, duration: const Duration(minutes: 10))..addStatusListener((status) {
      if(status == AnimationStatus.completed  && testRunningC == 0){

        //close methods
        setState(() {
          timeOver = true;
        });
      }
    });
      testTimeController.forward();
    }
  }

  int testRunningC = 0;
  void testC(){
    if(testRunningC == 0){
      testRunningC = 1;
      testTimeController.stop();
      testTimeController = AnimationController(vsync: this, duration: const Duration(minutes: 4))..addStatusListener((status) {
      if(status == AnimationStatus.completed && testRunningD == 0){

        //close methods
        setState(() {
          timeOver = true;
        });
      }
    });;
      testTimeController.forward();

    }
  }

  Future<void> validateTestB() async{

    http.Response res = await http.get(Uri.parse("http://127.0.0.1:"+port+"/?test_id=1&method=1&input_data="+jsonEncode(testHigh.testBMapList)));
    if (kDebugMode) {
      print(res.body);
    }
    testHigh.dynamicTestBout = jsonDecode(res.body) as List;

  }

  void secureB(){
     WidgetsBinding.instance!.addPostFrameCallback((_){
       setState(() {
          
        
    if(testHigh.testBMapList.keys.isEmpty){
                      testHigh.dynamicTestBout = [0];
                      if(current == 2){
                       
                checkTestAWords = true;
                timeOver = false;
              
                nextTask();
            }
                    }else{
                     
                      
          //validate test b
          validateTestB();

                timeOver = false;
              
            if(current == 2){
                nextTask();
            }

          
        
                    }
        
          
        });
     });
  }
  int testRunningD = 0;
  void testD(){
    if(testRunningD == 0){
      timeOver = false;
      testRunningD = 1;
      testTimeController.stop();
      testTimeController = AnimationController(vsync: this, duration: const Duration(minutes: 20))..addStatusListener((status) {
      if(status == AnimationStatus.completed){
        print("complete");
        //close methods
        setState(() {
          timeOver = true;
        });
      }
    });
      testTimeController.forward();

    }
  }

  int testRunningE = 0;
  void testE(){
    print(testTimeController.value);
    if(testRunningE == 0){
      print("testE");
      timeOver = false;
      testTimeController.stop();
      testRunningE = 1;
      z = false;
      // testTimeView = true;
    }
  }

  void restartE(bool b){
    setState(() {
      testTimeController.stop();
      testTimeController = AnimationController(vsync: this, duration: const Duration(minutes: 1))..addStatusListener((status) {
      if(status == AnimationStatus.completed){
        if(b){
          setState(() {
            timeOver = true;
          });
        }
      }
    });
    testTimeController.forward(from: 0.0);
    });

  }

  int testRunningF = 0;
  void testF(){
    if(testRunningF == 0){
      z = true;
      timeOver = false;
      testRunningD = 1;
      testTimeView = false;
    }
  }
  
  bool loaded2 = true;
  bool sw = false;
  bool z = false;

  @override
  Widget build(BuildContext context) {
    Widget testWidget = Container();
    if(current == 0){
      testWidget = const Intro();
    }
    if(current == 1){
      if(!loaded){
        testWidget = Load(loaded2, key: const Key(""), listener: this);
      }else{
        testA();
        if(checkTestAWords){
          testWidget = TestACheck(this, (){
            WidgetsBinding.instance!.addPostFrameCallback((_){
              if(current == 1){
                setState((){
              checkTestAWords = false;
              testTimeController.value = 0;
              nextTask();
              timeOver = false;
});}});
            //next level
          

          }, port, error);
        }else{
          if(timeOver){
            testWidget = TimeOver(() async{
              await checkMeaning();
            });
          }else{
            testWidget = TestA(path: port,onError: error,); 
          }
        }
      }
    }
    if(current == 2){
      
      testB();
      if(timeOver){
            testWidget = TimeOver((){
            
              secureB();
          
              
            });
          }else{
            
            testWidget = TestB(port, (){

        WidgetsBinding.instance!.addPostFrameCallback((_){
          //validate test b

          validateTestB();

          if(current == 2){
              nextTask();
          }

          
        });}, error);
    }
    }
    if(current == 3){
      testC();
      if(timeOver){
        testWidget = TimeOver((){
          WidgetsBinding.instance!.addPostFrameCallback((_) {
            setState(() {
              timeOver = false;
              nextTask();
            });
          });
        });
      }else{ 
      testWidget = TestC(this, port, (){

      }, error);
      }
    }
    if(current == 4){
      testD();
      if(timeOver){
        testWidget = TimeOver((){
          WidgetsBinding.instance!.addPostFrameCallback((_) {
            setState(() {
              timeOver = false;
              nextTask();
            });
          });
        });
      }else{ 
      testWidget = TestD(port, (){
        WidgetsBinding.instance!.addPostFrameCallback((_) {
            setState(() {
              timeOver = false;
              nextTask();
            });
          });
      }, error);
      }
    }
    if(current == 5){
      testE();
      testWidget = TestE(port, (){

      }, error, this);
    }
    if(current == 6){
      testF();
      testWidget = TestF(port, (){
        setState(() {
          nextTask();//finaleeeee
        });
      }, error);
    }
    if(current == 7){
      z = false;
      testWidget = Results();
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(0, 250, 250, 250),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            child: Container(
              width: 250,
              decoration: BoxDecoration(
                color: Colors.grey[100]!,
                border: Border.symmetric(vertical: BorderSide(color: Colors.grey[200]!, width: 1))
              ),
              child: Column(
                children: [
                  SizedBox(
                    width: 250,
                    height: 250,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ColorFiltered(
                          colorFilter: const ColorFilter.matrix([
                             -1, 0, 0, 0, 255, //
    0, -1, 0, 0, 255, //
    0, 0, -1, 0, 255, //
    0, 0, 0, 1, 0, //
                          ]),
                          child: Image.asset("assets/logo_full_loaded.png", width: 150, height: 150,)
                          ),
                          Text("KreativTest", style: Theme.of(context).textTheme.headline5!.apply(
                            color: Colors.grey[900]!
                          ),)
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 230,
                    height: 1,
                    child: Divider(thickness: 1),
                  ),
                  SizedBox(
                    width: 230,
                    height: 700,
                    child: Stack(
                      children: [
                        Positioned(
                          left: 25,
                          top: 0,
                          child: Container(
                            height: 65,
                            width: 10,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter, 
                                colors: [Colors.grey[100]!,baseColor[100]!],
                              )
                            ),
                          ),
                        ),
                        Positioned(
                          left: 25,
                          top: 70,
                          child: Container(
                            height: 65,
                            width: 10,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                stops: dotColors[1] == Colors.grey[100]! ? [0.0, 0.0, 0.0] : dotColors2[1] == baseColor[200] ? [0.0, 1.0, 0.0]:[0.0, scala01.value, 0.0],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter, 
                                colors: [dotColors0[1], dotColors[1], dotColors0[1]],
                              )
                            ),
                          ),
                        ),
                        Positioned(
                          left: 25,
                          top: 140,
                          child: Container(
                            height: 65,
                            width: 10,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                stops: dotColors[2] == Colors.grey[100]! ? [0.0, 0.0, 0.0] : dotColors2[2] == baseColor[300] ? [0.0, 1.0, 0.0]:[0.0, scala01.value, 0.0],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter, 
                                colors: [dotColors0[2], dotColors[2],dotColors0[2],],
                              )
                            ),
                          ),
                        ),
                        Positioned(
                          left: 25,
                          top: 210,
                          child: Container(
                            height: 65,
                            width: 10,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                stops: dotColors[3] == Colors.grey[100]! ? [0.0, 0.0, 0.0] : dotColors2[3] == baseColor[400] ? [0.0, 1.0, 0.0] : [0.0, scala01.value, 0.0],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter, 
                                colors: [dotColors0[3], dotColors[3],dotColors0[3],],
                              )
                            ),
                          ),
                        ),
                        Positioned(
                          left: 25,
                          top: 280,
                          child: Container(
                            height: 65,
                            width: 10,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                stops: dotColors[4] == Colors.grey[100]! ? [0.0, 0.0, 0.0] : dotColors2[4] == baseColor[500] ? [0.0, 1.0, 0.0]: [0.0, scala01.value, 0.0],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter, 
                                colors: [dotColors0[4], dotColors[4], dotColors0[4]],
                              )
                            ),
                          ),
                        ),
                        Positioned(
                          left: 25,
                          top: 350,
                          child: Container(
                            height: 65,
                            width: 10,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                stops: dotColors[5] == Colors.grey[100]! ? [0.0, 0.0, 0.0] : dotColors2[5] == baseColor[600] ? [0.0, 1.0, 0.0]: [0.0, scala01.value, 0.0],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter, 
                                colors: [dotColors0[5], dotColors[5], dotColors0[5]],
                              )
                            ),
                          ),
                        ),
                        Positioned(
                          left: 25,
                          top: 420,
                          child: Container(
                            height: 65,
                            width: 10,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                stops: dotColors[6] == Colors.grey[100]! ? [0.0, 0.0, 0.0] : dotColors2[6] == baseColor[700] ? [0.0, 1.0, 0.0]: [0.0, scala01.value, 0.0],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter, 
                                colors: [dotColors0[6], dotColors[6], dotColors0[6]],
                              )
                            ),
                          ),
                        ),
                        Positioned(
                          left: 25,
                          top: 490,
                          child: Container(
                            height: 65,
                            width: 10,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                stops: dotColors[7] == Colors.grey[100]! ? [0.0, 0.0, 0.0] : dotColors2[7] == baseColor[800] ? [0.0, 1.0, 0.0]: [0.0, scala01.value, 0.0],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter, 
                                colors: [dotColors0[7], dotColors[7], dotColors0[7]],
                              )
                            ),
                          ),
                        ),

                        Positioned(
                          left: 10,
                          top: 50,
                          child: SizedBox(
                            width: 40,
                            height: 40,
                            child: Center(
                              child: Container(
                                width: 15,
                                height: 15,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: baseColor[100]!,
                                  border: Border.all(color: Colors.grey[900]!)
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 10,
                          top: 120,
                          child: SizedBox(
                            width: 40,
                            height: 40,
                            child: Center(
                              child: Container(
                                width: 15,
                                height: 15,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: dotColors2[1],
                                  border: Border.all(color: Colors.grey[900]!)
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 10,
                          top: 190,
                          child: SizedBox(
                            width: 40,
                            height: 40,
                            child: Center(
                              child: Container(
                                width: 15,
                                height: 15,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: dotColors2[2],
                                  border: Border.all(color: Colors.grey[900]!)
                                ),
                              ),
                            ),
                          ),
                        ),Positioned(
                          left: 10,
                          top: 260,
                          child: SizedBox(
                            width: 40,
                            height: 40,
                            child: Center(
                              child: Container(
                                width: 15,
                                height: 15,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: dotColors2[3],
                                  border: Border.all(color: Colors.grey[900]!)
                                ),
                              ),
                            ),
                          ),
                        ),Positioned(
                          left: 10,
                          top: 330,
                          child: SizedBox(
                            width: 40,
                            height: 40,
                            child: Center(
                              child: Container(
                                width: 15,
                                height: 15,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: dotColors2[4],
                                  border: Border.all(color: Colors.grey[900]!)
                                ),
                              ),
                            ),
                          ),
                        ),Positioned(
                          left: 10,
                          top: 400,
                          child: SizedBox(
                            width: 40,
                            height: 40,
                            child: Center(
                              child: Container(
                                width: 15,
                                height: 15,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: dotColors2[5],
                                  border: Border.all(color: Colors.grey[900]!)
                                ),
                              ),
                            ),
                          ),
                        ),Positioned(
                          left: 10,
                          top: 470,
                          child: SizedBox(
                            width: 40,
                            height: 40,
                            child: Center(
                              child: Container(
                                width: 15,
                                height: 15,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: dotColors2[6],
                                  border: Border.all(color: Colors.grey[900]!)
                                ),
                              ),
                            ),
                          ),
                        ),Positioned(
                          left: 10,
                          top: 540,
                          child: SizedBox(
                            width: 40,
                            height: 40,
                            child: Center(
                              child: Container(
                                width: 15,
                                height: 15,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: dotColors2[7],
                                  border: Border.all(color: Colors.grey[900]!)
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 30,
                          top: 50,
                          child: SizedBox(
                            width: 200,
                            height: 40,
                            child: Center(
                              child: SizedBox(
                                width: 200,child: Text("   Einführung", style: Theme.of(context).textTheme.headline6!.apply(
                                color: Colors.grey[900]!,
                                fontSizeDelta: -1
                              ),textAlign: TextAlign.start,),
                            )),
                          ),
                        ),
                        Positioned(
                          left: 30,
                          top: 120,
                          child: SizedBox(
                            width: 200,
                            height: 40,
                            child: Center(
                              child: SizedBox(
                                width: 200,
                                child: Text("   Kreuzverhör", style: Theme.of(context).textTheme.headline6!.apply(
                                color: Colors.grey[900]!,
                                fontSizeDelta: -1
                              ),textAlign: TextAlign.start,),
                            )),
                          ),
                        ),
                        Positioned(
                          left: 30,
                          top: 190,
                          child: SizedBox(
                            width: 200,
                            height: 40,
                            child: Center(
                              child: SizedBox(
                                width: 200,child: Text("   Buchstabenkette", 
                              textAlign: TextAlign.start,
                              style: Theme.of(context).textTheme.headline6!.apply(
                                color: Colors.grey[900]!,
                                fontSizeDelta: -1
                              )),),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 30,
                          top: 260, 
                          child: SizedBox(
                            width: 200,
                            height: 40,
                            child: Center(
                              child: SizedBox(
                                width: 200,child: Text("   Satz-Kombination", style: Theme.of(context).textTheme.headline6!.apply(
                                color: Colors.grey[900]!,
                                fontSizeDelta: -1
                              ),textAlign: TextAlign.start,),
                            )),
                          ),
                        ),
                        Positioned(
                          left: 30,
                          top: 330,
                          child: SizedBox(
                            width: 200,
                            height: 40,
                            child: Center(
                              child: SizedBox(
                                width: 200,child: Text("   Problemzauber", style: Theme.of(context).textTheme.headline6!.apply(
                                color: Colors.grey[900]!,
                                fontSizeDelta: -1
                              ),textAlign: TextAlign.start,),
                            ),
                          )),
                        ),
                        Positioned(
                          left: 30,
                          top: 400,
                          child: SizedBox(
                            width: 200,
                            height: 40,
                            child: Center(
                              child: SizedBox(
                                width: 200,child: Text("   Schlangenlinie", style: Theme.of(context).textTheme.headline6!.apply(
                                color: Colors.grey[900]!,
                                fontSizeDelta: -1
                              ),textAlign: TextAlign.start,),
                            )),
                          ),
                        ),
                        Positioned(
                          left: 30,
                          top: 470,
                          child: SizedBox(
                            width: 200,
                            height: 40,
                            child: Center(
                              child: SizedBox(
                                width: 200,child: Text("   Reimspiel", style: Theme.of(context).textTheme.headline6!.apply(
                                color: Colors.grey[900]!,
                                fontSizeDelta: -1
                              ),textAlign: TextAlign.start,),
                            ),
                          )),
                        ),
                        Positioned(
                          left: 30,
                          top: 540, 
                          child: SizedBox(
                            width: 200,
                            height: 40,
                            child: Center(
                              child: SizedBox(
                                width: 200,child: Text("   Ergebnisse", style: Theme.of(context).textTheme.headline6!.apply(
                                color: Colors.grey[900]!,
                                fontSizeDelta: -1
                              ),textAlign: TextAlign.start,),
                            )),
                          ),
                        )
                      ],
                    ),
                  )

                ],
              ),
            ),

          ),
          current == 0 ? Positioned(
            left: 250,
            right: 0,
            top: 0,
            bottom: MediaQuery.of(context).size.height - 300,
            child: RotatedBox(
              quarterTurns: 2,
              child: Image.asset("assets/intro.jpg", fit: BoxFit.cover),),
            
          ):Container(),
          current == 0 ? Positioned(
            left: 250,
            right: 0,
            top: 120,
            bottom: MediaQuery.of(context).size.height - 300,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color.fromARGB(0, 250, 250, 250), Color.fromARGB(250, 250, 250, 250)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.1, 1.0]
                )
              ),
            )
            
          ): Container(),
          Positioned(
            left: 250,
            right: 0,
            top: current == 0 ? 300 : 0,
            bottom: 0,
            child: Container(
              color: const Color.fromARGB(250, 250, 250, 250),
            ),
          ),
          Positioned(
            left: 260,
            right: 260,
            top: 0,
            bottom: 50,
            child: testWidget,
          ),
          loaded && testTimeView ? Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SizedBox(
              height: 7,
              child: AnimatedBuilder(
                animation: testTimeController,
                builder: (x,h) => LinearProgressIndicator(
                backgroundColor: Colors.transparent,
                color: Colors.blue,
                value: testTimeController.value,
              ),
            )),
          ) : Container(),
          loaded && (testTimeView || z) ? Positioned(
            right: 0,
            bottom: 10,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children:[GestureDetector(
                onTap: () async{
                  if(sw){
                    return;
                  }
                  sw = true;
                  if(current == 1){
                    //check words for meaning
                    if(checkTestAWords){
                      nextTask();
                      sw = false;
                      _TestACheckState.finishCorrection((){
                        
                      }, port, this);
                    }else{
                      await checkMeaning();
                      sw = false;
                    }return;
                  }
                  if(current == 2){
                    await Future.delayed(const Duration(milliseconds: 1234));
                   secureB();
                    sw = false;
return;
                  }
                  if(current == 3){
                    await Future.delayed(const Duration(milliseconds: 1234));
                    setState(() {
                      nextTask();
                    });
                    sw = false;
                    return;
                  }
                  if(current == 4){
                    await Future.delayed(const Duration(milliseconds: 1234));
                    setState(() {
                      nextTask();
                    });
                    sw = false;return;
                  }
                  if(current == 5){
                    await Future.delayed(const Duration(milliseconds: 1234));
                    setState(() {
                      nextTask();
                    });
                    sw = false;return;
                  }
                  if(current == 6){
                    await Future.delayed(const Duration(milliseconds: 1234));
                    setState(() {
                      nextTask();
                    });
                    sw = false;return;
                  }
                },
                child: MouseRegion(
                onHover:(p) => setState(() {
                  if(!z)
                  {
                    showNext = true;
                  }
                }),
                onEnter: (p) => setState(() {
                  if(!z)
                  {
                  showNext = true;
                  }
                }),
                onExit: (p) => setState(() {
                  if(!z)
                  {
                  showNext = false;
                  }
                }),
                child: SizedBox(
              height: 70,
              width: 150,
              
                  child: Center(child: showNext || z? const Icon(Icons.arrow_forward, color: Colors.blue, size: 40,) : AnimatedBuilder(
                animation: testTimeController,
                builder: (x,h) => Text((testTimeController.value*100).round().toString()+"%",textAlign: TextAlign.end, style: Theme.of(context).textTheme.headline3!.apply(
                  color: Colors.blue,
                ),))))),
            ),
            SizedBox(
              height: 20,
              child: Center(
                child: SizedBox(
                  child: Text(z ? "" : "Bei 100% ist die Zeit für diese Aufgabe abgelaufen. Zum frühzeitigen Weitermachen auf die Anzeige ⬆️ klicken.  "),
                ),
              ),
            )
            ]
            ),
          ) : Container()
          ,Positioned(
            right: 250,
            bottom: 200,
            child: FadeTransition(
            opacity: fade,child: OnHover(builder: (onHover){return GestureDetector(
              onTap: (){

                //click
                if(current == 0){
                  nextTask(); 
                  fadeController.forward();
                }

              },
              child: Container(
              width: 300,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black),
                color: onHover ? Colors.black : Colors.transparent
              ),
              child: Center(
                child: Text(buttonPos == 0 ? "Starten": (buttonPos == 1 ? "Weiter" : "Beenden"), style: Theme.of(context).textTheme.headline6!.apply(color: onHover ? Colors.white : Colors.black , fontSizeDelta: -3),),
              )
            )
          );}
            )
          ))
        ],
      ), 
    );
  }
  bool checkMeaningInProcess = false;
  Future<void> checkMeaning() async {
    
    if(checkMeaningInProcess){
      return;
    }
    testHigh.test1length = testHigh.testAWords.length;
    if(testHigh.testAWords.length < 3){
      //fill
      final List<String> fillElements = ["Entität", "Zustand", "Ort", "Situation", "Beziehung", "Ereignis", "Geschehen", "Ding", "Werk", "Gerät"];
      for (var i = testHigh.test1length; i < 3; i++) {
        testHigh.testAWords.add(fillElements[i]);
      }
    }
    checkMeaningInProcess = true;
    List<String> data = testHigh.testAWords;
    http.Response res = await http.get(Uri.parse("http://127.0.0.1:"+port+"/?test_id=0&method=0&input_data="+jsonEncode(data)));
    List elements = jsonDecode(res.body);
    List last = elements[elements.length-1];

    int count = 0;

    for(List element in last[0]){

      if (kDebugMode) {
        print("check element");
        print(element);
      }

      if(testHigh.meanings.length + testHigh.mutlipleMeanings.length == 10){
        break;
      }

      if(element.length == 1){
        testHigh.meanings.add({
          testHigh.testAWords[count]: [
            element[0][0], //id
            element[0][1] //header list
          ]
        });

      }else{

        testHigh.mutlipleMeanings.add({
          testHigh.testAWords[count]: [
            element
          ]
        });

      }

      count += 1;

    }
    checkMeaningInProcess = false;
    setState(() {
      checkTestAWords = true;
      timeOver = false;
      testTimeController.stop();
      testTimeController.value = 1.0;
    });

  }
  
}

class GrayscaleColorFiltered extends StatelessWidget {
  final Widget child;
  final bool active;

  const GrayscaleColorFiltered({Key? key, required this.child, this.active = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(active){
      return ColorFiltered(
        colorFilter: const ColorFilter.matrix(<double>[
          0.2126, 0.7152, 0.0722, 0, 0, //
          0.2126, 0.7152, 0.0722, 0, 0,
          0.2126, 0.7152, 0.0722, 0, 0,
          0, 0, 0, 1, 0,
        ]),
        child: child,
      );
    }else{
      return child;
    }
  }
}

class OnHover extends StatefulWidget {
  final Widget Function(bool isHovered) builder;
  const OnHover({Key? key, required this.builder}) : super(key: key);
  @override
  _OnHoverState createState() => _OnHoverState();
}

class _OnHoverState extends State<OnHover> {
  bool isHovered = false;
  @override
  Widget build(BuildContext context) {
    final hovered = Matrix4.identity()..translate(0.0,-10.0,0.0);
    final transform = isHovered ? hovered : Matrix4.identity();
    return MouseRegion(
      onEnter: (_)=> onEntered(true),
      onExit: (_)=> onEntered(false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        transform: transform,
        child: widget.builder(isHovered),
      ),
    );
  }
  void onEntered(bool isHovered){
    setState(() {
      this.isHovered = isHovered;
    });
  }
}

class Intro extends StatefulWidget {
  const Intro({ Key? key }) : super(key: key);

  @override
  _IntroState createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  @override
  Widget build(BuildContext context) {
    /*
    Einführung

    Aufbau

    Regeln

    Beachten
    */
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 220,),
        Text("Einführung", style: Theme.of(context).textTheme.headline2!.apply(
          color: Colors.black
        ),textAlign: TextAlign.start,),
        const SizedBox(height: 30,),
        Text("Der KreativTest besteht aus 6 Aufgaben, die wiederum aus Teilaufgaben betstehen können. Es gibt auch Aufgaben, bei denen eine gewisse Zeit zur Bearbeitung vorgesehen ist. Insgesamt dauert der Test nicht länger als 15 - 30 Minuten. Versuche den Anweisungen exakt zu folgen. Dieser Test erfordert Konzentration. Das Ablenken durch Buch oder Handy sollte vermieden werden.", style: Theme.of(context).textTheme.subtitle1!.apply(color: Colors.black, fontWeightDelta: 0)),
        const SizedBox(height: 30,),
        Text("Es gibt folgende Regeln zu beachten:\na) Die Lösung darf nur durch eigenständiges Überlegen erstellt werden.\nb) Die Aufgabenstellung gilt es stets zu beachten.",style: Theme.of(context).textTheme.subtitle1!.apply(color: Colors.black, )),
        const SizedBox(height: 30,),
        Text("Viel Glück bei den Aufgaben. Sei Kreativ und habe Freude am Denken!",style: Theme.of(context).textTheme.subtitle1!.apply(color: Colors.black, ))
      ],
    );
  }
}

class Load extends StatefulWidget {
  bool correct;
  SimpleListener listener;
  Shell shell = Shell();
  Load(this.correct, { Key? key , required this.listener}):super(key: key);

  @override
  _LoadState createState() => _LoadState();
}

class _LoadState extends State<Load> {

  @override
  void initState() {
    super.initState();
    //load
    //call python
    if(widget.correct){
      print("load");
    loadData().then((value){
      widget.listener.onLoadingFinished(0, widget.shell, port);
    }); 
    }
  }

  String port = "";

  Future<int> loadData() async{
    Directory documents = await getApplicationDocumentsDirectory();
    if(!(await documents.absolute.list(followLinks: false).any((element) => element.path.endsWith("testdict")))){
      //create python dataset
      String destPath = documents.path+"/testdict/";

      ByteData bytes = (await rootBundle.load("python/python_script.zip"));

      Archive archive = ZipDecoder().decodeBuffer(InputStream(bytes));

      for(ArchiveFile file in archive){
        String filename = file.name;
        String decodePath = destPath + filename;
        if (file.isFile) {
          List<int> data = file.content;
          File(decodePath)
            ..createSync(recursive: true)
            ..writeAsBytesSync(data);
      } else {
          Directory(destPath).create(recursive: true);
      }
      }

    }
    //make a test request to our test
    //port = 24232, but here 5000
    int x = await tryPort(24232, documents);
    print(x);
    if(x != 0){
      return x;
    }
    await Future.delayed(const Duration(seconds: 2));
    while(true){
      try{
        http.Response res = await http.get(Uri.parse("http://127.0.0.1:"+port+"/?test_id=-1&method=0&input_data=[]"));
        break;
      }catch(e){
        if(e is SocketException){
          sleep(const Duration(milliseconds: 50));
        }else{
          print(e);
          return 1;
        }
      }
    }
    return 0;
  }



  Future<int> tryPort(int basePort, Directory documents) async{
    try{
      http.Response res = await http.get(Uri.parse('http://127.0.0.1:'+basePort.toString()));
      if(res.statusCode == 403){
        return setupLocalhostServer(documents, basePort);
      }else{
        
        basePort += 1;
        return tryPort(basePort, documents);

      }
    }catch(e) {
      if(e is SocketException){
        //the uri is available
        
        return setupLocalhostServer(documents, basePort);
      }else{
        if (kDebugMode) {
          print(e);
        }
        return 1;
      }
    }
  }

  Future<int> setupLocalhostServer(Directory documents, int port) async{
    try{
    //start flask python server on localhost
    Shell shell = Shell();
    //run python run command in terminal
    shell = shell.pushd(documents.path+"/testdict/venv/bin");
    //run sh (shell) command (running flask command)
    //flask command is set into the app.py (original test.py) directory
    //adding port number
    await Future.delayed(const Duration(seconds: 1));
    shell.run("sh "+ documents.path +"/testdict/flask run --port "+port.toString());
    widget.shell = shell;
    this.port = port.toString();

    }catch(e){
      if (kDebugMode) {
        print(e);
      }
      return 1;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 200,
          height: 200,
          child: ColorFiltered(
            colorFilter: const ColorFilter.matrix([
                             -1, 0, 0, 0, 255, //
    0, -1, 0, 0, 255, //
    0, 0, -1, 0, 255, //
    0, 0, 0, 1, 0, //
                          ]),
            child: Image.asset("assets/load.gif")),
        ),
        Text("Laden...", style: Theme.of(context).textTheme.bodyText1!.apply(
          fontSizeDelta: 2
        ),)
      ],
    );
  }
}

class TestA extends StatefulWidget {

  /*
   *
   *  
   * 
   */
  String path;
  Function onError;
  TestA({ Key? key, required this.path, required this.onError}) : super(key: key);

  @override
  _TestAState createState() => _TestAState();
}

class _TestAState extends State<TestA> {

  bool sv0 = false;
  int errorcode = -1;
  String errorText = "";
  List<String> data = [];
  late TextEditingController _controller;
  var focusNode = FocusNode();



  Future<bool> checkWord(String word) async{

    Uri uri = Uri.parse('http://127.0.0.1:'+widget.path+'/?test_id=0&method=-1&input_data=["'+word+'"]');
    try{
      http.Response res = await http.get(uri);
      List<dynamic> ls = jsonDecode(res.body);
      bool b0 = ls[ls.length-1][0];
      return b0;
    }catch(e){
      if(e is SocketException){
        //the server is down, errorcode = 2
        widget.onError.call(2);
      }else{
        widget.onError.call(-1);
      }
      return false;
    }

  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    data = [];
    entered = [];
  }

  @override
  void dispose() {
    _controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:[
        const SizedBox(
          height: 100,
        ),
        Text("Kreuzverhör", style: Theme.of(context).textTheme.headline2!.apply(
          color: Colors.black
        ),),
        const SizedBox(
          height: 10,
        ),
        Container(
          height: 100,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(10  )
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 100,
                width: 100,
                child: Center(
                  child: Icon(Icons.keyboard_arrow_right_outlined, size: 50,)
                ),
              ),
              SizedBox(
                height: 100,
                width: 1000,
                child: Center(child: Text("Finde 10 möglichst unterschiedliche Wörter und trage diese in der Liste ein. Die Wörter müssen Nomen sein. Du hast für die Aufgabe 4 Minuten Zeit (siehe unten rechts). ", style: Theme.of(context).textTheme.subtitle1!.apply(
                  fontSizeDelta: 1
                ),)),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          height: 600,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey[400]!)
          ),
          child: SizedBox(
            height: 500,
            
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 50,
                ),
                SizedBox(
                  width: 600,
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: 400,
                        height: 50,
                        
                        child: TextFormField(
                          focusNode: focusNode,
                          controller: _controller,
                          onFieldSubmitted: (t) async{
                            bool b = await addW(t);
                            if(b){
                              _controller.text = "";
                            }
                            focusNode.requestFocus();
                            
                          },
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.black)
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.black)
                            ),
                            fillColor: Colors.black,
                            focusColor: Colors.black,
                            labelText: "Neues Wort",
                            labelStyle: const TextStyle(color: Colors.black),
                            
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async{
                          if(await addW(_controller.value.text)){
                            setState(() {
                              _controller.text = "";
                            });
                            focusNode.requestFocus();
                          }
                        },
                        child: MouseRegion(
                        onEnter: (p){
                          setState(() {
                            sv0 = true;
                          });
                        },
                        onExit: (p){
                          setState(() {
                            sv0 = false;
                          });
                        },
                        child: Container(
                        width: 150,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: data.length < 10 ? Colors.blue.shade600: Colors.grey[400]!, width: 2),
                          color: sv0 ? Colors.white: (data.length < 10 ?Colors.blue:Colors.grey[400]!)
                        ),
                        child: Center(
                          child: Text("Bestätigen", style: Theme.of(context).textTheme.headline6!.apply(
                            color: sv0 ? (data.length < 10 ?Colors.blue:Colors.grey[400]!) : Colors.white,
                            fontSizeDelta: -2
                          ),),
                        ),
                      )
                      )
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                errorcode >= 0 ? SizedBox(
                  
                  height: 75,
                  child: Center(child: Container(
                  width: 570,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.red[500]
                ),
                child: Center(child: SizedBox(
                  width: 550,
                  child: Text(errorText,
                  
                 textAlign: TextAlign.left, style: Theme.of(context).textTheme.headline6!.apply(
                  color: Colors.white,
                  fontSizeDelta: -4,
                  fontWeightDelta: -1
                ))))),),
                ) : Container(),
                SizedBox(
                  width: 1100,
                  height: 350,
                  child: Wrap(
                    spacing: 25,
                    runSpacing: 25,
                    children: dataRowWidgets(),)
                )
              ]
            ),
          )
        )
      ],
    );
  }

  Future<bool> addW(String w) async{
    if(data.length <= 10){
      String t = _controller.value.text;
      if(!await checkWord(t)){
        setState(() {
          errorcode = 0;
          errorText = "Dieses Wort wurde nicht gefunden.";
        });
        return false;
      }else{  
        setState(() {
          errorcode = -1;
          errorText = "";
          entered.add(false);
          data.add(t);
          testHigh.testAWords.add(t);
        });
        return true;
      }

    }
    return false;

  }

  List<bool> entered = [];
  List<Widget> dataRowWidgets(){
    List<Widget> widgets = [];
    if(data.length > 10){
      data = data.getRange(0, 10).toList();
    }
    for (var i = 0; i < data.length; i++) {
      widgets.add(SizedBox(
        width: 200,
        height: 160,
        child: MouseRegion(
          onHover: (p){
            if(!entered[i]){
              setState(() {
                entered[i] = true;
              });
            }
          },
          onExit: (p){
            setState(() {
              entered[i] = false;
            });
          },
          onEnter: (p){
            setState(() {
              entered[i] = true;
            });
          },
          child: GestureDetector(
                onTap: (){
                  if(entered[i]){
                    setState(() {
                    data.removeAt(i);
                    testHigh.testAWords.removeAt(i);
                    entered[i] = false;
                  });
                  }
                },child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.withAlpha(20),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey[400]!)
            ),
            child: Center(
              child: !entered[i] ? Text(data[i], style: Theme.of(context).textTheme.subtitle1!.apply(
                color: Colors.grey[500]!,
                fontSizeDelta: 4
              ),):
                const Icon(Icons.cancel_outlined, size: 25,color: Colors.grey,),
              ),
            ),
          )
        ),
      ));
      
    }
    return widgets;
  }
}

class TestACheck extends StatefulWidget {
  final _TestState widget;
  final Function con;
  final String port;
  final Function(int) error;
  const TestACheck(this.widget, this.con, this.port, this.error, { Key? key }) : super(key: key);

  @override
  _TestACheckState createState() => _TestACheckState();
}

class _TestACheckState extends State<TestACheck> {

  int position = 0;
  bool sv0 = false;
  late TextEditingController _controller;
  static Map<String, String> needed = {}; //word: id
  List<List> infos = [];
  bool found = false;
  var focusNode = FocusNode();

  @override
  void initState() {
    if(testHigh.mutlipleMeanings.isEmpty || testHigh.test1length == 0){
      finishCorrection(widget.con, widget.port, widget.widget).then((value){
         
      });
      widget.con.call();
    }
    super.initState();
    _controller = TextEditingController();

    if (kDebugMode) {
      print(testHigh.mutlipleMeanings.length);
    }

    
  }

  @override
  void dispose() {
    _controller.dispose();
    focusNode.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    if(testHigh.mutlipleMeanings.isEmpty){

      return Container();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:[
        const SizedBox(
          height: 100,
        ),
        Text("Kreuzverhör (Korrektur)", style: Theme.of(context).textTheme.headline2!.apply(
          color: Colors.black
        ),),
        const SizedBox(
          height: 10,
        ),
        Container(
          height: 100,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(10  )
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 100,
                width: 100,
                child: Center(
                  child: Icon(Icons.keyboard_arrow_right_outlined, size: 50,)
                ),
              ),
              SizedBox(
                height: 100,
                width: 1000,
                child: Center(child: Text("Die Bedeutung folgender mehrdeutiger Wörter muss geklärt werden. Dazu muss ein Synonym für das Wort eingegeben werden. Das Synonym muss ein Nomen im Singular sein.", style: Theme.of(context).textTheme.subtitle1!.apply(
                  fontSizeDelta: 1
                ),)),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          height: 600,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey[400]!)
          ),
          child: SizedBox(
            height: 500,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 50,
                ),
                SizedBox(
        width: 200,
        height: 160,child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.withAlpha(20),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey[400]!)
            ),
            child: Center(
              child: Text(testHigh.mutlipleMeanings[position].keys.toList()[0], style: Theme.of(context).textTheme.subtitle1!.apply(
                color: Colors.grey[500]!,
                fontSizeDelta: 4
              ),)
        )),
            ),
            const SizedBox(height: 20,),
                SizedBox(
                  width: 600,
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: 400,
                        height: 50,
                        
                        child: TextFormField(
                          focusNode: focusNode,
                          controller: _controller,
                          onFieldSubmitted: (t) async{
                            runSyn(_controller.value.text, testHigh.mutlipleMeanings[position].keys.toList()[0]);
                            _controller.text = "";
                            setState(() {
                              found = true;
                            });
                            focusNode.requestFocus();
                            Future.delayed(const Duration(seconds: 1)).then((value) {
                              setState(() {
                                closed = false;
                                found = false;
                                if(position + 1 < testHigh.mutlipleMeanings.length){
                                  position += 1;
                                }else{
  
                                  finishCorrection((){}, widget.port, widget.widget);
                                  widget.con.call();

                                }
                              },);
                            });
                          },
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.black)
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.black)
                            ),
                            fillColor: Colors.black,
                            focusColor: Colors.black,
                            labelText: "Synonym, Überbegriff oder Unterbegriff für "+testHigh.mutlipleMeanings[position].keys.toList()[0],
                            labelStyle: const TextStyle(color: Colors.black),
                            
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async{
                          runSyn(_controller.value.text, testHigh.mutlipleMeanings[position].keys.toList()[0]);
                          _controller.text = "";
                          focusNode.requestFocus();
                          Future.delayed(const Duration(seconds: 1)).then((value) {
                              setState(() {
                                closed = false;
                                found = false;
                                if(position + 1 < testHigh.mutlipleMeanings.length){
                                  position += 1;
                                }else{
                                  finishCorrection((){}, widget.port, widget.widget);
                                  widget.con.call();

                                }
                              });
                            });
                        },
                        child: MouseRegion(
                        onEnter: (p){                                                                                                                                                                                                                 
                          setState(() {
                            sv0 = true;
                          });
                        },
                        onExit: (p){
                          setState(() {
                            sv0 = false;
                          });
                        },
                        child: Container(
                        width: 150,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.blue.shade600, width: 2),
                          color: sv0 ? Colors.white: Colors.blue),
                        
                        child: Center(
                          child: Text("Bestätigen", style: Theme.of(context).textTheme.headline6!.apply(
                            color: sv0 ? Colors.blue : Colors.white,
                            fontSizeDelta: -2
                          ),),
                        ),
                      )
                      )
                      )
                      
                    ],
                  ),
                ),
                
                const SizedBox(
                  height: 15,
                ),
                found ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [SizedBox(
        height: 160,child: Container(
          width: 200,
            decoration: BoxDecoration(
              color: Colors.grey.withAlpha(20),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey[400]!)
            ),
            child: const Center(
              child: Icon(Icons.check, color: Colors.blue,
              ),)
        ),
            )]) : Container(),
                
                
              ]
            ),
            
          ),
          
        ),
        const SizedBox(height: 20,),


      ],
    );
  
  }
  static bool f0 = false;
  static Future<void> finishCorrection(Function con, String port, _TestState widget) async{
    print("finishCorrection");
    if( f0){
      return;
    }
    f0 = true;

    while(widget.checkMeaningInProcess){
      print("...");
      await Future.delayed(const Duration(seconds: 1));
    }

    print(testHigh.testAWords);

    // await Future.delayed(const Duration(seconds: 4));

    if(needed.length < testHigh.testAWords.length){
      //fill needed list with default ids
      for(String word in testHigh.testAWords){
        if(!needed.keys.toList().contains(word)){
          print(testHigh.meanings);
          print(testHigh.mutlipleMeanings);
          print(word);
          Map? m;
          for(Map mm in testHigh.meanings){
            if(mm.keys.toList()[0] == word){
              m = mm;
              break;
            }
          }
          if(m == null){
            for(Map n in testHigh.mutlipleMeanings){
              if(n.keys.toList()[0] == word){
                m = {"z":n.values.toList()[0][0][0]};
                break;
              }
            }
          }
          if(m!.keys.contains("z")){
            print(m);
            print("?");
            needed[word] = m.values.toList()[0][0]; 
          }else{
            needed[word] = m.values.toList()[0][0];
          }
        }
      }
    }

    List<List> t0 = [];
    List<String> t1 = [];
    needed.forEach((key, value) {
      t0.add([value]);
      t1.add(key);
    });
    testHigh.testAWords = t1;
    print("=");
    http.Response res = await http.get(Uri.parse("http://127.0.0.1:"+port+"/?test_id=0&method=1&input_data="+jsonEncode([t0, t1])));
    print(res.body);
    List entries = jsonDecode(res.body);
    print(entries);
    testHigh.dynamicTestAOut = entries;
    if(con != null){
      con.call();
    }


  }
  bool closed = false;
  void runSyn(String w, String original) async{
    if(closed){
      return;
    }
    closed = true;
    print("?");
    print(needed);
    /*if(w == testHigh.mutlipleMeanings[position].keys.toList()[0]){
      //search simple form
      for(List st in testHigh.mutlipleMeanings[position].values.toList()){
        st = st[0];
        if((st[1] as List).length == 1 && (st[1] as List)[0] == w){
          needed[original] = st[0];
          infos.add(st[1]);
          return;
        }
      }
    }*/

    print(testHigh.mutlipleMeanings[position]);

    for(List st in testHigh.mutlipleMeanings[position].values.toList()){
      st = st[0];
      for(List s in st){
        print("check"+s[0]);
        for(String ww in s[1]){
          if(ww == w){
          needed[original]=s[0];

          infos.add([s[1]]);
          return;

        
        }
        }
        for(List lex in s[2]){

        for(String l in lex){
          if(l == w){

            needed[original]=s[0];
            infos.add([s[1]]);
            return;

          }

        }

      }

      }
      

    }
    needed[original] = testHigh.mutlipleMeanings[position].values.toList()[0][0][0][0];
    infos.add(testHigh.mutlipleMeanings[position].values.toList()[0][0][1]);
    if (kDebugMode) {
      print(needed);
    }
  }
  


}

class TestB extends StatefulWidget {
  final String port;
  final Function(int) onError;
  final Function con;
  const TestB(this.port, this.con, this.onError, { Key? key }) : super(key: key);

  @override
  _TestBState createState() => _TestBState();
}

class _TestBState extends State<TestB> {

  bool loaded = false;
  int errorcode = -1;
  String errorText = "";
  late List<String> testWords;
  int pos = 0;
  var focusNode = FocusNode();
  late TextEditingController _controller;
  bool sv0 = false;
  bool sv1 = false;
  Map<int, List<String>> data = {0:[], 1:[], 2:[]};

  @override
  void initState() {
    super.initState();
    loadTest3Words();
    _controller = TextEditingController();
  }

  void loadTest3Words() async{
    print(testHigh.testAWords);
    http.Response res = await http.get(Uri.parse("http://127.0.0.1:"+widget.port+"/?test_id=1&method=0&input_data="+jsonEncode(testHigh.testAWords)));
    //returning list test words
    List out = jsonDecode(res.body) as List;
    print(out[out.length-1]);
    testWords = (out[out.length-1] as List).cast<String>();
    if(testWords.length < 3){

      testWords = testHigh.testAWords.getRange(0,3).toList();

    } 
    setState(() {
      loaded = true;
    });
  }

  @override
  void dispose() {
    focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(loaded){
       Map<String, List<String>> m = {};

                            for (var i = 0; i < data.keys.length; i++) {
                              m[testWords[i]] = data[i]!;
                            }

                            testHigh.testBMapList = m;
    }
    return loaded ? Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:[
        const SizedBox(
          height: 100,
        ),
        Text("Buchstabenkette", style: Theme.of(context).textTheme.headline2!.apply(
          color: Colors.black
        ),),
        const SizedBox(
          height: 10,
        ),
        Container(
          height: 100,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(10  )
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 100,
                width: 100,
                child: Center(
                  child: Icon(Icons.keyboard_arrow_right_outlined, size: 50,)
                ),
              ),
              SizedBox(
                height: 100,
                width: 1000,
                child: Center(child: Text("Finde für die folgenden Begriffe möglichst viele ähnliche Wörter. Die Wörter müssen Nomen sein.", style: Theme.of(context).textTheme.subtitle1!.apply(
                  fontSizeDelta: 3
                ),)),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          height: 600,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey[400]!)
          ),
          child: SizedBox(
            height: 500,
            
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 50,
                ),
                SizedBox(
                  height: 50,
                  child: Center(
                    child: Container(
                      height: 50,
                      width: 150,
                      decoration: BoxDecoration(
                        color: Colors.grey[400]!.withAlpha(50),
                        borderRadius: BorderRadius.circular(15)
                      ),
                      child: Center(child:Text('"'+ testWords[pos] +'"', style: Theme.of(context).textTheme.headline6!.apply(
                      color: Colors.black,

                    ))))
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  width: 800,
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: 400,
                        height: 50,
                        
                        child: TextFormField(
                          focusNode: focusNode,
                          controller: _controller,
                          onFieldSubmitted: (t) async{
                            if(await addW(_controller.text)){
                              _controller.text = "";
                            }
                            focusNode.requestFocus();
                          },
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.black)
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.black)
                            ),
                            fillColor: Colors.black,
                            focusColor: Colors.black,
                            labelText: "Möglichst Ähnliches Wort für "+testWords[pos],
                            labelStyle: const TextStyle(color: Colors.black),
                            
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async{
                          if(await addW(_controller.text)){
                            _controller.text = "";
                          }
                          focusNode.requestFocus();
                        },
                        child: MouseRegion(
                        onEnter: (p){                                                                                                                                                                                                                 
                          setState(() {
                            sv0 = true;
                          });
                        },
                        onExit: (p){
                          setState(() {
                            sv0 = false;
                          });
                        },
                        child: Container(
                        width: 150,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.blue.shade600, width: 2),
                          color: sv0 ? Colors.white: Colors.blue),
                        
                        child: Center(
                          child: Text("Bestätigen", style: Theme.of(context).textTheme.headline6!.apply(
                            color: sv0 ? Colors.blue : Colors.white,
                            fontSizeDelta: -2
                          ),),
                        ),
                      )
                      )
                      ),
                      GestureDetector(
                        onTap: () async{
                          if(pos == 2){

                            setState(() {
                              loaded = false;
                            });

                            //save task
                            Map<String, List<String>> m = {};

                            for (var i = 0; i < data.keys.length; i++) {
                              m[testWords[i]] = data[i]!;
                            }

                            testHigh.testBMapList = m;
                            //finish
                            widget.con.call();

                          }
                          setState(() {
                            if(pos < 2){
                              pos++;
                              errorText = "";
                              errorcode = -1;
                            }
                            hovering = [];
                          });
                        },
                        child: MouseRegion(
                        onEnter: (p){                                                                                                                                                                                                                 
                          setState(() {
                            sv1 = true;
                          });
                        },
                        onExit: (p){
                          setState(() {
                            sv1 = false;
                          });
                        },
                        child: Container(
                        width: 180,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.blue.shade600, width: 2),
                          color: !sv1 ? Colors.white: Colors.blue),
                        
                        child: Center(
                          child: Text(pos == 2 ? "Nächste Aufgabe": "Nächster Begriff", style: Theme.of(context).textTheme.headline6!.apply(
                            color: !sv1 ? Colors.blue : Colors.white,
                            fontSizeDelta: -2
                          ),),
                        ),
                      )
                      )
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                errorcode >= 0 ? SizedBox(
                  
                  height: 75,
                  child: Center(child: Container(
                  width: 570,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.red[500]
                ),
                child: Center(child: SizedBox(
                  width: 550,
                  child: Text(errorText,
                  
                 textAlign: TextAlign.left, style: Theme.of(context).textTheme.headline6!.apply(
                  color: Colors.white,
                  fontSizeDelta: -4,
                  fontWeightDelta: -1
                ))))),),
                ) : Container(),
                SizedBox(
                  width: 1100,
                  height: 300,
                  child: Wrap(
                    spacing: 25,
                    runSpacing: 25,
                    children: getAll(),)
                )
              ]
            ),
          )
        )
      ],
    ) : Container();
  }

Future<bool> addW(String w) async{
    if(data.length <= 10){
      String t = _controller.value.text;
      if(!await checkWord(t)){
        setState(() {
          errorcode = 0;
          errorText = "Dieses Wort wurde nicht gefunden.";
        });
        return false;
      }else{  

        if(data[pos]!.contains(w)){

          setState(() {
            errorcode = 1;
            errorText = "Dieses Wort hast du bereist eingegben";

          });
          return false;
        }else{
           setState(() {
          errorcode = -1;
          errorText = "";
          hovering.add(false);
          data[pos]!.add(t);
        });
        return true;
        }
      }

    }
    return false;

  }


Future<bool> checkWord(String word) async{

    Uri uri = Uri.parse('http://127.0.0.1:'+widget.port+'/?test_id=0&method=-1&input_data=["'+word+'"]');
    try{
      http.Response res = await http.get(uri);
      List<dynamic> ls = jsonDecode(res.body);
      bool b0 = ls[ls.length-1][0];
      return b0;
    }catch(e){
      if(e is SocketException){
        //the server is down, errorcode = 2
        widget.onError.call(2);
      }else{
        widget.onError.call(-1);
      }
      return false;
    }

  }
List<bool> hovering = List.empty(growable: true);
List<Widget> getAll(){
  List<Widget> ww = [];
  for(String word in data[pos]!){
    final int cc = data[pos]!.indexOf(word);
    ww.add(
      MouseRegion(
        onEnter: (p){
          setState(() {
            hovering[cc] = true;
          });
        },
        onExit: (p){
          setState(() {
            hovering[cc] = false;
          });
        },
        onHover: (p){
          setState(() {
            hovering[cc] = true;
          });
        },
        
        child: GestureDetector(
          onTap: (){
            setState(() {
              hovering[cc] = false;
              data[pos]!.remove(word);
            });
            hovering[cc] = false;
          },
          child: Container(
        width: 150,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.grey[400]!.withAlpha(80),
          borderRadius: BorderRadius.circular(10)
        ),
        child: Center(
          child: !hovering[cc] ? Text(word,overflow: TextOverflow.ellipsis,maxLines: 1, style: Theme.of(context).textTheme.headline6!.apply(
                      color: Colors.black,

                    )) : const Icon(Icons.cancel, color: Colors.black,)
        ),
      ))
    ));
  }

  return ww;
}
}

class TimeOver extends StatefulWidget {
  final Function c;
  const TimeOver(this.c, {Key? key}) : super(key: key);

  @override
  _TimeOverState createState() => _TimeOverState();
}

class _TimeOverState extends State<TimeOver> {
  
  bool focus = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.timer_off, color: Colors.grey[400]!,size: 80.0,),
        SizedBox(
          height: 80,
          child: Center(
            child: Text("Die Zeit ist abgelaufen", style: Theme.of(context).textTheme.headline6!.apply(
              color: Colors.grey[400]!
            ),),
          )
        ),
        SizedBox(
          height: 100,
          child: Center(
            child: GestureDetector(
              onTap: (){
                widget.c.call();
              },
              child: MouseRegion(
                onEnter: (p) => setState(() {
                  focus = true;
                }),
                onExit: (p) => setState(() {
                  focus = false;
                }),
                onHover: (p) => setState(() {
                  focus = true;
                }),
                child: Container(
              width: 300,
              height: 50,
              decoration: BoxDecoration(
                color: focus ? Colors.white : Colors.blue,
                border: Border.all(color: Colors.blue.shade600, width: 2),
              
                borderRadius: BorderRadius.circular(10)
              ),
              child: Center(
                child: Text("Weiter", style: Theme.of(context).textTheme.subtitle1!.apply(
                  color: focus ? Colors.blue : Colors.white
                ),),
              ),
            )))
          ),
        )
      ],
    );
  }
}

class TestC extends StatefulWidget {
  final String port;
  final Function con;
  final Function(int) error;
  _TestState widget;
  TestC(this.widget, this.port, this.con, this.error, { Key? key }) : super(key: key);

  @override
  _TestCState createState() => _TestCState();
}

class _TestCState extends State<TestC> {

  var focusNode = FocusNode();
  late TextEditingController _controller;
  int errorcode = -1;
  String errorText = "";
  bool sv0 = false;
  Map<String, String> winners = {};

  @override
  void initState() {
    super.initState();
    ticked = List.filled(testHigh.testAWords.length, false);
    _controller = TextEditingController();
    checkWinners();
  }
 
  void checkWinners()async{
    if(testHigh.dynamicTestAOut.isEmpty){

      while(testHigh.dynamicTestAOut.isEmpty){
        await Future.delayed(const Duration(seconds: 1));
      }

    }
    //loadTestA ddata
    if(testHigh.dynamicTestAOut[0] == 0){

      //nothing enetered
      int count = 0;
      for(String word in testHigh.testAWords){

        if(count == 0){
          winners[word] = testHigh.testAWords[1];
        }else{
          winners[word] = testHigh.testAWords[count - 1];
        }

        count++;
      }

    }else{

      Map out = (testHigh.dynamicTestAOut[testHigh.dynamicTestAOut.length-1] as List)[0] as Map;
      print(out);
      int index = 0;
      try{
      for(String word in testHigh.testAWords){
        if(out.keys.length <= index){
          

          winners[word] = winners[winners.keys.toList()[index - 1]]!;

          index++;
          continue;

        }
        print(index);
        List ll = out[index.toString()] as List;
        print(ll);
        double min = 2;
        int min_index = 0;
        for(dynamic score in ll){
          if(score is int){
            score = score.toDouble();
          }
          if(score < min && score != 0.0){
            min = score;
            min_index = ll.indexOf(score);
          }

        }
        for(String key in out.keys){
          if(out[key][index] < min && out[key][index] != 0){
            min = out[key][index];
            min_index = out.keys.toList().indexOf(key);
          }
        }
        winners[word] = testHigh.testAWords[min_index];
        index++;
      }
      }catch(e){
        print(e);
      }

    }

  }

  @override
  void dispose() {
    focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:[
        const SizedBox(
          height: 100,
        ),
        Text("Satz-Kombination", style: Theme.of(context).textTheme.headline2!.apply(
          color: Colors.black
        ),),
        const SizedBox(
          height: 10,
        ),
        Container(
          height: 100,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(10  )
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 100,
                width: 100,
                child: Center(
                  child: Icon(Icons.keyboard_arrow_right_outlined, size: 50,)
                ),
              ),
              SizedBox(
                height: 100,
                width: 1000,
                child: Center(child: Text("Wähle 3 Begriffe aus und bilde aus diesen einen vollständigen Hauptsatz. Der Satz muss grammatikalisch korrekt und logisch sein. Dafür hast du 4 Minuten Zeit.", style: Theme.of(context).textTheme.subtitle1!.apply(
                  fontSizeDelta: 3
                ),)),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          height: 600,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey[400]!)
          ),
          child: SizedBox(
            height: 500,
            
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                        height: 50,
                      ),
                      //checkboxes
                SizedBox(
                        height: 150,
                        width: 1200,
                        child: 
                        Column(
                          children: [
                            Text("Wähle 3 der folgenden Wörter aus, die in dem Satz vorkommen sollen", style: Theme.of(context).textTheme.subtitle1!.apply(
                              color: Colors.grey[400],

                            )),
                            const SizedBox(
                              height: 50
                            ),
                            SizedBox(
                              width: 1200,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: sup(),
                              )
                            )
                          ],
                )),
                const SizedBox(height: 30),
                SizedBox(
                  width: 900,
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                    
                      SizedBox(
                        width: 650,
                        height: 50,
                        
                        child: TextFormField(
                          focusNode: focusNode,
                          controller: _controller,
                          onFieldSubmitted: (t) async{
                            if(await addS(_controller.text)){
                              
                            }
                            focusNode.requestFocus();
                          },
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.black)
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.black)
                            ),
                            fillColor: Colors.black,
                            focusColor: Colors.black,
                            labelText: "Vollständiger Satz",
                            labelStyle: const TextStyle(color: Colors.black),
                            
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async{
                          if(await addS(_controller.text)){
                            
                          }else{
                            focusNode.requestFocus();
                          }
                        },
                        child: MouseRegion(
                        onEnter: (p){                                                                                                                                                                                                                 
                          setState(() {
                            sv0 = true;
                          });
                        },
                        onExit: (p){
                          setState(() {
                            sv0 = false;
                          });
                        },
                        child: Container(
                        width: 150,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.blue.shade600, width: 2),
                          color: sv0 ? Colors.white: Colors.blue),
                        
                        child: Center(
                          child: Text("Bestätigen", style: Theme.of(context).textTheme.headline6!.apply(
                            color: sv0 ? Colors.blue : Colors.white,
                            fontSizeDelta: -2
                          ),),
                        ),
                      )
                      )
                      ),
                    ],
                  ),
                ),
                
                errorcode >= 0 ? SizedBox(
                  
                  height: 75,
                  child: Center(child: Container(
                  width: 570,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.red[500]
                ),
                child: Center(child: SizedBox(
                  width: 550,
                  child: Text(errorText,
                  
                 textAlign: TextAlign.left, style: Theme.of(context).textTheme.headline6!.apply(
                  color: Colors.white,
                  fontSizeDelta: -4,
                  fontWeightDelta: -1
                ))))),),
                ) : Container(),
              infotext != "" ? SizedBox(
                  
                  height: 75,
                  child: Center(child: Container(
                  width: 570,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[400]!.withAlpha(120)
                ),
                child: Center(child: SizedBox(
                  width: 550,
                  child: Text(infotext,
                  
                 textAlign: TextAlign.center, style: Theme.of(context).textTheme.headline6!.apply(
                  color: Colors.white,
                  fontSizeDelta: -6,
                  fontWeightDelta: -1
                ))))),),
                ) : Container(),
              ]
            ),
          )
        )
      ],
    );
  }

  late List<bool> ticked;

  bool c3(){
    int x = 0;
    for(bool b in ticked){
      if(b){
        x++;
      }
    }
    return x > 2 ;
  }

  List<Widget> sup(){

    List<Widget> ww = [];
    for (var i = 0; i < testHigh.testAWords.length; i++) {
      final String word = testHigh.testAWords[i];
      ww.add(
        GestureDetector(
          onTap: (){
            if(!(!ticked[i] && c3())){          
            setState(() {
              ticked[i] = !ticked[i];
            });
            }
          },
          child: SizedBox(
          width: 115,
          height: 55,
          child:
        Stack(
          alignment: Alignment.bottomLeft,
          children: [
            SizedBox(
          width: 115,
          height: 63,
          child:Center(child:Container(
          width: 110,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.grey[400]!.withAlpha(120),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(word,overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.subtitle1!.apply(
              color: Colors.black,
              fontSizeDelta: 1
            ),),
          )
        ))),
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey),
            color: Colors.white
          ),
          child: 
          Center(child: Container(
            width: 12.5,
            height: 12.5,
            decoration: ticked[i] ? const BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle
            ) : const BoxDecoration(
              color: Colors.transparent
            )
          ),),
        )
          ],
        )
      )));
    }
    return ww;
  }
  
  String infotext = "";

  Future<void> getMaxFoulTime() async{

    //request no usage
    DateTime x0 = DateTime.now();
    http.Response res = await http.get(Uri.parse("http://127.0.0.1:"+widget.port+"/?test_id=2&method=0&input_data="+jsonEncode(["Ich bin sehr kreativ.", {}])));
    List data = jsonDecode(res.body);
    if(data[data.length-2][0] == "Die angegebenen Wörter konnten nicht in dem Satz gefunden werden."){

      x0.difference(DateTime.now());

    }else{
      print(res.body);
    }

  }
  int output = 0;
  bool sss = false;
  Future<bool> addS(String sentence) async{
    if(sss){
      return false;
    }
    sss = true;

    if(sentence.isEmpty){

      if(mounted){
        setState(() {
          errorcode = 7;
          errorText = "Kein Satz gefunden.";
        });
      }
      testHigh.testCerror = 7;
      sss = false;
      return false; 

    } 

    if(!sentence.endsWith(".")){

      if(mounted){
        setState(() {
          errorcode = 6;
          errorText = "Der Satz sollte mit '.' enden.";
        });
      }
      testHigh.testCerror = 6;
      sss = false;
      return false;
    }
    
    print(sentence);
    //do something

    //check words
    setState(() {
      errorcode = -1;
      errorText = "";
    });
    if(!c3()){

      setState(() {
        errorcode = 3;
        errorText = "Bitte wähle 3 Begriffe aus.";
      });
      sss = false;
      return false;
    }

    widget.widget.testTimeController.stop();
    if(mounted){
      setState(() {
      infotext = "Der Satz wird geladen. Dies kann mehrere Minuten dauern. Daher ist der Timer pausiert.";
    });
    }

    while(winners.isEmpty){   
      print("?");   
      await Future.delayed(const Duration(seconds: 1));
    }
    testHigh.testCerror = 2;
    http.Response res = await http.get(Uri.parse("http://127.0.0.1:"+widget.port+"/?test_id=2&method=0&input_data="+jsonEncode([sentence, winners])));
    testHigh.testCsentence = sentence;
    List entries = jsonDecode(res.body) as List;
    if (kDebugMode) {
      print(entries);
    }
    if(mounted){
      setState(() {
      infotext = "";
    });
    }
    if(entries[entries.length-2] is String &&entries[entries.length-2][0].length > 0){
      if(mounted){
        setState(() {
        errorcode = 5;
            errorText = "Die angegebenen Wörter wurden nicht verwendet.";
      });
      testHigh.testCerror = 5;
      }
    }else{
      if(entries[entries.length-2] != "" && (entries[entries.length - 1] is List && entries[entries.length - 1].length != 0 && (entries[entries.length -1][0] == 0))){
        if(mounted){
          setState(() {
          errorcode = 4;
            errorText = "Der Satz ist grammatikalisch falsch oder unlogisch.";
          });
        }
        testHigh.testCerror = 4;
    

      }else{

        testHigh.dynamicTestCout = entries;
        setState(() {
          infotext = "Satz wurde erfolgreich geladen";
        });
        testHigh.testCerror = 9;
      }
    }
    //check with machine
    widget.widget.testTimeController.forward();
    sss = false;

    return true;

  }
}

class TestD extends StatefulWidget {
  final Function(int) error;
  final Function con;
  final String port;
  const TestD(this.port, this.con, this.error, { Key? key }) : super(key: key);

  @override
  _TestDState createState() => _TestDState();
}

class _TestDState extends State<TestD> {

  var focusNode = FocusNode();
  late TextEditingController _controller;
  bool sv0 = false;
  bool sv1 = false;
  int errorcode = -1;
  String errorText = "";
  String infotext = "";

  int currentProblem = 0;

  final List<String> problemText = [
    "Du trifft dich mit deinem französischen Austauschschüler, doch dir ist ein Wort entfallen. Wie kannst du deinem Freund zeigen, um welches Wort es sich handelt?",
    "Welche Folgen hat es, wenn du dir in den Finger schneidest?",
    "Wie kannst du einen deiner Freunde von deiner Idee überzeugen?"
  ];

  List<List> solutions = [[], [], []];
  
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:[
        const SizedBox(
          height: 100,
        ),
        Text("Problemzauber", style: Theme.of(context).textTheme.headline2!.apply(
          color: Colors.black
        ),),
        const SizedBox(
          height: 10,
        ),
        Container(
          height: 100,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(10  )
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 100,
                width: 100,
                child: Center(
                  child: Icon(Icons.keyboard_arrow_right_outlined, size: 50,)
                ),
              ),
              SizedBox(
                height: 100,
                width: 1000,
                child: Center(child: Text("Löse die folgenden 3 Probleme, indem du einfache Lösungssätze eingibts. Die Lösungssätze sollten immer nur eine Antwortmöglichkeit enthalten. ", style: Theme.of(context).textTheme.subtitle1!.apply(
                  fontSizeDelta: 3
                ),)),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          height: 650,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey[400]!)
          ),
          child: SizedBox(
            height: 500,
            
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                        height: 50,
                      ),
                      //checkboxes
                
                SizedBox(
                  height: 100,
                  width: 1000,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[400]!.withAlpha(120),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.blue.shade600)
                    ),
                    child: Center(
                      child: SizedBox(
                        width: 900,
                        height: 97,
                        child: Center(child: RichText(text: TextSpan(
                          style: Theme.of(context).textTheme.subtitle1,
                          children: <TextSpan>[
                            TextSpan(text: "Problem "+(currentProblem + 1).toString()+": ",style: Theme.of(context).textTheme.subtitle1!.apply(
                              fontWeightDelta: 3
                            )),
                            TextSpan(text: problemText[currentProblem])
                          ]
                        ))
                      ))
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: 1000,
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                    
                      SizedBox(
                        width: 600,
                        height: 50,
                        
                        child: TextFormField(
                          focusNode: focusNode,
                          controller: _controller,
                          onFieldSubmitted: (t) async{
                            if(await addSolution(_controller.text)){
                              _controller.text = "";
                              focusNode.requestFocus();
                            }
                          },
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.black)
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.black)
                            ),
                            fillColor: Colors.black,
                            focusColor: Colors.black,
                            labelText: "Lösungsmöglichkeit",
                            labelStyle: const TextStyle(color: Colors.black),
                            
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async{
                          if(await addSolution(_controller.text)){
                            _controller.text = "";
                            focusNode.requestFocus();
                          }
                        },
                        child: MouseRegion(
                        onEnter: (p){                                                                                                                                                                                                                 
                          setState(() {
                            sv0 = true;
                          });
                        },
                        onExit: (p){
                          setState(() {
                            sv0 = false;
                          });
                        },
                        child: Container(
                        width: 150,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.blue.shade600, width: 2),
                          color: sv0 ? Colors.white: Colors.blue),
                        
                        child: Center(
                          child: Text("Bestätigen", style: Theme.of(context).textTheme.headline6!.apply(
                            color: sv0 ? Colors.blue : Colors.white,
                            fontSizeDelta: -2
                          ),),
                        ),
                      )
                      )
                      ),
                      GestureDetector(
                        onTap: () async{
                            startProblemSolving(currentProblem);
                            if(currentProblem < 2){
                              
                              setState(() {
                              errorText = "";
                              errorcode = -1;
                              currentProblem++;
                              });
                            }else{
                              //finish
                              widget.con.call();
                            }
                          
                        },
                        child: MouseRegion(
                        onEnter: (p){                                                                                                                                                                                                                 
                          setState(() {
                            sv1 = true;
                          });
                        },
                        onExit: (p){
                          setState(() {
                            sv1 = false;
                          });
                        },
                        child: Container(
                        width: 150,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.blue.shade600, width: 2),
                          color: !sv1 ? Colors.white: Colors.blue),
                        
                        child: Center(
                          child: Text(currentProblem < 2 ? "Nächstes Problem" : "Nächste Aufgabe", style: Theme.of(context).textTheme.headline6!.apply(
                            color: !sv1 ? Colors.blue : Colors.white,
                            fontSizeDelta: -4
                          ),),
                        ),
                      )
                      )
                      ),
                    ],
                  ),
                ),
                
                errorcode >= 0 ? SizedBox(
                  
                  height: 75,
                  child: Center(child: Container(
                  width: 570,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.red[500]
                ),
                child: Center(child: SizedBox(
                  width: 550,
                  child: Text(errorText,
                  
                 textAlign: TextAlign.left, style: Theme.of(context).textTheme.headline6!.apply(
                  color: Colors.white,
                  fontSizeDelta: -4,
                  fontWeightDelta: -1
                ))))),),
                ) : Container(),

              const SizedBox(height: 25),  
              SizedBox(
                height: 300,
                child: SingleChildScrollView(child: SizedBox(
                  child: Wrap(
                  
                  direction: Axis.vertical,
                  children: getAll(),
                ),
              )))
              /*infotext != "" ? SizedBox(
                  
                  height: 75,
                  child: Center(child: Container(
                  width: 570,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[400]!.withAlpha(120)
                ),
                child: Center(child: SizedBox(
                  width: 550,
                  child: Text(infotext,
                  
                 textAlign: TextAlign.center, style: Theme.of(context).textTheme.headline6!.apply(
                  color: Colors.white,
                  fontSizeDelta: -6,
                  fontWeightDelta: -1
                ))))),),
                ) : Container(),*/
              ]
            ),
          )
        )
      ],
    );
  
  }

  void startProblemSolving(int current) async{
    testHigh.currentTestD = solutions;
    http.Response res = await http.get(Uri.parse("http://127.0.0.1:"+widget.port+"/?test_id=3&method="+(current+1).toString()+"&input_data="+jsonEncode(testHigh.currentTestD[current])));
    print("e"); 
    List entries = jsonDecode(res.body);
    testHigh.dynamicTestDOut[current] = entries;
  }

  List<bool> hovering = [];
  List<Widget> getAll(){
    List<Widget> ww = [];
    for (var i = 0; i < solutions[currentProblem].length; i++) {
      ww.add(SizedBox(
        width: 1000,
        height: 60,
        child: Center(
          child: MouseRegion(
            onEnter: (p){
              setState(() {
                hovering[i] = true;
              });
            },
            onExit: (p){
              setState(() {
                hovering[i] = false;
              });
            },
            onHover: (p){
              setState(() {
                hovering[i] = true;
              });
            },
            child: GestureDetector(
              onTap: (){
                setState(() {
                  solutions[currentProblem].remove(solutions[currentProblem][i]);
                  hovering.removeAt(i);
                });
              },
              child: Container(
            width: 1000,
            height: 55,
            decoration: BoxDecoration(
              color: Colors.grey[400]!.withAlpha(80),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.blue),

            ),
            child: Stack(
              alignment: Alignment.centerRight,
              children: [
              
                hovering[i] ? SizedBox(
                  width: 55,
                  height: 55,
                  child: Center(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.cancel, color: Colors.blue,size: 25),
                    )
                  ),
                ): Container(),
              
              Center(
              child: SizedBox(
                width: 990,
                child: Text(" #"+(i+1).toString()+": "+solutions[currentProblem][i],overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.subtitle1),
              )
            )])
          )))
        ),
      ));
    }
    return ww;
  }

  Future<bool> addSolution(String solution) async{
    setState(() {
      errorcode = -1;
      errorText = "";
    });
    if(solution.isNotEmpty && solution.split(" ").length > 1 && solution.endsWith(".")){

      if(solutions[currentProblem].contains(solution)){

        setState(() {
          errorcode = 11;
          errorText = "Diese Lösung exisitiert bereits";
        });
        return false;

      }

      setState(() {
        solutions[currentProblem].add(solution);
        hovering.add(false);
      });
      return true;

    }else{
      setState(() {
        errorcode = 10;
        errorText = "Es wurde keine Satzstruktur gefunden";
      });
      return false;
    }

  } 
}

class TestE extends StatefulWidget {
  final Function(int) error;
  final Function con;
  final String port;
  _TestState widget;
  TestE(this.port, this.con, this.error, this.widget, { Key? key }) : super(key: key);

  @override
  _TestEState createState() => _TestEState();
}

class _TestEState extends State<TestE> {

  int errorcode = -1;
  String errorText = "";
  var focusNode = FocusNode();
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  final List<String> starter = [
    "Eine Sache, die du magst",
    "Eine Sache, die du hasst",
    "Ein Wort deiner Wahl"
  ];

  bool sv0 = false;
  bool example = true;
  int row = 0;
  bool finished = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:[
        const SizedBox(
          height: 100,
        ),
        Text("Schlangenlinie", style: Theme.of(context).textTheme.headline2!.apply(
          color: Colors.black
        ),),
        const SizedBox(
          height: 10,
        ),
        Container(
          height: 100,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(10  )
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 100,
                width: 100,
                child: Center(
                  child: Icon(Icons.keyboard_arrow_right_outlined, size: 50,)
                ),
              ),
              SizedBox(
                height: 100,
                width: 1000,
                child: Center(child: Text("Notiere das erste Wort, dass dir zu dem vorigen Wort einfällt. Am Ende wird eine Kette aus vielen zusammenhängenden Wörtern entstehen. Das erste Wort dieser Reihe bestimmst du. Zeit spielt hier eine Rolle, allerdings gibt es kein zeitliches Limit.", style: Theme.of(context).textTheme.subtitle1!.apply(
                  fontSizeDelta: 3
                ),)),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          height: 600,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey[400]!)
          ),
          child: SizedBox(
            height: 500,
            
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                        height: 50,
                      ),
                      //checkboxes
                
                SizedBox(
                  width: 900,
                  height: 100,
                  child: Row(
                    mainAxisAlignment:MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 300,
                        height: 95,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey[400]!),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey[400]!.withAlpha(50),
                              spreadRadius: 2.0,
                              blurRadius: 5.0
                            )
                          ]
                        ),
                        child: Center(
                          child: data[row].isEmpty ? Container() : Text(data[row][data[row].length-1], style: Theme.of(context).textTheme.subtitle1!.apply(
                            color: Colors.black, 
                            fontSizeDelta: 2
                          ),) 
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 100
                ),
                SizedBox(
                  width: 600,
                  height: 100,
                  child: Container(
                    decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey[400]!),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey[400]!.withAlpha(50),
                              spreadRadius: 2.0,
                              blurRadius: 5.0
                            )
                          ]
                        ),
                    child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                    
                      SizedBox(
                        width: 400,
                        height: 50,
                        
                        child: TextFormField(
                          focusNode: focusNode,
                          controller: _controller,
                          onFieldSubmitted: (t) async{
                            if(await addW(t)){
                              _controller.text = "";
                              focusNode.requestFocus();
                            }else{
                              focusNode.requestFocus();
                            }
                          },
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.black)
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.black)
                            ),
                            fillColor: Colors.black,
                            focusColor: Colors.black,
                            labelText: data[row].isEmpty ? starter[row] :"Assoziiertes Wort",
                            labelStyle: const TextStyle(color: Colors.black),
                            
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async{
                          if(await addW(_controller.value.text)){
                            _controller.text = "";
                            focusNode.requestFocus();
                          }else{
                            focusNode.requestFocus();
                          }
                        },
                        child: MouseRegion(
                        onEnter: (p){                                                                                                                                                                                                                 
                          setState(() {
                            sv0 = true;
                          });
                        },
                        onExit: (p){
                          setState(() {
                            sv0 = false;
                          });
                        },
                        child: Container(
                        width: 150,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: !finished ? Colors.blue.shade600 : Colors.grey[400]!, width: 2),
                          color: !finished ? (sv0 ? Colors.white: Colors.blue) : Colors.grey[400]!.withAlpha(120)),
                        
                        child: Center(
                          child: Text("Bestätigen", style: Theme.of(context).textTheme.headline6!.apply(
                            color: !finished ? (sv0 ? Colors.blue : Colors.white) : Colors.white,
                            fontSizeDelta: -2
                          ),),
                        ),
                      )
                      )
                      ),
                    ],
                  ),
                )),
                
                errorcode >= 0 ? SizedBox(
                  
                  height: 75,
                  child: Center(child: Container(
                  width: 570,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.red[500]
                ),
                child: Center(child: SizedBox(
                  width: 550,
                  child: Text(errorText,
                  
                 textAlign: TextAlign.left, style: Theme.of(context).textTheme.headline6!.apply(
                  color: Colors.white,
                  fontSizeDelta: -4,
                  fontWeightDelta: -1
                ))))),),
                ) : Container(),
                const SizedBox(height: 30),
                
             
              ]
            ),
          )
        )
      ],
    );
  }
  List<List<String>> data = [[], [], []];
  List<List<int>> time = [[], [], []];
  List<List<DateTime>> dateTimes = [[], [], []];
  Future<bool> addW(String word) async{
    //runValidation();
    if(data[row].length < 20){
      String t = _controller.value.text;
      if(!await checkWord(t)){
        setState(() {
          errorcode = 0;
          errorText = "Dieses Wort wurde nicht gefunden.";
        });
        return false;
      }else{  
        setState(() {
          errorcode = -1;
          errorText = "";
        });
        data[row].add(word);
        if(data[row].length == 1){
          time[row].add(0);
          dateTimes[row].add(DateTime.now());
          dateTimes[row].add(DateTime.now());
        }else{
          dateTimes[row].add(DateTime.now());
          time[row].add(dateTimes[row][dateTimes[row].length-2].difference(dateTimes[row][dateTimes[row].length-1]).inMilliseconds);
        }

        return true;
      }

    }
    return false;
  }

  int firstTime = 0;
  int lastTime = 0;
  int cx = 0;

  Future<bool> checkWord(String word) async{

    if(cx == 0){
      widget.widget.restartE(row == 1);
      cx = 1; Future.delayed(const Duration(minutes: 1)).then((value) async {
        if(widget.widget.testTimeController.value != 1.0){
          await Future.delayed(Duration(seconds: (60*(1.0-widget.widget.testTimeController.value)).toInt()));
        }
      cx = 0;
          print("ß");
          //finish
          setState(() {
            finished = true;
          });
          if(row < 2){
            print(".");
            widget.widget.restartE(row == 1);
          }
          firstTime = DateTime.now().millisecondsSinceEpoch;
          Future.delayed(Duration(seconds: 1)).then((value){
            if(row < 2){
            setState(() {
              row++;
              finished = false;
            });
            }else{

              runValidation();
              finished = true;
            }
          });
          Future.delayed(const Duration(minutes: 1)).then((value) async{
           if(widget.widget.testTimeController.value != 1.0){
          await Future.delayed(Duration(seconds: (60*(1.0-widget.widget.testTimeController.value)).toInt()));
        }
          //finish
          setState(() {
            finished = true;
          });
          if(row < 2){
            print(".");
            widget.widget.restartE(row == 1);
          }
          firstTime = DateTime.now().millisecondsSinceEpoch;
          Future.delayed(Duration(seconds: 1)).then((value){
            if(row < 2){
            setState(() {
              row++;
              finished = false;
            });
            }else{

              runValidation();
              finished = true;
            }
          });
          Future.delayed(const Duration(minutes: 1)).then((value) async{
               if(widget.widget.testTimeController.value != 1.0){
          await Future.delayed(Duration(seconds: (60*(1.0-widget.widget.testTimeController.value)).toInt()));
        }
          //finish
          setState(() {
            finished = true;
          });
          if(row < 2){
            print(".");
            widget.widget.restartE(row == 1);
          }
          firstTime = DateTime.now().millisecondsSinceEpoch;
          Future.delayed(Duration(seconds: 1)).then((value){
            if(row < 2){
            setState(() {
              row++;
              finished = false;
            });
            }else{
              runValidation();
              finished = true;
            }
          });
          });
          });
    });}

    Uri uri = Uri.parse('http://127.0.0.1:'+widget.port+'/?test_id=0&method=-1&input_data=["'+word+'"]');
    try{
      http.Response res = await http.get(uri);
      List<dynamic> ls = jsonDecode(res.body);
      bool b0 = ls[ls.length-1][0];
      if(firstTime == 0){
        firstTime = DateTime.now().millisecondsSinceEpoch;
      }
      return b0;
    }catch(e){
      if(e is SocketException){
        //the server is down, errorcode = 2
        widget.error.call(2);
      }else{
        widget.error.call(-1);
      }
      return false;
    }

  }

  void runValidation() async {

    if (kDebugMode) {
      print("run");
    }

    //http.Response res = await http.get(Uri.parse("http://127.0.0.1:"+widget.port+"/?test_id=4&method=0&input_data="+jsonEncode(allData)));

    /*
    /?test_id=4&method=0&input_data=%5B%5B%5B%22Tennis%22,2%5D,%5B%22Sand%22,2071%5D,%5B%22Wüste%22,2785%5D,%5B%22Osten%22,2296%5D,%5B%22Sonne%22,1384%5D,%5B%22Meer%22,2169%5D,%5B%22Strand%22,3180%5D,%5B%22Palme%22,1614%5D,%5B%22Blatt%22,3815%5D,%5B%22Papier%22,2493%5D,%5B%22Schule%22,15000%5D,%5B%22Mathe%22,2119%5D,%5B%22Rechnen%22,3167%5D,%5B%22Taschenrechner%22,6289%5D,%5B%22Computer%22,2864%5D,%5B%22Software%22,2668%5D,%5B%22Programm%22,2103%5D,%5B%22Arbeit%22,4444%5D,%5B%22Leben%22,6197%5D,%5B%22Religion%22,2690%5D%5D,%5B%5B%22Fisch%22,2%5D,%5B%22Meer%22,3792%5D,%5B%22Strand%22,1977%5D,%5B%22Sand%22,1608%5D,%5B%22Tennis%22,11682%5D,%5B%22Schuh%22,5203%5D,%5B%22Bruder%22,4426%5D,%5B%22Familie%22,4945%5D,%5B%22Haus%22,1554%5D,%5B%22Garten%22,5938%5D,%5B%22Baum%22,1205%5D,%5B%22Zuhause%22,5492%5D,%5B%22Wohnung%22,3676%5D,%5B%22Ort%22,4543%5D,%5B%22Zeit%22,4387%5D,%5B%22Geschichte%22,2479%5D,%5B%22Krieg%22,4927%5D,%5B%22Waffe%22,2955%5D,%5B%22USA%22,2048%5D,%5B%22Gefahr%22,3002%5D%5D,%5B%5B%22Bau%22,2%5D,%5B%22Bau%22,886%5D,%5B%22Bau%22,867%5D,%5B%22Bau%22,830%5D,%5B%22Bau%22,850%5D,%5B%22Bau%22,2836%5D,%5B%22Bau%22,552%5D,%5B%22Bau%22,256%5D,%5B%22Bau%22,205%5D,%5B%22Bau%22,337%5D,%5B%22Bau%22,268%5D,%5B%22Bau%22,806%5D%5D%5D
    */
    http.Response res = await http.get(Uri.parse("http://127.0.0.1:"+widget.port+"/?test_id=4&method=0"+"&input_data="+jsonEncode(data)));
    List entries = jsonDecode(res.body);  
    testHigh.dynamicTestEOut = entries;

    widget.widget.setState(() {
      widget.widget.nextTask();
    });
  }

}

//the last test omg its 4:12 am.
class TestF extends StatefulWidget {
  final Function(int) error;
  final Function con;
  final String port;
  const TestF(this.port, this.con, this.error, { Key? key }) : super(key: key);

  @override
  _TestFState createState() => _TestFState();
}

class _TestFState extends State<TestF> {

  var focusNode = FocusNode();
  late TextEditingController _controller;
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }
  bool sv0 = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:[
        const SizedBox(
          height: 100,
        ),
        Text("Reimspiel", style: Theme.of(context).textTheme.headline2!.apply(
          color: Colors.black
        ),),
        const SizedBox(
          height: 10,
        ),
        Container(
          height: 100,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(10  )
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 100,
                width: 100,
                child: Center(
                  child: Icon(Icons.keyboard_arrow_right_outlined, size: 50,)
                ),
              ),
              SizedBox(
                height: 100,
                width: 1000,
                child: Center(child: Text("Schreibe ein sich reimendes Gedicht. Versuche dich gut auszudrücken und besondere, strukturierte Reime zu verwenden. Auch hier gibt es kein zeitliches Limit.", style: Theme.of(context).textTheme.subtitle1!.apply(
                  fontSizeDelta: 3
                ),)),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          height: 600,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey[400]!)
          ),
          child: SizedBox(
            height: 500,
            
            child: Stack(
              alignment: Alignment.topRight,
              children: [SizedBox.expand(child: TextField(
                          focusNode: focusNode,
                          controller: _controller,
                          maxLines: 200,
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.black)
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.black)
                            ),
                            fillColor: Colors.black,
                            focusColor: Colors.black,
                            
                          ))),
                          SizedBox(
                            height: 80,
                            width: 200,
                            child: Center(
                              child: GestureDetector(
                                onTap: (){
                                  //finish
                                  finalValidate(_controller.value.text);
                                },
                                child: MouseRegion(
                        onEnter: (p){                                                                                                                                                                                                                 
                          setState(() {
                            sv0 = true;
                          });
                        },
                        onExit: (p){
                          setState(() {
                            sv0 = false;
                          });
                        },
                        child: Container(
                                  height: 50,
                                  width: 140,
                                  decoration: BoxDecoration(
                                    color: sv0 ? Colors.white : Colors.blue,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.blue.shade600, width: 2)
                                  ),
                                  child: Center(child: Text("Weiter", style: Theme.of(context).textTheme.headline6!.apply(
                                    color: sv0 ? Colors.blue : Colors.white
                                  ),))
                                )
                              ),
                            )
                          ))
            ])
          )
        )
      ],
    );
  }
  bool c0 = false;
  void finalValidate(String p) async{
    if(c0){
      return; 
    }
    c0 = true;
    http.Response res = await http.get(Uri.parse("http://127.0.0.1:"+widget.port+"/?test_id=5&method=0&input_data="+jsonEncode(p)));
    print(res.body);
    List entries = jsonDecode(res.body);
    testHigh.dynamicTestFout = entries;
    //run last time
    c0 = false;
    widget.con.call();

  }
}

class Results extends StatefulWidget {
  const Results({ Key? key }) : super(key: key);

  @override
  _ResultsState createState() => _ResultsState();
}

class _ResultsState extends State<Results> {

  late Timer t0;

  @override
  void initState() {
    t0 = Timer.periodic(const Duration(seconds: 5), (timer) {
      setState(() {
        
      });
    });
    print("?");
    super.initState();
  } 

  @override
  void dispose() {
    t0.cancel();
    super.dispose();
  }

  void check(){
    print(testHigh.dynamicTestCout);
    if(testHigh.dynamicTestAOut.isEmpty || testHigh.dynamicTestAOut[0] == 0){
      outputCorrect[0] = false;
    }
    if(testHigh.dynamicTestBout.length < 3 || testHigh.dynamicTestBout[3] == 0){
      outputCorrect[1] = false;
    }
    if(testHigh.dynamicTestCout.isEmpty){
      outputCorrect[2] = false;
    }
    if(testHigh.dynamicTestDOut[0].isEmpty && testHigh.dynamicTestDOut[1].isEmpty && testHigh.dynamicTestDOut[2].isEmpty){
      outputCorrect[3] = false;
    }
    if(testHigh.dynamicTestEOut.isEmpty){
      outputCorrect[4] = false;
    }
    if(testHigh.dynamicTestFout.isEmpty){
      outputCorrect[5] = false;
    }
    print(testHigh.dynamicTestFout);
  }

  List<bool> outputCorrect = List.filled(6, true);

  @override
  Widget build(BuildContext context) {
    String score = (testHigh.dynamicTestAOut[3][1]).toStringAsPrecision(4);
    print(testHigh.dynamicTestEOut);

    check();

    print("start");
    print(testHigh.dynamicTestDOut);
    List c_data = [];
    if(outputCorrect[2]){
      c_data = testHigh.dynamicTestCout[3];
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:[
        const SizedBox(
          height: 100,
        ),
        Text("Ergebnisse", style: Theme.of(context).textTheme.headline2!.apply(
          color: Colors.black
        ),),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 800,
          child: SingleChildScrollView(child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10
              ),
              const Divider(),
              SizedBox(
                height: 25,
                child: Text("Kreuzverhör",style: Theme.of(context).textTheme.subtitle1!.apply(
                  fontWeightDelta: 1,
                  fontSizeDelta: 2
                ),),
              ),const SizedBox(height: 20),
              outputCorrect[1] ? SizedBox(

                  child: Wrap(
                    runSpacing: 15.0,
                    direction: Axis.horizontal,
                    verticalDirection: VerticalDirection.down,
                    children: [
                      Table(
                        defaultVerticalAlignment: TableCellVerticalAlignment.top,
                        border: TableBorder.all(color: Colors.grey[400]!),
                        columnWidths: const <int, TableColumnWidth>{
          0: FixedColumnWidth(70),
          1: FixedColumnWidth(70),
          2: FixedColumnWidth(70),
          3: FixedColumnWidth(70),
          4: FixedColumnWidth(70),
          5: FixedColumnWidth(70),
          6: FixedColumnWidth(70),
          7: FixedColumnWidth(70),
          8: FixedColumnWidth(70),
          9: FixedColumnWidth(70),
          10: FixedColumnWidth(70),
        },
                        children: getRows(),
                      ),
                      const SizedBox(
                        width: 33,
                      ),
                      SizedBox(
                        height: 150,
                        width: 400,
                        child: Center(
                          child: Text("Die Tabelle zeigt die Unterschiede zwischen zwei Wörtern. Bei einem Unterschied von 0.0 handelt es sich um das gleiche Wort, während bei 1.0 die Wörter sehr verschieden sind. Umso geringer der Zusammenhang, umso höher ist die Kreativität.", textAlign: TextAlign.justify ,style: Theme.of(context).textTheme.subtitle1!.apply(
                            color: Colors.black,
                            fontSizeDelta: 1
                          ))
                        )
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      const VerticalDivider(),
                      SizedBox(
                        height: 150,
                        width: 300,
                        child: Center(child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(children: [
                            TextSpan(text: 'Der finale Wert liegt bei (0..unkreativ, 1..kreativ):\n\n', style: Theme.of(context).textTheme.subtitle1!.apply(
                              color: Colors.black, 
                              fontSizeDelta: 0
                            )),
                            TextSpan(text: score, style: Theme.of(context).textTheme.subtitle1!.apply(
                              color: double.parse(score) > 0.67 ? Colors.green[700] : (double.parse(score) > 0.34 ? Colors.yellow[600] : Colors.red[700]),
                              fontSizeDelta: 4
                            )),
                          ]))
                      )),
                      const VerticalDivider(),
                      const SizedBox(
                        width: 20,
                      ),

                      SizedBox(
                        height: 150,
                        width: 600,
                        child: Center(
                          child: RichText(
                            text: TextSpan(
                              style: Theme.of(context).textTheme.subtitle1!.apply(
                            color: Colors.black,
                            fontSizeDelta: 1
                          ),
                              children: [
                                const TextSpan(
                                  text: "Diese Form der Messung von Kreativiät ist neuartig und wurde in der Nationalen Akademie für Wissenschaft der Vereinigten Staaten veröffentlicht "
                                ),
                                TextSpan(
                                  text: "(mehr)",
                                  style: Theme.of(context).textTheme.subtitle1!.apply(
                            color: Colors.blue,
                          fontWeightDelta: 0,
                            fontSizeDelta: 1
                          ),
                                  recognizer: TapGestureRecognizer()..onTap = (){
                                    //open link
                                    launch('https://doi.org/10.1073/pnas.2022340118', enableJavaScript: true);
                                  }
                                ),
                                const TextSpan(
                                  text: ". ",
                                  
                                ),
                                const TextSpan(
                                  text: "Die Methode der Messung von Zusammenhängen ist hier allerdings einzigartig, nicht nur durch die Sprache, sondern auch durch Genauigkeit und verschiedene neue Verfahren. Um die Funktionsweise kennenzulernen ",
                                ),
                                TextSpan(
                                  text: "hier",
                                  style: Theme.of(context).textTheme.subtitle1!.apply(
                            color: Colors.blue,
                          fontWeightDelta: 0,
                            fontSizeDelta: 1
                          ),
                                  recognizer: TapGestureRecognizer()..onTap = (){
                                    //goto documentary
                                    print("?");
                                    launch('https://pitch-hisser-5d9.notion.site/Aufgabe-1-Kreuzverh-r-5fb633b618ae41b7914212860e3a3b11', enableJavaScript: true);
                                  }
                                ),
                                const TextSpan(
                                  text: " klicken.",
                                ),
                              ]
                            )
                            , textAlign: TextAlign.justify)
                        )
                      ),


                    ],
                  )
                ) : SizedBox(
                  height: 50,
                  child: Center(
                    child: Text("Keine Daten verfügbar.", style: Theme.of(context).textTheme.subtitle1!)
                  )
                ),
              const SizedBox(
                height: 20
              ),
              const Divider(),
              SizedBox(
                height: 25,
                child: Text("Buchstabenkette",style: Theme.of(context).textTheme.subtitle1!.apply(
                  fontWeightDelta: 1,
                  fontSizeDelta: 2
                ),),
              ),
              const SizedBox(height: 20),
              outputCorrect[1] ? SizedBox(
                height: 120,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 120,
                      width: 230,
                      child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [ 
                        Text((testHigh.dynamicTestBout[3][1] as Map).keys.toList()[0], style: Theme.of(context).textTheme.headline6),
                        const Divider(),
                        Text("Zusammenhänge: "+double.parse((testHigh.dynamicTestBout[3][1] as Map).values.toList()[0][1].toString()).toStringAsPrecision(4), style: Theme.of(context).textTheme.subtitle1),
                        const Divider(),
                        Text("Gesamtergebnis: "+double.parse((testHigh.dynamicTestBout[3][1] as Map).values.toList()[0][0].toString()).toStringAsPrecision(4), style: Theme.of(context).textTheme.subtitle1),
                      ],
                    )
                    ),
                    const SizedBox(
                      width: 50
                    ),
                    SizedBox(
                      height: 120,
                      width: 230,
                      child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [ 
                        Text((testHigh.dynamicTestBout[3][1] as Map).keys.toList()[1], style: Theme.of(context).textTheme.headline6),
                        const Divider(),
                        Text("Zusammenhänge: "+double.parse((testHigh.dynamicTestBout[3][1] as Map).values.toList()[1][1].toString()).toStringAsPrecision(4), style: Theme.of(context).textTheme.subtitle1),
                        const Divider(),
                        Text("Gesamtergebnis: "+double.parse((testHigh.dynamicTestBout[3][1] as Map).values.toList()[1][0].toString()).toStringAsPrecision(4), style: Theme.of(context).textTheme.subtitle1),
                      ],
                    )
                    ),const SizedBox(
                      width: 50
                    ),SizedBox(
                      height: 120,
                      width: 230,
                      child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [ 
                        Text((testHigh.dynamicTestBout[3][1] as Map).keys.toList()[2], style: Theme.of(context).textTheme.headline6),
                        const Divider(),
                        Text("Zusammenhänge: "+double.parse((testHigh.dynamicTestBout[3][1] as Map).values.toList()[2][1].toString()).toStringAsPrecision(4), style: Theme.of(context).textTheme.subtitle1),
                        const Divider(),
                        Text("Gesamtergebnis: "+double.parse((testHigh.dynamicTestBout[3][1] as Map).values.toList()[2][0].toString()).toStringAsPrecision(4), style: Theme.of(context).textTheme.subtitle1),
                      ],
                    )
                    )
                  ],
                )
              ) : SizedBox(
                  height: 50,
                  child: Center(
                    child: Text("Keine Daten verfügbar.", style: Theme.of(context).textTheme.subtitle1!)
                  )
                ),
              outputCorrect[1] ? SizedBox(
                child: Text("Diese Aufgabe soll den Wortschatztesten und die Fähigkeit Wörter zu verknüpfen. Die Zusammenhänge geben an, wie gut die Eingabe durschnittlich mit dem jeweiligen Wort zusammen passt. Das Gesamtergebnis wird neben den Zusammenhängen noch durch die Anzahl an Eingaben bestimmt. Diese wird mit der Anzahl an allen möglichen ähnlichen Wörtern vergliechen, sodass ein faires Ergebnis entsteht. Der finale Wert dieser Aufgabe beträgt: ",
                style: Theme.of(context).textTheme.subtitle1!.apply(
                  color: Colors.black,
                  fontSizeDelta: 1
                ),
                textAlign: TextAlign.left)
          ) : Container(),
          outputCorrect[1] ? SizedBox(
            height: 50,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Text((testHigh.dynamicTestBout[3][0] as double).toStringAsPrecision(4), style: Theme.of(context).textTheme.headline6!.apply(
              color: (testHigh.dynamicTestBout[3][0] as double) > 0.34 ? ((testHigh.dynamicTestBout[3][0] as double) > 0.67 ? Colors.green[700]: Colors.yellow[600] ) : Colors.red[700]
            ))])
          ) : Container(),
          const SizedBox(
                height: 20
              ),
              const Divider(),
              SizedBox(
                height: 25,
                child: Text("Satz-Kombination: "+testHigh.testCsentence, style: Theme.of(context).textTheme.subtitle1!.apply(
                  fontWeightDelta: 1,
                  fontSizeDelta: 2
                ),),
              ),
              const SizedBox(
                height: 20
              ),
              outputCorrect[2] ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children:[

                
              c_data[1][0] == 0 ? Text("- Der Satz ist womöglich nicht originell.", style: Theme.of(context).textTheme.subtitle1) : Text("+ Der Satz ist originell.",style: Theme.of(context).textTheme.subtitle1),
              c_data[1][2] != 0 ? Text("- Die Begriff befinden sich womöglich in einer Aufzählung.", style: Theme.of(context).textTheme.subtitle1) : Text("+ Die Begriffe sind nicht Teil einer Aufzählung.",style: Theme.of(context).textTheme.subtitle1) 
              ,const SizedBox(
                height: 20
              ),
              Text((c_data[0] as double).toStringAsPrecision(4), style: Theme.of(context).textTheme.headline6!.apply(
                color: (c_data[0] as double) < 0 ? Colors.red[700] : ((c_data[0] as double) > 0.5 ?  Colors.green[700]: Colors.yellow[600])
              ),),const SizedBox(
                height: 10
              ),
              RichText(text: 
              TextSpan(
                style: Theme.of(context).textTheme.subtitle1!.apply(
                  color: Colors.black,
                  fontSizeDelta: 1
                ),
                children:[
                  const TextSpan(
                    text: "Der Wert wurde mit drei verschiedenen Faktoren erstellt. Details zur Funktionsweise finden sie ",

                  ),
                  TextSpan(
                    text: "hier",
                    style: Theme.of(context).textTheme.subtitle1!.apply(
                            color: Colors.blue,
                          fontWeightDelta: 0,
                            fontSizeDelta: 1
                          ),
                                  recognizer: TapGestureRecognizer()..onTap = (){
                                    //goto documentary 3 
                                    launch('https://pitch-hisser-5d9.notion.site/Aufgabe-3-Satz-Kombination-59c3f981f04941618c47d4599463a813', enableJavaScript:true);  
                                  }
                  ),
                  const TextSpan(
                    text: "."
                  )
                ],
              )),const SizedBox(
                height: 10
              ),
              Text("Im Zusammenhang zur Schwierigkeit (bzw. zur Verschiedenheit der verwendeten Wörter) ergibt sich folgendes Ergebnis: ", style: Theme.of(context).textTheme.subtitle1!.apply(
                color: Colors.black, fontSizeDelta: 1)
              ),const SizedBox(
                height: 10
              ),Text(((c_data[0] as double) * double.parse(score)).toStringAsPrecision(4), style: Theme.of(context).textTheme.headline6!.apply(
                color: (c_data[0] as double) * double.parse(score) < 0.25 ? Colors.red[700] : ((c_data[0] as double) * double.parse(score) > 0.5 ?  Colors.green[700]: Colors.yellow[600])
              ),)
              ]) : SizedBox(
                  height: 50,
                  child: Center(
                    child: Text("Keine Daten verfügbar.", style: Theme.of(context).textTheme.subtitle1!)
                  ) 
                ),
                const SizedBox(
                height: 20
              ),
              const Divider(),
              SizedBox(
                height: 25,
                child: Text("Problemzauber: ", style: Theme.of(context).textTheme.subtitle1!.apply(
                  fontWeightDelta: 1,
                  fontSizeDelta: 2
                ),),
              ),
              const SizedBox(
                height: 20
              ),
              outputCorrect[3] ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.grey[300]
                        ),
                        width: 300,
                        height: 25,
                        child: Center(
                          child: Text("Richtige Lösungen Problem 1: " + testHigh.dynamicTestDOut[0][3][0].toString(), style: Theme.of(context).textTheme.subtitle1!.apply(
                            color: Colors.black,
                            fontSizeDelta: 1
                          ))
                        )
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.grey[300]
                        ),
                        width: 300,
                        height: 25,
                        child: Center(
                          child: Text("Richtige Lösungen Problem 2: " + testHigh.dynamicTestDOut[1][3][0].toString(), style: Theme.of(context).textTheme.subtitle1!.apply(
                            color: Colors.black,
                            fontSizeDelta: 1
                          ))
                        )
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.grey[300]
                        ),
                        width: 300,
                        height: 25,
                        child: Center(
                          child: Text("Richtige Lösungen Problem 3: " + testHigh.dynamicTestDOut[2][3][0].toString(), style: Theme.of(context).textTheme.subtitle1!.apply(
                            color: Colors.black,
                            fontSizeDelta: 1
                          ))
                        )
                      )
                    ],
                  )
                ],

              ) : SizedBox(
                  height: 50,
                  child: Center(
                    child: Text("Keine Daten verfügbar.", style: Theme.of(context).textTheme.subtitle1!)
                  )
                ),
                const SizedBox(
                height: 20
              ),
              const SizedBox(
                height: 20
              ),
              const Divider(),
              SizedBox(
                height: 25,
                child: Text("Schlangenlinie: ", style: Theme.of(context).textTheme.subtitle1!.apply(
                  fontWeightDelta: 1,
                  fontSizeDelta: 2
                ),),
              ),
              const SizedBox(
                height: 20
              ),
              outputCorrect[4] ? SizedBox(
                height: 50,
                child: Row(
                  children: [
                    Text((testHigh.dynamicTestEOut[3][0] as double).toStringAsPrecision(4), style: Theme.of(context).textTheme.headline6!.apply(
                      color: testHigh.dynamicTestEOut[3][0] < 0 ? Colors.red[700] : (testHigh.dynamicTestEOut[3][0] > 0.5 ? Colors.green[700]:Colors.yellow[600])
                    ),),
                    const SizedBox(width: 30,),
                    SizedBox(
                      width: 400,
                      child: Text("Anhand von Anzahl und Zusammenhang zwischen den Eingaben wird der Score bewertet. Der Score ist ein Durchschnitt aus allen 3 Wort-Ketten.", style: Theme.of(context).textTheme.subtitle1!.apply(
                      fontSizeDelta: 1
                    ), maxLines: 2,))
                  ],
                )
              ):SizedBox(
                  height: 50,
                  child: Center(
                    child: Text("Keine Daten verfügbar.", style: Theme.of(context).textTheme.subtitle1!)
                  )
                ),
                const SizedBox(
                height: 20
              ),
              const Divider(),
              SizedBox(
                height: 25,
                child: Text("Reimspiel: ", style: Theme.of(context).textTheme.subtitle1!.apply(
                  fontWeightDelta: 1,
                  fontSizeDelta: 2
                ),),
              ),
              const SizedBox(
                height: 20
              ),
              outputCorrect[5] ? SizedBox(
                height: 50,
                child: Row(
                  children: [
                    Text((testHigh.dynamicTestFout[3][0] as double).toStringAsPrecision(4), style: Theme.of(context).textTheme.headline6!.apply(
                      color: testHigh.dynamicTestFout[3][0] < 0 ? Colors.red[700] : (testHigh.dynamicTestFout[3][0] > 0.5 ? Colors.green[700]:Colors.yellow[600])
                    ),),
                    const SizedBox(width: 30,),
                    SizedBox(
                      width: 400,
                      child: Text("Anhand von Länge, Reimanzahl, Besonderheit der Reime und Besnoderheit der Wörter wird das Gedicht bewertet.", style: Theme.of(context).textTheme.subtitle1!.apply(
                      fontSizeDelta: 1
                    ), maxLines: 2,))
                  ],
                )
              ):SizedBox(
                  height: 50,
                  child: Center(
                    child: Text("Keine Daten verfügbar.", style: Theme.of(context).textTheme.subtitle1!)
                  )
                ),
            ],
          )),

        )
      ]
    );
  }



  List<TableRow> getRows(){
    print(testHigh.dynamicTestAOut);
    List<TableRow> rows = [];
    //get matrix from testA
    Map matrix = testHigh.dynamicTestAOut[3][0];
    
    
    for (var i = -1; i < matrix.keys.length; i++) {
      if(i == -1){
 List<Widget> childs = [];
        for (var j = -1; j < matrix[0.toString()].length; j++) {
          if(j == -1){
            childs.add(const SizedBox(height: 30, width: 50));
          }else{

          childs.add(SizedBox(height: 30, width: 68, child:  Center(child: Text(testHigh.testAWords[j],overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.subtitle1!.apply(color: Colors.black)))));
        }}
        // childs.add(SizedBox(height: 10,width: 10));
        rows.add(TableRow(children: childs));
        continue;
      }
      List<Widget> childs = [];
      print(matrix[i.toString()].length);
      for (var j = -1; j < matrix[i.toString()].length; j++) {
        if(j == -1){
            childs.add(SizedBox(height: 30, width: 50, child: Center(child: Text(testHigh.testAWords[i],overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.subtitle1!.apply(color: Colors.black)))));
        }else{
          var value = normTestAValue(matrix[i.toString()][j], false);
        childs.add(SizedBox(
          height: 30,
          width: 68,
          child: Container(
            
            decoration: value.toString() == "" ? BoxDecoration(color: Colors.grey[400]!.withAlpha(120)) : BoxDecoration(color: double.parse(value) > 0.67 ? Colors.green.withAlpha(120): (double.parse(value) > 0.34 ? Colors.yellow.withAlpha(120) : Colors.red.withAlpha(120))),
            child: Center(child: Text(value.toString(), style: Theme.of(context).textTheme.subtitle1!.apply(color: Colors.black)))
        )));
        }
      }
      // childs.add(SizedBox(height: 10,width: 10));
      rows.add(TableRow(
        children: childs
      ));
    }

    return rows;

  }

  dynamic normTestAValue(dynamic d, bool safe){

    double d0 = double.parse(d.toString());
    if(!safe){
      if(d0 == 0.0){
        return "";
      }else{
        return d0.toStringAsFixed(2);
      }
    }
  }

}