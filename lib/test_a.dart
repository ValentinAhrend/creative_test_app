import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:creative_test/monitor.dart';
import 'package:creative_test/test.dart';
import 'package:creative_test_dart/creative_test_dart.dart';
import 'package:germanet_dart/germanet_dart.dart';
import 'package:flutter/material.dart';

class TestA extends StatefulWidget {
  /*
   *
   *  
   * 
   */
  Function onError;
  TestState state;
  TestA({Key? key, required this.state, required this.onError})
      : super(key: key);

  @override
  TestAState createState() => TestAState();
}

class TestAState extends State<TestA> {
  bool sv0 = false;
  int errorcode = -1;
  String errorText = "";
  List<String> data = [];
  late TextEditingController _controller;
  var focusNode = FocusNode();

  bool checkWord(String word) {
    TestResult tr =
        widget.state.creativeTest!.checkWord(word); // it happens in REALTIME!!!
    if (tr.errorsExist) {
      widget.onError(tr.specificError);
      return false;
    }
    return tr.outputValue;
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
      children: [
        const SizedBox(
          height: 100,
        ),
        Text(
          "Kreuzverhör",
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
                  "Finde 10 möglichst unterschiedliche Wörter und trage diese in der Liste ein. Die Wörter müssen Nomen sein. Du hast für die Aufgabe 4 Minuten Zeit (siehe unten rechts). ",
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .apply(fontSizeDelta: 1),
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
                              onFieldSubmitted: (t) async {
                                bool b = await addW(t);
                                if (b) {
                                  _controller.text = "";
                                }
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
                                labelText: "Neues Wort",
                                labelStyle:
                                    const TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                          GestureDetector(
                              onTap: () async {
                                if (await addW(_controller.value.text)) {
                                  setState(() {
                                    _controller.text = "";
                                  });
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
                                            color: data.length < 10
                                                ? Colors.blue.shade600
                                                : Colors.grey[400]!,
                                            width: 2),
                                        color: sv0
                                            ? Colors.white
                                            : (data.length < 10
                                                ? Colors.blue
                                                : Colors.grey[400]!)),
                                    child: Center(
                                      child: Text(
                                        "Bestätigen",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6!
                                            .apply(
                                                color: sv0
                                                    ? (data.length < 10
                                                        ? Colors.blue
                                                        : Colors.grey[400]!)
                                                    : Colors.white,
                                                fontSizeDelta: -2),
                                      ),
                                    ),
                                  )))
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
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
                    SizedBox(
                        width: 1100,
                        height: 350,
                        child: Wrap(
                          spacing: 25,
                          runSpacing: 25,
                          children: dataRowWidgets(),
                        ))
                  ]),
            ))
      ],
    );
  }

  Future<bool> addW(String w) async {
    if (data.length <= 10) {
      String t = _controller.value.text;
      if (!checkWord(t)) {
        setState(() {
          errorcode = 0;
          errorText = "Dieses Wort wurde nicht gefunden.";
        });
        return false;
      } else {
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
  List<Widget> dataRowWidgets() {
    List<Widget> widgets = [];
    if (data.length > 10) {
      data = data.getRange(0, 10).toList();
    }
    for (var i = 0; i < data.length; i++) {
      widgets.add(SizedBox(
        width: 200,
        height: 160,
        child: MouseRegion(
            onHover: (p) {
              if (!entered[i]) {
                setState(() {
                  entered[i] = true;
                });
              }
            },
            onExit: (p) {
              setState(() {
                entered[i] = false;
              });
            },
            onEnter: (p) {
              setState(() {
                entered[i] = true;
              });
            },
            child: GestureDetector(
              onTap: () {
                if (entered[i]) {
                  setState(() {
                    data.removeAt(i);
                    testHigh.testAWords.removeAt(i);
                    entered[i] = false;
                  });
                }
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey.withAlpha(20),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey[400]!)),
                child: Center(
                  child: !entered[i]
                      ? Text(

                          data[i],
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.subtitle1!.apply(
                              color: Colors.grey[500]!, fontSizeDelta: 4),
                        )
                      : const Icon(
                          Icons.cancel_outlined,
                          size: 25,
                          color: Colors.grey,
                        ),
                ),
              ),
            )),
      ));
    }
    return widgets;
  }
}

class TestACheck extends StatefulWidget {
  final TestState widget;
  final Function con;
  final Function(int) error;
  const TestACheck(this.widget, this.con, this.error, {Key? key})
      : super(key: key);

  @override
  TestACheckState createState() => TestACheckState();
}

class TestACheckState extends State<TestACheck> {
  int position = 0;
  bool sv0 = false;
  late TextEditingController _controller;
  static Map<String, Lexunit> needed = {}; //word: id
  bool found = false;
  var focusNode = FocusNode();

  @override
  void initState() {
    if (testHigh.mutlipleMeanings.isEmpty || testHigh.testAWords.isEmpty) {
      finishCorrection(widget.con, widget.widget).then((value) {});
      widget.con.call();
    }
    super.initState();
    _controller = TextEditingController();
    if (widget.widget.code) {
      widget.widget.print0(testHigh.mutlipleMeanings.length);
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
    if (testHigh.mutlipleMeanings.isEmpty) {
      return Container();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 100,
        ),
        Text(
          "Kreuzverhör (Korrektur)",
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
                  "Die Bedeutung folgender mehrdeutiger Wörter muss geklärt werden. Dazu muss ein Synonym für das Wort eingegeben werden. Das Synonym muss ein Nomen im Singular sein.",
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .apply(fontSizeDelta: 1),
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
                  SizedBox(
                    width: 200,
                    height: 160,
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey.withAlpha(20),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey[400]!)),
                        child: Center(
                            child: Text(
                          testHigh.mutlipleMeanings[position].first.orthform,
                          style: Theme.of(context).textTheme.subtitle1!.apply(
                              color: Colors.grey[500]!, fontSizeDelta: 4),
                        ))),
                  ),
                  const SizedBox(
                    height: 20,
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
                            onFieldSubmitted: (t) async {
                              runSyn(
                                  _controller.value.text,
                                  testHigh.mutlipleMeanings[position].first
                                      .orthform);
                              _controller.text = "";
                              setState(() {
                                found = true;
                              });
                              focusNode.requestFocus();
                              Future.delayed(const Duration(seconds: 1))
                                  .then((value) {
                                setState(
                                  () {
                                    closed = false;
                                    found = false;
                                    if (position + 1 <
                                        testHigh.mutlipleMeanings.length) {
                                      position += 1;
                                    } else {
                                      finishCorrection(() {}, widget.widget);
                                      widget.con.call();
                                    }
                                  },
                                );
                              });
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
                              labelText:
                                  "Synonym, Überbegriff oder Unterbegriff für " +
                                      testHigh.mutlipleMeanings[position].first
                                          .orthform,
                              labelStyle: const TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                        GestureDetector(
                            onTap: () async {
                              runSyn(
                                  _controller.value.text,
                                  testHigh.mutlipleMeanings[position].first
                                      .orthform);
                              _controller.text = "";
                              focusNode.requestFocus();
                              Future.delayed(const Duration(seconds: 1))
                                  .then((value) {
                                setState(() {
                                  closed = false;
                                  found = false;
                                  if (position + 1 <
                                      testHigh.mutlipleMeanings.length) {
                                    position += 1;
                                  } else {
                                    finishCorrection(() {}, widget.widget);
                                    widget.con.call();
                                  }
                                });
                              });
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
                                      color: sv0 ? Colors.white : Colors.blue),
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
                                )))
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  found
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                              SizedBox(
                                height: 160,
                                child: Container(
                                    width: 200,
                                    decoration: BoxDecoration(
                                        color: Colors.grey.withAlpha(20),
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: Colors.grey[400]!)),
                                    child: const Center(
                                      child: Icon(
                                        Icons.check,
                                        color: Colors.blue,
                                      ),
                                    )),
                              )
                            ])
                      : Container(),
                ]),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }

  static bool f0 = false;
  static Future<void> finishCorrection(Function con, TestState widget) async {
    print("finishCorrection");
    if (f0) {
      return;
    }
    f0 = true;

    while (widget.checkMeaningInProcess) {
      if (widget.code) {
        widget.print0("...");
      }
      await Future.delayed(const Duration(seconds: 1));
    }

    if (widget.code) {
      widget.print0(testHigh.testAWords);
    }

    // await Future.delayed(const Duration(seconds: 4));

    if (needed.length < testHigh.testAWords.length) {
      //fill needed list with default ids
      for (String word in testHigh.testAWords) {
        if (!needed.keys.toList().contains(word)) {
          if (widget.code) {
            widget.print0(testHigh.meanings);
            widget.print0(testHigh.mutlipleMeanings);
            widget.print0(word);
          }

          Lexunit? m;
          for (Lexunit mx in testHigh.meanings) {
            if (mx.orthform == word) {
              m = mx;
              break;
            }
          }
          if (m == null) {
            for (List<Lexunit> n in testHigh.mutlipleMeanings) {
              if (n.any((element) => element.orthform == word)) {
                m = n.firstWhere((element) => element.orthform == word);
                break;
              }
            }
          }
          needed[word] = m!;
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
    if (widget.code) {
      widget.print0("=");
    }
    MonitorWidget mw =
        MonitorWidget(key: GlobalKey(), title: "Auswertung Kreuzverhör");
    widget.addMonitor(mw);
    if(needed.keys.toList().length == 3 && needed.keys.toList().contains("Ort") && needed.keys.toList().contains("Zustand") && needed.keys.toList().contains("Entität")){
      //check internet...
      final result = await Connectivity().checkConnectivity();
      widget.creativeTest!.testALexunits = needed.values.toList();
        widget.creativeTest!.testAOutput =  TestResult(null, true);
      if(result == ConnectivityResult.wifi || result == ConnectivityResult.ethernet || result == ConnectivityResult.mobile){
        widget.creativeTest!.testALexunits = needed.values.toList();
        widget.creativeTest!.testAOutput =  TestResult([[[-1.0, 0.19008162051416877, 0.13211438434012207], [-1.0, -1.0, 0.16946859015532695], [-1.0, -1.0, -1.0]], 0.16388819833653925], false);
      }else{
        widget.error(9);
        return;
      }
    }
    TestResult tr =
        await widget.creativeTest!.validateTestA(mw, needed.values.toList());
        print(tr.outputValue);
    if (tr.errorsExist) {
      print(tr.specificError.toString());
      if(tr.specificError.toString() == "WordRelatednessError.network"){
        //call error
        widget.error(9);
        return;
      }
    }
    widget.finishMonitorWidget(mw);
    con.call();
  }

  bool closed = false;
  void runSyn(String w, String original) async {
    if (closed) {
      return;
    }
    closed = true;
    if (widget.widget.code) {
      widget.widget.print0("?");
    }
    if (widget.widget.code) {
      widget.widget.print0(needed);
    }
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

    if (widget.widget.code) {
      widget.widget.print0(testHigh.mutlipleMeanings[position]);
    }
    List<Lexunit> l0 = testHigh.mutlipleMeanings[position];
    bool found = false;
    for (Lexunit st in l0) {
      if (st.orthform == w) {
        needed[original] = st;
        found = true;
        break;
      }
    }
    if (!found) {
      needed[original] = l0.first;
    }

    widget.widget.print0(needed);
  }
}
