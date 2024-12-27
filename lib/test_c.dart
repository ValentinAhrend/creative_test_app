import 'package:creative_test/monitor.dart';
import 'package:creative_test/test.dart';
import 'package:creative_test_dart/creative_test_dart.dart';
import 'package:flutter/material.dart';
import 'package:germanet_dart/germanet_dart.dart';

class TestC extends StatefulWidget {
  final Function con;
  final Function(int) error;
  TestState widget;
  TestC(this.widget, this.con, this.error, {Key? key}) : super(key: key);

  @override
  TestCState createState() => TestCState();
}

class TestCState extends State<TestC> {
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
      children: [
        const SizedBox(
          height: 100,
        ),
        Text(
          "Satz-Kombination",
          style:
              Theme.of(context).textTheme.headline2!.apply(color: Colors.black),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          height: 100,
          decoration: BoxDecoration(
              color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 100,
                width: 100,
                child: Center(
                    child: Icon(
                  Icons.keyboard_arrow_right_outlined,
                  size: 50,
                )),
              ),
              SizedBox(
                height: 100,
                width: 1000,
                child: Center(
                    child: Text(
                  "Wähle 3 Begriffe aus und bilde aus diesen einen vollständigen Hauptsatz. Der Satz muss grammatikalisch korrekt und logisch sein. Dafür hast du 4 Minuten Zeit.",
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .apply(fontSizeDelta: 3),
                )),
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
                border: Border.all(color: Colors.grey[400]!)),
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
                        child: Column(
                          children: [
                            Text(
                                "Wähle 3 der folgenden Wörter aus, die in dem Satz vorkommen sollen",
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .apply(
                                      color: Colors.grey[400],
                                    )),
                            const SizedBox(height: 50),
                            SizedBox(
                                width: 1200,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: sup(),
                                ))
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
                              onFieldSubmitted: (t) async {
                                if (await addS(_controller.text)) {}
                                focusNode.requestFocus();
                              },
                              cursorColor: Colors.black,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide:
                                        const BorderSide(color: Colors.black)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide:
                                        const BorderSide(color: Colors.black)),
                                fillColor: Colors.black,
                                focusColor: Colors.black,
                                labelText: "Vollständiger Satz",
                                labelStyle:
                                    const TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                          GestureDetector(
                              onTap: () async {
                                if (await addS(_controller.text)) {
                                } else {
                                  focusNode.requestFocus();
                                }
                              },
                              child: MouseRegion(
                                  onEnter: (p) {
                                    setState(() {
                                      sv0 = true;
                                    });
                                  },
                                  onExit: (p) {
                                    setState(() {
                                      sv0 = false;
                                    });
                                  },
                                  child: Container(
                                    width: 150,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: Colors.blue.shade600,
                                            width: 2),
                                        color:
                                            sv0 ? Colors.white : Colors.blue),
                                    child: Center(
                                      child: Text(
                                        "Bestätigen",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6!
                                            .apply(
                                                color: sv0
                                                    ? Colors.blue
                                                    : Colors.white,
                                                fontSizeDelta: -2),
                                      ),
                                    ),
                                  ))),
                        ],
                      ),
                    ),

                    errorcode >= 0
                        ? SizedBox(
                            height: 75,
                            child: Center(
                              child: Container(
                                  width: 570,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.red[500]),
                                  child: Center(
                                      child: SizedBox(
                                          width: 550,
                                          child: Text(errorText,
                                              textAlign: TextAlign.left,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline6!
                                                  .apply(
                                                      color: Colors.white,
                                                      fontSizeDelta: -4,
                                                      fontWeightDelta: -1))))),
                            ),
                          )
                        : Container(),
                    infotext != ""
                        ? SizedBox(
                            height: 75,
                            child: Center(
                              child: Container(
                                  width: 570,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.grey[400]!.withAlpha(120)),
                                  child: Center(
                                      child: SizedBox(
                                          width: 550,
                                          child: Text(infotext,
                                              textAlign: TextAlign.center,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline6!
                                                  .apply(
                                                      color: Colors.white,
                                                      fontSizeDelta: -6,
                                                      fontWeightDelta: -1))))),
                            ),
                          )
                        : Container(),
                  ]),
            ))
      ],
    );
  }

  late List<bool> ticked;

  bool c3() {
    int x = 0;
    for (bool b in ticked) {
      if (b) {
        x++;
      }
    }
    return x > 2;
  }

  List<Widget> sup() {
    List<Widget> ww = [];
    for (var i = 0; i < testHigh.testAWords.length; i++) {
      final String word = testHigh.testAWords[i];
      ww.add(GestureDetector(
          onTap: () {
            if (!(!ticked[i] && c3())) {
              setState(() {
                ticked[i] = !ticked[i];
              });
            }
          },
          child: SizedBox(
              width: 115,
              height: 55,
              child: Stack(
                alignment: Alignment.bottomLeft,
                children: [
                  SizedBox(
                      width: 115,
                      height: 63,
                      child: Center(
                          child: Container(
                              width: 110,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.grey[400]!.withAlpha(120),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  word,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1!
                                      .apply(
                                          color: Colors.black,
                                          fontSizeDelta: 1),
                                ),
                              )))),
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey),
                        color: Colors.white),
                    child: Center(
                      child: Container(
                          width: 12.5,
                          height: 12.5,
                          decoration: ticked[i]
                              ? const BoxDecoration(
                                  color: Colors.blue, shape: BoxShape.circle)
                              : const BoxDecoration(color: Colors.transparent)),
                    ),
                  )
                ],
              ))));
    }
    return ww;
  }

  String infotext = "";

  int output = 0;
  bool sss = false;
  Future<bool> addS(String sentence) async {
    if (sss) {
      return false;
    }
    sss = true;

    if (sentence.isEmpty) {
      if (mounted) {
        setState(() {
          errorcode = 7;
          errorText = "Kein Satz gefunden.";
        });
      }
      sss = false;
      return false;
    }

    if (!sentence.endsWith(".")) {
      if (mounted) {
        setState(() {
          errorcode = 6;
          errorText = "Der Satz sollte mit '.' enden.";
        });
      }
      sss = false;
      return false;
    }

    if (widget.widget.code) {
      widget.widget.print0(sentence);
    }
    //do something

    //check words
    setState(() {
      errorcode = -1;
      errorText = "";
    });
    if (!c3()) {
      setState(() {
        errorcode = 3;
        errorText = "Bitte wähle 3 Begriffe aus.";
      });
      sss = false;
      return false;
    }

    widget.widget.testTimeController.stop();
    if (mounted) {
      setState(() {
        infotext =
            "Der Satz wird geladen. Dies kann mehrere Minuten dauern. Daher ist der Timer pausiert.";
      });
    }
    MonitorWidget mw =
        MonitorWidget(key: GlobalKey(), title: "Auswertung Test C");
    widget.widget.addMonitor(mw);
    List<Lexunit> used = [];
    int ix = 0;
    for (bool element in ticked) {
      if (element) {
        used.add(widget.widget.creativeTest!.testALexunits![ix]);
      }
      ix++;
    }
    TestResult tr =
        await widget.widget.creativeTest!.validateTestC(mw, sentence, used);
    if (tr.errorsExist) {
      if (tr.outputValue.runtimeType == List) {
        if (tr.outputValue.isNotEmpty &&
            tr.outputValue.first.runtimeType.toString() == "WritingMistake") {
          if (mounted) {
            setState(() {
              errorcode = 4;
              errorText = "Fehler in der Grammatik: ${tr.outputValue.first}";
            });
          }
        }
      } else {
        if (tr.specificError.runtimeType.toString() == "LogicException") {
          if (mounted) {
            setState(() {
              errorcode = 4;
              errorText = "Fehler in der Logik: ${tr.specificError}";
            });
          }
        } else {
          if (tr.specificError == "-1") {
            if (mounted) {
              setState(() {
                errorcode = 4;
                errorText =
                    "Angegebene Wörter konnten in dem Satz nicht gefunden werden";
              });
            }
          } else {
            widget.widget.error(tr.specificError);
          }
        }
      }
    }
    widget.widget.finishMonitorWidget(mw);

    testHigh.testCsentence = sentence;
    if (mounted) {
      setState(() {
        infotext = "";
      });
    }
    setState(() {
      infotext = "Satz wurde erfolgreich geladen";
    });

    //check with machine
    widget.widget.testTimeController.forward();
    sss = false;

    return true;
  }
}
