import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:creative_test/main.dart';
import 'package:creative_test/mechanics.dart';
import 'package:creative_test/monitor.dart';
import 'package:creative_test/results.dart';
import 'package:creative_test/test_a.dart';
import 'package:creative_test/test_b.dart';
import 'package:creative_test/test_c.dart';
import 'package:creative_test/test_d.dart';
import 'package:creative_test/test_e.dart';
import 'package:creative_test/test_f.dart';
import 'package:creative_test/time_over.dart';
import 'package:creative_test/useful_widgets.dart';
import 'package:creative_test_dart/creative_test_dart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:window_manager/window_manager.dart';
import 'package:germanet_dart/germanet_dart.dart';

import 'intro.dart';
import 'load.dart';

TestHigh testHigh = TestHigh();

class TestWidget extends StatefulWidget {
  const TestWidget({Key? key}) : super(key: key);

  @override
  TestState createState() => TestState();
}

abstract class SimpleListener {
  void onLoadingFinished(int code);
}

Route _backCreateRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => const CreativityTest(),
    transitionDuration: const Duration(milliseconds: 100),
    reverseTransitionDuration: const Duration(milliseconds: 0),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const end = Offset.zero;
      const begin = Offset(-1.0, 0.0);
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

class TestState extends State<TestWidget>
    with WindowListener, TickerProviderStateMixin, SimpleListener {
  late Animation<double> scala01;
  late AnimationController scalaController;
  late Animation<double> fade;
  late AnimationController fadeController;
  late MaterialColor baseColor;

  late AnimationController testTimeController;

  String name = "";
  int birthday = 0;
  String deg = "";

  List<Color> dotColors = [];
  List<Color> dotColors0 = [];
  List<Color> dotColors2 = [];

  int buttonPos = 0;
  bool buttonAllowed = false;
  bool code = false;
  bool left = false;
  bool timeOver = false;
  int current = 0;
  bool testTimeView = false;
  int testRunningA = 0;
  bool loaded = false;
  bool checkTestAWords = false;
  bool showNext = false;
  int testRunningB = 0;
  int testRunningC = 0;
  int testRunningD = 0;
  int testRunningE = 0;
  int testRunningF = 0;

  bool loaded2 = true;
  bool sw = false;
  bool z = false;
  String codeText = "Code Console --- Code Console\n";

  bool checkMeaningInProcess = false;

  Test? creativeTest;
  List<MonitorWidget> monitors = [];

  @override
  void onLoadingFinished(int code) {
    if (code == 0) {
      setState(() {
        loaded = true;
        loaded2 = false;
      });
    } else {
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

    scalaController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    scalaController.addListener(() {
      setState(() {});
    });
    scala01 = Tween(begin: 0.0, end: 1.0).animate(scalaController);

    fadeController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    fade = Tween(begin: 0.0, end: 1.0).animate(fadeController);

    testTimeController = AnimationController(
      vsync: this,
      duration: const Duration(minutes: 4),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed && testRunningB == 0) {
          //close methods
          setState(() {
            timeOver = true;
          });
        }
      });

    windowManager.addListener(this);
  }

  @override
  void onWindowLeaveFullScreen() async {
    super.onWindowLeaveFullScreen();
    left = true;
    await showDialog(
        context: context,
        builder: (c) {
          return Container(
            width: 400,
            height: 300,
            decoration:
                const BoxDecoration(color: Color.fromARGB(250, 245, 245, 245)),
            child: Center(
              child: Text(
              
                "Bitte aktiviere den Vollbild-Modus.",
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headline2!
                    .apply(color: Colors.grey[350]),
              ),
            ),
          );
        });
  }

  @override
  void onWindowEnterFullScreen() {
    if (code) {
      print0("enter");
    }
    if (left) {
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    scalaController.dispose();
    fadeController.dispose();
    testTimeController.dispose();
    windowManager.removeListener(this);
    finishTest();
    super.dispose();
  }

  void nextTask() async {
    current++;
    if (current < dotColors2.length) {
      if (!loaded2) {
        loaded = true;
      }
      dotColors[current] = baseColor[100 * current + 100]!;
      await scalaController.forward(from: 0.0);
      dotColors2[current] = baseColor[100 * current + 100]!;
    }
  }

  void finishTest() async {
    //IMPL
    testHigh = TestHigh();
    creativeTest!.clearVariables();
  }

  void error(var code) async {
    print(code);
    //on error page
    if (this.code) {
      print0("err: $code");
    }
    //error dialog

    var errorInfo = jsonDecode(await rootBundle.loadString("assets/errors.json"));

    await showDialog<String>(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text(errorInfo[code.toString()]['title']),
          content: Text(errorInfo[code.toString()]['des']),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                if(code == 9){
                //delete test 
                //restart
                //finishTest();
                  Navigator.of(context).pop('Ok');
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.push(context, _backCreateRoute());
                }
              },
              child: const Text('Ok'),
            ),
          ],
        ),
      );
      
  }

  void placeButton() {
    fadeController.forward().then((value) {
      setState(() {
        buttonAllowed = true;
      });
    });
  }

  void displaceButton() {
    setState(() {
      buttonAllowed = false;
    });
    fadeController.reverse();
  }

  //test list programming - order and states
  void testBase() {
    //add time view
    setState(() {
      testTimeView = true;
    });
  }

  void testA() {
    if (testRunningA == 0) {
      testRunningA = 1;
      testTimeView = true;
      testTimeController.forward();
    }
  }

  void testB() {
    if (testRunningB == 0) {
      timeOver = false;
      testRunningB = 1;
      testTimeView = true;
      // showNext = false;
      testTimeController.stop();
      testTimeController = AnimationController(
          vsync: this, duration: const Duration(minutes: 10))
        ..addStatusListener((status) {
          if (status == AnimationStatus.completed && testRunningC == 0) {
            //close methods
            setState(() {
              timeOver = true;
            });
          }
        });
      testTimeController.forward();
    }
  }

  void testC() {
    if (testRunningC == 0) {
      testRunningC = 1;
      testTimeController.stop();
      testTimeController =
          AnimationController(vsync: this, duration: const Duration(minutes: 4))
            ..addStatusListener((status) {
              if (status == AnimationStatus.completed && testRunningD == 0) {
                //close methods
                setState(() {
                  timeOver = true;
                });
              }
            });
      ;
      testTimeController.forward();
    }
  }

  Future<void> validateTestB() async {
    MonitorWidget monitorWidget =
        MonitorWidget(key: GlobalKey(), title: "Auswertung Buchstabenkette");
    addMonitor(monitorWidget);
    await creativeTest!.validateTestB(monitorWidget, testHigh.testBMapList);
    finishMonitorWidget(monitorWidget);
  }

  void secureB() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        if (testHigh.testBMapList.keys.isEmpty) {
          if (current == 2) {
            checkTestAWords = true;
            timeOver = false;

            nextTask();
          }
        } else {
          //validate test b
          validateTestB();

          timeOver = false;

          if (current == 2) {
            nextTask();
          }
        }
      });
    });
  }

  void testD() {
    if (testRunningD == 0) {
      timeOver = false;
      testRunningD = 1;
      testTimeController.stop();
      testTimeController = AnimationController(
          vsync: this, duration: const Duration(minutes: 20))
        ..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            if (code) {
              print0(status.name);
            }
            //close methods
            setState(() {
              timeOver = true;
            });
          }
        });
      testTimeController.forward();
    }
  }

  void testE() {
    if (code) {
      print0(testTimeController.value);
    }
    if (testRunningE == 0) {
      if (code) {
        print0("testE");
      }
      timeOver = false;
      testTimeController.stop();
      testRunningE = 1;
      z = false;
      // testTimeView = true;
    }
  }

  void restartE(bool b) {
    setState(() {
      testTimeController.stop();
      testTimeController =
          AnimationController(vsync: this, duration: const Duration(minutes: 1))
            ..addStatusListener((status) {
              if (status == AnimationStatus.completed) {
                if (b) {
                  setState(() {
                    timeOver = true;
                  });
                }
              }
            });
      testTimeController.forward(from: 0.0);
    });
  }

  void testF() {
    if (testRunningF == 0) {
      z = true;
      timeOver = false;
      testRunningD = 1;
      testTimeView = false;
    }
  }

  ///init Test from creative_test_dart
  Future<void> initTest() async {
    creativeTest = Test(name, birthday, deg);
    var mw = MonitorWidget(key: GlobalKey(), title: "Initialisierung");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        monitors.add(mw);
      });
    });
    //do not use PseudoFiles. the virtual data useage is too big.
    //check if the data dir contains the x data
    Directory dataDir = await getApplicationDocumentsDirectory();
    if (!dataDir.listSync().any((element) => element.path.endsWith("gxx"))) {
      //create x data in dataDir
      Directory gxx = Directory(dataDir.path + "/gxx");
      gxx.createSync();
      final p0 = (dataDir).path;
      for (PseudoFile element in (await generatePseudoFiles())) {
        var nF = File(p0 +
            "/gxx/" +
            element.path.substring(element.path.lastIndexOf("/") + 1));
        nF.createSync();
        nF.writeAsStringSync(await element.readAsString());
      }
    }
    TestResult tr =
        await creativeTest!.initializingTest(mw, dataDir.path + "/gxx/");
    if (tr.errorsExist) {
      error(-100);
      print(tr.specificError);
    }
    finishMonitorWidget(monitors.last);
  }

  void addMonitor(MonitorWidget monitorWidget) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        monitors.add(monitorWidget);
      });
    });
  }

  void finishMonitorWidget(MonitorWidget w) async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      w.prepareToKill();
      await Future.delayed(const Duration(milliseconds: 500));
      monitors.removeWhere((element) => element.title == w.title);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget testWidget = Container();
    if (current == 0) {
      testWidget = Intro(this);
    }
    if (current == 1) {
      if (!loaded) {
        testWidget = Load(loaded2, this, key: const Key(""), listener: this);
      } else {
        testA();
        if (checkTestAWords) {
          testWidget = TestACheck(this, () {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (current == 1) {
                setState(() {
                  checkTestAWords = false;
                  testTimeController.value = 0;
                  nextTask();
                  timeOver = false;
                });
              }
            });
            //next level
          }, error);
        } else {
          if (timeOver) {
            testWidget = TimeOver(() async {
              await checkMeaning();
            });
          } else {
            testWidget = TestA(
              state: this,
              onError: error,
            );
          }
        }
      }
    }
    if (current == 2) {
      testB();
      if (timeOver) {
        testWidget = TimeOver(() {
          secureB();
        });
      } else {
        testWidget = TestB(this, () {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            //validate test b

            validateTestB();

            if (current == 2) {
              nextTask();
            }
          });
        }, error);
      }
    }
    if (current == 3) {
      testC();
      if (timeOver) {
        testWidget = TimeOver(() {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              timeOver = false;
              nextTask();
            });
          });
        });
      } else {
        testWidget = TestC(this, () {}, error);
      }
    }
    if (current == 4) {
      testD();
      if (timeOver) {
        testWidget = TimeOver(() {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              timeOver = false;
              nextTask();
            });
          });
        });
      } else {
        testWidget = TestD(this, () {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              timeOver = false;
              nextTask();
            });
          });
        }, error);
      }
    }
    if (current == 5) {
      testE();
      testWidget = TestE(() {}, error, this);
    }
    if (current == 6) {
      testF();
      testWidget = TestF(this, () {
        setState(() {
          nextTask(); //finaleeeee
        });
      }, error);
    }
    if (current >= 7) {
      z = false;
      testWidget = Results(this, creativeTest!.getResultsAsList());
    }

    log("rebuild");

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
                  border: Border.symmetric(
                      vertical:
                          BorderSide(color: Colors.grey[200]!, width: 1))),
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
                              child: Image.asset(
                                "assets/logo_full_loaded.png",
                                width: 150,
                                height: 150,
                              )),
                          Text(
                            "KreativTest",
                            style: Theme.of(context)
                                .textTheme
                                .headline5!
                                .apply(color: Colors.grey[900]!),
                          )
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
                              colors: [Colors.grey[100]!, baseColor[100]!],
                            )),
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
                              stops: dotColors[1] == Colors.grey[100]!
                                  ? [0.0, 0.0, 0.0]
                                  : dotColors2[1] == baseColor[200]
                                      ? [0.0, 1.0, 0.0]
                                      : [0.0, scala01.value, 0.0],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                dotColors0[1],
                                dotColors[1],
                                dotColors0[1]
                              ],
                            )),
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
                              stops: dotColors[2] == Colors.grey[100]!
                                  ? [0.0, 0.0, 0.0]
                                  : dotColors2[2] == baseColor[300]
                                      ? [0.0, 1.0, 0.0]
                                      : [0.0, scala01.value, 0.0],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                dotColors0[2],
                                dotColors[2],
                                dotColors0[2],
                              ],
                            )),
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
                              stops: dotColors[3] == Colors.grey[100]!
                                  ? [0.0, 0.0, 0.0]
                                  : dotColors2[3] == baseColor[400]
                                      ? [0.0, 1.0, 0.0]
                                      : [0.0, scala01.value, 0.0],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                dotColors0[3],
                                dotColors[3],
                                dotColors0[3],
                              ],
                            )),
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
                              stops: dotColors[4] == Colors.grey[100]!
                                  ? [0.0, 0.0, 0.0]
                                  : dotColors2[4] == baseColor[500]
                                      ? [0.0, 1.0, 0.0]
                                      : [0.0, scala01.value, 0.0],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                dotColors0[4],
                                dotColors[4],
                                dotColors0[4]
                              ],
                            )),
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
                              stops: dotColors[5] == Colors.grey[100]!
                                  ? [0.0, 0.0, 0.0]
                                  : dotColors2[5] == baseColor[600]
                                      ? [0.0, 1.0, 0.0]
                                      : [0.0, scala01.value, 0.0],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                dotColors0[5],
                                dotColors[5],
                                dotColors0[5]
                              ],
                            )),
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
                              stops: dotColors[6] == Colors.grey[100]!
                                  ? [0.0, 0.0, 0.0]
                                  : dotColors2[6] == baseColor[700]
                                      ? [0.0, 1.0, 0.0]
                                      : [0.0, scala01.value, 0.0],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                dotColors0[6],
                                dotColors[6],
                                dotColors0[6]
                              ],
                            )),
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
                              stops: dotColors[7] == Colors.grey[100]!
                                  ? [0.0, 0.0, 0.0]
                                  : dotColors2[7] == baseColor[800]
                                      ? [0.0, 1.0, 0.0]
                                      : [0.0, scala01.value, 0.0],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                dotColors0[7],
                                dotColors[7],
                                dotColors0[7]
                              ],
                            )),
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
                                    border:
                                        Border.all(color: Colors.grey[900]!)),
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
                                    border:
                                        Border.all(color: Colors.grey[900]!)),
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
                                    border:
                                        Border.all(color: Colors.grey[900]!)),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
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
                                    border:
                                        Border.all(color: Colors.grey[900]!)),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
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
                                    border:
                                        Border.all(color: Colors.grey[900]!)),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
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
                                    border:
                                        Border.all(color: Colors.grey[900]!)),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
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
                                    border:
                                        Border.all(color: Colors.grey[900]!)),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
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
                                    border:
                                        Border.all(color: Colors.grey[900]!)),
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
                              width: 200,
                              child: Text(
                                "   Einführung",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .apply(
                                        color: Colors.grey[900]!,
                                        fontSizeDelta: -1),
                                textAlign: TextAlign.start,
                              ),
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
                              child: Text(
                                "   Kreuzverhör",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .apply(
                                        color: Colors.grey[900]!,
                                        fontSizeDelta: -1),
                                textAlign: TextAlign.start,
                              ),
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
                                width: 200,
                                child: Text("   Buchstabenkette",
                                    textAlign: TextAlign.start,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6!
                                        .apply(
                                            color: Colors.grey[900]!,
                                            fontSizeDelta: -1)),
                              ),
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
                              width: 200,
                              child: Text(
                                "   Satz-Kombination",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .apply(
                                        color: Colors.grey[900]!,
                                        fontSizeDelta: -1),
                                textAlign: TextAlign.start,
                              ),
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
                                  width: 200,
                                  child: Text(
                                    "   Problemzauber",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6!
                                        .apply(
                                            color: Colors.grey[900]!,
                                            fontSizeDelta: -1),
                                    textAlign: TextAlign.start,
                                  ),
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
                              width: 200,
                              child: Text(
                                "   Schlangenlinie",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .apply(
                                        color: Colors.grey[900]!,
                                        fontSizeDelta: -1),
                                textAlign: TextAlign.start,
                              ),
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
                                  width: 200,
                                  child: Text(
                                    "   Reimspiel",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6!
                                        .apply(
                                            color: Colors.grey[900]!,
                                            fontSizeDelta: -1),
                                    textAlign: TextAlign.start,
                                  ),
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
                              width: 200,
                              child: Text(
                                "   Ergebnisse",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .apply(
                                        color: Colors.grey[900]!,
                                        fontSizeDelta: -1),
                                textAlign: TextAlign.start,
                              ),
                            )),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            bottom: 25.0,
            child: GestureDetector(
                onTap: () {
                  //goback to start
                  if ((testRunningA != 0 ||
                      testRunningB != 0 ||
                      testRunningC != 0 ||
                      testRunningD != 0 ||
                      testRunningE != 0)) {
                    showCupertinoDialog(
                        context: context,
                        builder: (c) {
                          return /*Container(
                      height: MediaQuery.of(c).size.height,
                      width: MediaQuery.of(c).size.width,
                      color: Colors.grey.withAlpha(50),
                      child: Center(child:
                      */
                              Center(
                                  child: Container(
                                      width: 500,
                                      height: 300,
                                      color: Colors.white,
                                      child: Stack(
                                        children: [
                                          Positioned(
                                              right: 10.0,
                                              top: 10.0,
                                              child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.pop(c);
                                                  },
                                                  child: const Icon(Icons.clear,
                                                      color: Colors.black))),
                                          Positioned(
                                            left: 15.0,
                                            top: 10.0,
                                            child: SizedBox(
                                                width: 350,
                                                child: Text(
                                                    "Willst du den Test wirklich abbrechen?",
                                                    style: Theme.of(c)
                                                        .textTheme
                                                        .headline3!
                                                        .apply(
                                                            fontWeightDelta:
                                                                -1))),
                                          ),
                                          Positioned(
                                              left: 15.0,
                                              bottom: 10.0,
                                              child: GestureDetector(
                                                  onTap: () {
                                                    //finishTest();
                                                    Navigator.pop(context);
                                                    Navigator.pop(context);
                                                    Navigator.pop(context);
                                                    Navigator.push(context, _backCreateRoute());
                                                    //exx
                                                  },
                                                  child: Container(
                                                      width: 180,
                                                      height: 50,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color: Colors.blue
                                                                  .shade600,
                                                              width: 3.0)),
                                                      child: Center(
                                                          child: Container(
                                                              width: 170,
                                                              height: 40,
                                                              color: Colors.blue
                                                                  .shade600,
                                                              child: Center(
                                                                  child: Text(
                                                                      "Ja, ich will.",
                                                                      style: Theme.of(
                                                                              c)
                                                                          .textTheme
                                                                          .headline6!
                                                                          .apply(
                                                                              color: Colors.white)))))))),
                                          Positioned(
                                              right: 15.0,
                                              bottom: 10.0,
                                              child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.pop(c);
                                                  },
                                                  child: Container(
                                                      width: 250,
                                                      height: 50,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color: Colors.grey
                                                                  .shade700,
                                                              width: 3.0)),
                                                      child: Center(
                                                          child: Container(
                                                              width: 240,
                                                              height: 40,
                                                              color: Colors.grey
                                                                  .shade700,
                                                              child: Center(
                                                                  child: Text(
                                                                      "Nein, ich mache weiter.",
                                                                      style: Theme.of(
                                                                              c)
                                                                          .textTheme
                                                                          .headline6!
                                                                          .apply(
                                                                              color: Colors.white)))))))),
                                        ],
                                      )));
                        });
                  } else {
                    //finishTest();
                    Navigator.of(context).push(_backCreateRoute());
                  }
                },
                child: SizedBox(
                    width: 250,
                    height: 50,
                    child: Center(
                        child: Text(
                            (testRunningA != 0 ||
                                    testRunningB != 0 ||
                                    testRunningC != 0 ||
                                    testRunningD != 0 ||
                                    testRunningE != 0)
                                ? "Abbrechen"
                                : "Zurück",
                            style: Theme.of(context)
                                .textTheme
                                .headline6!
                                .apply(color: Colors.grey.withAlpha(200)))))),
          ),
          current == 0
              ? Positioned(
                  left: 250,
                  right: 0,
                  top: 0,
                  bottom: MediaQuery.of(context).size.height - 300,
                  child: RotatedBox(
                    quarterTurns: 2,
                    child: Image.asset("assets/intro.jpg", fit: BoxFit.cover),
                  ),
                )
              : Container(),
          current == 0
              ? Positioned(
                  left: 250,
                  right: 0,
                  top: 120,
                  bottom: MediaQuery.of(context).size.height - 300,
                  child: Container(
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(0, 250, 250, 250),
                              Color.fromARGB(250, 250, 250, 250)
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: [0.1, 1.0])),
                  ))
              : Container(),
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
          loaded && testTimeView
              ? Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: SizedBox(
                      height: 7,
                      child: AnimatedBuilder(
                        animation: testTimeController,
                        builder: (x, h) => LinearProgressIndicator(
                          backgroundColor: Colors.transparent,
                          color: Colors.blue,
                          value: testTimeController.value,
                        ),
                      )),
                )
              : Container(),
          loaded && (testTimeView || z)
              ? Positioned(
                  right: 0,
                  bottom: 10,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            if (sw) {
                              return;
                            }
                            sw = true;
                            if (current == 1) {
                              //check words for meaning
                              if (checkTestAWords) {
                                nextTask();
                                sw = false;
                                TestACheckState.finishCorrection(() {}, this);
                              } else {
                                await checkMeaning();
                                sw = false;
                              }
                              return;
                            }
                            if (current == 2) {
                              await Future.delayed(
                                  const Duration(milliseconds: 1234));
                              secureB();
                              sw = false;
                              return;
                            }
                            if (current == 3) {
                              await Future.delayed(
                                  const Duration(milliseconds: 1234));
                              setState(() {
                                nextTask();
                              });
                              sw = false;
                              return;
                            }
                            if (current == 4) {
                              await Future.delayed(
                                  const Duration(milliseconds: 1234));
                              setState(() {
                                nextTask();
                              });
                              sw = false;
                              return;
                            }
                            if (current == 5) {
                              await Future.delayed(
                                  const Duration(milliseconds: 1234));
                              setState(() {
                                nextTask();
                              });
                              sw = false;
                              return;
                            }
                            if (current == 6) {
                              await Future.delayed(
                                  const Duration(milliseconds: 1234));
                              setState(() {
                                nextTask();
                              });
                              sw = false;
                              return;
                            }
                          },
                          child: MouseRegion(
                              onHover: (p) => setState(() {
                                    if (!z) {
                                      showNext = true;
                                    }
                                  }),
                              onEnter: (p) => setState(() {
                                    if (!z) {
                                      showNext = true;
                                    }
                                  }),
                              onExit: (p) => setState(() {
                                    if (!z) {
                                      showNext = false;
                                    }
                                  }),
                              child: SizedBox(
                                  height: 70,
                                  width: 150,
                                  child: Center(
                                      child: showNext || z
                                          ? const Icon(
                                              Icons.arrow_forward,
                                              color: Colors.blue,
                                              size: 40,
                                            )
                                          : AnimatedBuilder(
                                              animation: testTimeController,
                                              builder: (x, h) => Text(
                                                    (testTimeController.value *
                                                                100)
                                                            .round()
                                                            .toString() +
                                                        "%",
                                                    textAlign: TextAlign.end,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline3!
                                                        .apply(
                                                          color: Colors.blue,
                                                        ),
                                                  ))))),
                        ),
                        SizedBox(
                          height: 20,
                          child: Center(
                            child: SizedBox(
                              child: Text(z
                                  ? ""
                                  : "Bei 100% ist die Zeit für diese Aufgabe abgelaufen. Zum frühzeitigen Weitermachen auf die Anzeige ⬆️ klicken.  "),
                            ),
                          ),
                        )
                      ]),
                )
              : Container(),
          Positioned(
              right: 250,
              bottom: 200,
              child: FadeTransition(
                  opacity: fade,
                  child: OnHover(builder: (onHover) {
                    return GestureDetector(
                        onTap: () {
                          //click
                          if (current == 0 && buttonAllowed) {
                            nextTask();
                            fadeController.reverse();
                          }
                        },
                        child: Container(
                            width: 300,
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.black),
                                color: onHover
                                    ? Colors.black
                                    : Colors.transparent),
                            child: Center(
                              child: Text(
                                buttonPos == 0
                                    ? "Starten"
                                    : (buttonPos == 1 ? "Weiter" : "Beenden"),
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .apply(
                                        color: onHover
                                            ? Colors.white
                                            : Colors.black,
                                        fontSizeDelta: -3),
                              ),
                            )));
                  }))),
          testRunningA != 0
              ? Positioned(
                  right: 25.0,
                  top: 25.0,
                  child: GestureDetector(
                    child:
                        const Icon(Icons.code, size: 33.0, color: Colors.black),
                    onTap: () {
                      if (testRunningA == 0) {
                        return;
                      }

                      setState(() {
                        code = !code;
                      });
                    },
                  ))
              : Container(),
          code
              ? Positioned(
                  right: 25.0,
                  top: 75.0,
                  child: Container(
                      width: 200,
                      height: 500,
                      color: Colors.grey[300],
                      child: Text(codeText,
                          style:
                              Theme.of(context).textTheme.bodySmall!.apply())))
              : Container(),
              Positioned(
                  right: 25.0,
                  top: 75.0,
                  child: SizedBox(
                      width: 200,
                      height: 500,
                      child: Column(
                        children: monitors,
                      ) ))
        ],
      ),
    );
  }

  void print0(dynamic msg) {
    print("print0");
    if (code) {
      msg = msg.toString();
      try {
        setState(() {
          codeText += (msg + "\n");
          if (codeText.length > 300) {
            codeText = codeText.substring((codeText.length / 2).round());
          }
        });
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> checkMeaning() async {
    if (checkMeaningInProcess) {
      return;
    }
    if (testHigh.testAWords.length < 3) {
      //fill
      final List<String> fillElements = [
        "Entität",
        "Zustand",
        "Ort",
        "Situation",
        "Beziehung",
        "Ereignis",
        "Geschehen",
        "Ding",
        "Werk",
        "Gerät"
      ];
      for (var i = testHigh.testAWords.length; i < 3; i++) {
        testHigh.testAWords.add(fillElements[i]);
      }
    }
    checkMeaningInProcess = true;
    List<String> data = testHigh.testAWords;
    TestResult tr = creativeTest!.getLexunitsByOrthform(data);
    if (tr.errorsExist) {
      error(tr.specificError);
    }
    List<List<Lexunit>> lexunits = tr.outputValue;

    int count = 0;

    for (List<Lexunit> element in lexunits) {
      if (code) {
        print0("check element");
        print0(element);
      }

      if (testHigh.meanings.length + testHigh.mutlipleMeanings.length == 10) {
        break;
      }

      if (element.length == 1) {
        testHigh.meanings.add(element.first);
      } else {
        testHigh.mutlipleMeanings.add(element);
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