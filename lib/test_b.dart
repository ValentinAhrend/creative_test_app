import 'package:creative_test/test.dart';
import 'package:flutter/material.dart';
import 'package:germanet_dart/germanet_dart.dart';

class TestB extends StatefulWidget {
  final Function(int) onError;
  final Function con;
  final TestState state;
  const TestB(this.state, this.con, this.onError, {Key? key}) : super(key: key);

  @override
  TestBState createState() => TestBState();
}

class TestBState extends State<TestB> {
  bool loaded = false;
  int errorcode = -1;
  String errorText = "";
  late List<Lexunit> testWords;
  int pos = 0;
  var focusNode = FocusNode();
  late TextEditingController _controller;
  bool sv0 = false;
  bool sv1 = false;
  Map<int, List<Lexunit>> data = {0: [], 1: [], 2: []};

  @override
  void initState() {
    super.initState();
    loadTest3Words();
    _controller = TextEditingController();
  }

  void loadTest3Words() async {
    if (widget.state.code) {
      widget.state.print0(testHigh.testAWords);
    }
    //http.Response res = await http.get(Uri.parse("http://127.0.0.1:"+widget.port+"/?test_id=1&method=0&input_data="+jsonEncode(testHigh.testAWords)));
    //returning list test words
    testWords = widget.state.creativeTest!.defineTaskBUnits();
    if (testWords.length < 3) {
      testWords = widget.state.creativeTest!
          .getLexunitsByOrthform(testHigh.testAWords.getRange(0, 3).toList())
          .outputValue.map((e) => e[0]).toList().cast<Lexunit>();
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
    if (loaded) {
      Map<Lexunit, List<Lexunit>> m = {};

      for (var i = 0; i < data.keys.length; i++) {
        m[testWords[i]] = data[i]!;
      }

      testHigh.testBMapList = m;
    }
    return loaded
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 100,
              ),
              Text(
                "Buchstabenkette",
                style: Theme.of(context)
                    .textTheme
                    .headline2!
                    .apply(color: Colors.black),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                height: 100,
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10)),
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
                        "Finde für die folgenden Begriffe möglichst viele ähnliche Wörter. Die Wörter müssen Nomen sein.",
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
                          SizedBox(
                            height: 50,
                            child: Center(
                                child: Container(
                                    height: 50,
                                    width: 150,
                                    decoration: BoxDecoration(
                                        color: Colors.grey[400]!.withAlpha(50),
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Center(
                                        child: Text(
                                            '"' + testWords[pos].orthform + '"',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6!
                                                .apply(
                                                  color: Colors.black,
                                                ))))),
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
                                    onFieldSubmitted: (t) async {
                                      if (await addW(_controller.text)) {
                                        _controller.text = "";
                                      }
                                      focusNode.requestFocus();
                                    },
                                    cursorColor: Colors.black,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                              color: Colors.black)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                              color: Colors.black)),
                                      fillColor: Colors.black,
                                      focusColor: Colors.black,
                                      labelText:
                                          "Möglichst Ähnliches Wort für " +
                                              testWords[pos].orthform,
                                      labelStyle:
                                          const TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                    onTap: () async {
                                      if (await addW(_controller.text)) {
                                        _controller.text = "";
                                      }
                                      focusNode.requestFocus();
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
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                  color: Colors.blue.shade600,
                                                  width: 2),
                                              color: sv0
                                                  ? Colors.white
                                                  : Colors.blue),
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
                                      if (pos == 2) {
                                        setState(() {
                                          loaded = false;
                                        });

                                        //save task
                                        Map<Lexunit, List<Lexunit>> m = {};

                                        for (var i = 0;
                                            i < data.keys.length;
                                            i++) {
                                          m[testWords[i]] = data[i]!;
                                        }

                                        testHigh.testBMapList = m;
                                        //finish
                                        widget.con.call();
                                      }
                                      setState(() {
                                        if (pos < 2) {
                                          pos++;
                                          errorText = "";
                                          errorcode = -1;
                                        }
                                        hovering = [];
                                      });
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
                                          width: 180,
                                          height: 50,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                  color: Colors.blue.shade600,
                                                  width: 2),
                                              color: !sv1
                                                  ? Colors.white
                                                  : Colors.blue),
                                          child: Center(
                                            child: Text(
                                              pos == 2
                                                  ? "Nächste Aufgabe"
                                                  : "Nächster Begriff",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline6!
                                                  .apply(
                                                      color: !sv1
                                                          ? Colors.blue
                                                          : Colors.white,
                                                      fontSizeDelta: -2),
                                            ),
                                          ),
                                        ))),
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
                                            borderRadius:
                                                BorderRadius.circular(10),
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
                                                            fontWeightDelta:
                                                                -1))))),
                                  ),
                                )
                              : Container(),
                          SizedBox(
                              width: 1100,
                              height: 300,
                              child: Wrap(
                                spacing: 25,
                                runSpacing: 25,
                                children: getAll(),
                              ))
                        ]),
                  ))
            ],
          )
        : Container();
  }

  Future<bool> addW(String w) async {
    if (data.length <= 10) {
      String t = _controller.value.text;
      Lexunit? lx = checkWord(t);
      if (lx == null) {
        setState(() {
          errorcode = 0;
          errorText = "Dieses Wort wurde nicht gefunden.";
        });
        return false;
      } else {
        if (data[pos]!.contains(lx)) {
          setState(() {
            errorcode = 1;
            errorText = "Dieses Wort hast du bereist eingegben";
          });
          return false;
        } else {
          setState(() {
            errorcode = -1;
            errorText = "";
            hovering.add(false);
            data[pos]!.add(lx);
          });
          return true;
        }
      }
    }
    return false;
  }

  Lexunit? checkWord(String word) {
    List<Lexunit> units =
        widget.state.creativeTest!.germanet!.getLexunitsByOrthform(word);
    if (units.isEmpty) {
      return null;
    }
    return units.first;
  }

  List<bool> hovering = List.empty(growable: true);
  List<Widget> getAll() {
    List<Widget> ww = [];
    for (Lexunit word in data[pos]!) {
      final int cc = data[pos]!.indexOf(word);
      ww.add(MouseRegion(
          onEnter: (p) {
            setState(() {
              hovering[cc] = true;
            });
          },
          onExit: (p) {
            setState(() {
              hovering[cc] = false;
            });
          },
          onHover: (p) {
            setState(() {
              hovering[cc] = true;
            });
          },
          child: GestureDetector(
              onTap: () {
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
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                    child: !hovering[cc]
                        ? Text(word.orthform,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: Theme.of(context).textTheme.headline6!.apply(
                                  color: Colors.black,
                                ))
                        : const Icon(
                            Icons.cancel,
                            color: Colors.black,
                          )),
              ))));
    }

    return ww;
  }
}
