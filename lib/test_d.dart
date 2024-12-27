import 'package:creative_test/monitor.dart';
import 'package:creative_test/test.dart';
import 'package:creative_test_dart/creative_test_dart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TestD extends StatefulWidget {
  final Function(int) error;
  final Function con;
  final TestState state;
  const TestD(this.state, this.con, this.error, {Key? key}) : super(key: key);

  @override
  TestDState createState() => TestDState();
}

class TestDState extends State<TestD> {
  var focusNode = FocusNode();
  late TextEditingController _controller;
  bool sv0 = false;
  bool sv1 = false;
  int errorcode = -1;
  String errorText = "";
  String infotext = "";

  int currentProblem = 0;

  final List<String> problemText = [
    "Du triffst dich mit deinem französischen Austauschschüler, doch dir ist ein Wort entfallen. Wie kannst du deinem Freund zeigen, um welches Wort es sich handelt?",
    "Welche Folgen hat es, wenn du dir in den Finger schneidest?",
    "Wie kannst du einen deiner Freunde von deiner Idee überzeugen?"
  ];

  List<List<String>> solutions = [[], [], []];

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
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
          "Problemzauber",
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
                  "Löse die folgenden 3 Probleme, indem du einfache Lösungssätze eingibts. Die Lösungssätze sollten immer nur eine Antwortmöglichkeit enthalten. ",
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
            height: 650,
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
                      height: 100,
                      width: 1000,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[400]!.withAlpha(120),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.blue.shade600)),
                        child: Center(
                            child: SizedBox(
                                width: 900,
                                height: 97,
                                child: Center(
                                    child: RichText(
                                        text: TextSpan(
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle1,
                                            children: <TextSpan>[
                                      TextSpan(
                                          text: "Problem " +
                                              (currentProblem + 1).toString() +
                                              ": ",
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1!
                                              .apply(fontWeightDelta: 3)),
                                      TextSpan(
                                          text: problemText[currentProblem])
                                    ]))))),
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
                              onFieldSubmitted: (t) async {
                                if (await addSolution(_controller.text)) {
                                  _controller.text = "";
                                  focusNode.requestFocus();
                                }
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
                                labelText: "Lösungsmöglichkeit",
                                labelStyle:
                                    const TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                          GestureDetector(
                              onTap: () async {
                                if (await addSolution(_controller.text)) {
                                  _controller.text = "";
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
                          GestureDetector(
                              onTap: () async {
                                startProblemSolving(currentProblem);
                                if (currentProblem < 2) {
                                  setState(() {
                                    errorText = "";
                                    errorcode = -1;
                                    currentProblem++;
                                  });
                                } else {
                                  //finish
                                  widget.con.call();
                                }
                              },
                              child: MouseRegion(
                                  onEnter: (p) {
                                    setState(() {
                                      sv1 = true;
                                    });
                                  },
                                  onExit: (p) {
                                    setState(() {
                                      sv1 = false;
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
                                            !sv1 ? Colors.white : Colors.blue),
                                    child: Center(
                                      child: Text(
                                        currentProblem < 2
                                            ? "Nächstes Problem"
                                            : "Nächste Aufgabe",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6!
                                            .apply(
                                                color: !sv1
                                                    ? Colors.blue
                                                    : Colors.white,
                                                fontSizeDelta: -4),
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

                    const SizedBox(height: 25),
                    SizedBox(
                        height: 300,
                        child: SingleChildScrollView(
                            child: SizedBox(
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
                  ]),
            ))
      ],
    );
  }

  void startProblemSolving(int current) async {
    testHigh.currentTestD = solutions;
    MonitorWidget mw =
        MonitorWidget(key: GlobalKey(), title: "Auswertung Problemzauber");
    widget.state.addMonitor(mw);
    TestResult tr = await widget.state.creativeTest!.validateTestD(
        mw,
        solutions[current],
        current + 1,
        await rootBundle
            .loadString("assets/d/test4-${current + 1}-methods.json"),
        await rootBundle.loadString("assets/d/test4-${current + 1}.json"));
    if (tr.errorsExist) {
      widget.state.error(tr.specificError);
    }
    widget.state.finishMonitorWidget(mw);
  }

  List<bool> hovering = [];
  List<Widget> getAll() {
    List<Widget> ww = [];
    for (var i = 0; i < solutions[currentProblem].length; i++) {
      ww.add(SizedBox(
        width: 1000,
        height: 60,
        child: Center(
            child: MouseRegion(
                onEnter: (p) {
                  setState(() {
                    hovering[i] = true;
                  });
                },
                onExit: (p) {
                  setState(() {
                    hovering[i] = false;
                  });
                },
                onHover: (p) {
                  setState(() {
                    hovering[i] = true;
                  });
                },
                child: GestureDetector(
                    onTap: () {
                      setState(() {
                        solutions[currentProblem]
                            .remove(solutions[currentProblem][i]);
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
                        child:
                            Stack(alignment: Alignment.centerRight, children: [
                          hovering[i]
                              ? SizedBox(
                                  width: 55,
                                  height: 55,
                                  child: Center(
                                      child: Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.cancel,
                                        color: Colors.blue, size: 25),
                                  )),
                                )
                              : Container(),
                          Center(
                              child: SizedBox(
                            width: 990,
                            child: Text(
                                " #" +
                                    (i + 1).toString() +
                                    ": " +
                                    solutions[currentProblem][i],
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.subtitle1),
                          ))
                        ]))))),
      ));
    }
    return ww;
  }

  Future<bool> addSolution(String solution) async {
    setState(() {
      errorcode = -1;
      errorText = "";
    });
    if (solution.isNotEmpty &&
        solution.split(" ").length > 1 &&
        solution.endsWith(".")) {
      if (solutions[currentProblem].contains(solution)) {
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
    } else {
      setState(() {
        errorcode = 10;
        errorText = "Es wurde keine Satzstruktur gefunden";
      });
      return false;
    }
  }
}
