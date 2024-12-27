import 'package:creative_test/monitor.dart';
import 'package:creative_test/test.dart';
import 'package:creative_test_dart/creative_test_dart.dart';
import 'package:flutter/material.dart';

class TestE extends StatefulWidget {
  final Function(int) error;
  final Function con;
  TestState widget;
  TestE(this.con, this.error, this.widget, {Key? key}) : super(key: key);

  @override
  TestEState createState() => TestEState();
}

class TestEState extends State<TestE> {
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
      children: [
        const SizedBox(
          height: 100,
        ),
        Text(
          "Schlangenlinie",
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
                  "Notiere das erste Wort, dass dir zu dem vorigen Wort einfällt. Am Ende wird eine Kette aus vielen zusammenhängenden Wörtern entstehen. Für jede Reihe an Wörtern hast du 1 Minute Zeit.",
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
                      width: 900,
                      height: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
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
                                      blurRadius: 5.0)
                                ]),
                            child: Center(
                                child: data[row].isEmpty
                                    ? Container()
                                    : Text(
                                        data[row][data[row].length - 1],
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1!
                                            .apply(
                                                color: Colors.black,
                                                fontSizeDelta: 2),
                                      )),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 100),
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
                                    blurRadius: 5.0)
                              ]),
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
                                    if (await addW(t)) {
                                      _controller.text = "";
                                      focusNode.requestFocus();
                                    } else {
                                      focusNode.requestFocus();
                                    }
                                  },
                                  cursorColor: Colors.black,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: Colors.black)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: Colors.black)),
                                    fillColor: Colors.black,
                                    focusColor: Colors.black,
                                    labelText: data[row].isEmpty
                                        ? starter[row]
                                        : "Assoziiertes Wort",
                                    labelStyle:
                                        const TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                  onTap: () async {
                                    if (await addW(_controller.value.text)) {
                                      _controller.text = "";
                                      focusNode.requestFocus();
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
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                                color: !finished
                                                    ? Colors.blue.shade600
                                                    : Colors.grey[400]!,
                                                width: 2),
                                            color: !finished
                                                ? (sv0
                                                    ? Colors.white
                                                    : Colors.blue)
                                                : Colors.grey[400]!
                                                    .withAlpha(120)),
                                        child: Center(
                                          child: Text(
                                            "Bestätigen",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6!
                                                .apply(
                                                    color: !finished
                                                        ? (sv0
                                                            ? Colors.blue
                                                            : Colors.white)
                                                        : Colors.white,
                                                    fontSizeDelta: -2),
                                          ),
                                        ),
                                      ))),
                            ],
                          ),
                        )),

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
                    const SizedBox(height: 30),
                  ]),
            ))
      ],
    );
  }

  List<List<String>> data = [[], [], []];
  Future<bool> addW(String word) async {
    //runValidation();
    if (data[row].length < 100) {
      String t = _controller.value.text;
      if (!checkWord(word)) {
        setState(() {
          errorcode = 0;
          errorText = "Dieses Wort wurde nicht gefunden.";
        });
        return false;
      } else {
        setState(() {
          errorcode = -1;
          errorText = "";
        });
        data[row].add(t);

        return true;
      }
    }
    return false;
  }

  int firstTime = 0;
  int lastTime = 0;
  int cx = 0;

  bool checkWord(String word) {
    if (cx == 0) {
      widget.widget.restartE(row == 1);
      cx = 1;
      Future.delayed(const Duration(minutes: 1)).then((value) async {
        cx = 0;
        if (widget.widget.testTimeController.value != 1.0) {
          await Future.delayed(Duration(
              seconds: (60 * (1.0 - widget.widget.testTimeController.value))
                  .toInt()));
        }
        //finish
        if (mounted) {
          setState(() {
            finished = true;
          });
        }

        if (row < 2) {
          if (widget.widget.code) {
            widget.widget.print0("row < 2");
          }
          widget.widget.restartE(row == 1);
        }
        firstTime = DateTime.now().millisecondsSinceEpoch;
        Future.delayed(const Duration(seconds: 1)).then((value) {
          if (row < 2) {
            if (mounted) {
              setState(() {
                row++;
                finished = false;
              });
            }
          } else {
            runValidation();
            finished = true;
          }
        });
        Future.delayed(const Duration(minutes: 1)).then((value) async {
          if (widget.widget.testTimeController.value != 1.0) {
            await Future.delayed(Duration(
                seconds: (60 * (1.0 - widget.widget.testTimeController.value))
                    .toInt()));
          }
          //finish
          try {
            setState(() {
              finished = true;
            });
          } catch (e) {
            print(e);
          }
          if (row < 2) {
            if (widget.widget.code) {
              widget.widget.print0(".");
            }
            widget.widget.restartE(row == 1);
          }
          firstTime = DateTime.now().millisecondsSinceEpoch;
          Future.delayed(Duration(seconds: 1)).then((value) {
            if (row < 2) {
              try {
                setState(() {
                  row++;
                  finished = false;
                });
              } catch (e) {
                print(e);
              }
            } else {
              runValidation();
              finished = true;
            }
          });
          Future.delayed(const Duration(minutes: 1)).then((value) async {
            if (widget.widget.testTimeController.value != 1.0) {
              await Future.delayed(Duration(
                  seconds: (60 * (1.0 - widget.widget.testTimeController.value))
                      .toInt()));
            }
            //finish
            WidgetsBinding.instance.addPostFrameCallback((_) {
              try {
                setState(() {
                  finished = true;
                });
              } catch (e) {
                print(e);
              }

              if (row < 2) {
                if (widget.widget.code) {
                  widget.widget.print0(".");
                }
                widget.widget.restartE(row == 1);
              }
              firstTime = DateTime.now().millisecondsSinceEpoch;
              Future.delayed(const Duration(seconds: 1)).then((value) {
                if (row < 2) {
                  try {
                    setState(() {
                      row++;
                      finished = false;
                    });
                  } catch (e) {
                    print(e);
                  }
                } else {
                  runValidation();
                  finished = true;
                }
              });
            });
          });
        });
      });
    }

    TestResult tr = widget.widget.creativeTest!.checkWord(word);
    if (tr.errorsExist) {
      widget.widget.error(tr.specificError);
    }
    return tr.outputValue;
  }

  void runValidation() async {
    if (widget.widget.code) {
      widget.widget.print0("run");
    }
    //http.Response res = await http.get(Uri.parse("http://127.0.0.1:"+widget.port+"/?test_id=4&method=0&input_data="+jsonEncode(allData)));

    /*
    /?test_id=4&method=0&input_data=%5B%5B%5B%22Tennis%22,2%5D,%5B%22Sand%22,2071%5D,%5B%22Wüste%22,2785%5D,%5B%22Osten%22,2296%5D,%5B%22Sonne%22,1384%5D,%5B%22Meer%22,2169%5D,%5B%22Strand%22,3180%5D,%5B%22Palme%22,1614%5D,%5B%22Blatt%22,3815%5D,%5B%22Papier%22,2493%5D,%5B%22Schule%22,15000%5D,%5B%22Mathe%22,2119%5D,%5B%22Rechnen%22,3167%5D,%5B%22Taschenrechner%22,6289%5D,%5B%22Computer%22,2864%5D,%5B%22Software%22,2668%5D,%5B%22Programm%22,2103%5D,%5B%22Arbeit%22,4444%5D,%5B%22Leben%22,6197%5D,%5B%22Religion%22,2690%5D%5D,%5B%5B%22Fisch%22,2%5D,%5B%22Meer%22,3792%5D,%5B%22Strand%22,1977%5D,%5B%22Sand%22,1608%5D,%5B%22Tennis%22,11682%5D,%5B%22Schuh%22,5203%5D,%5B%22Bruder%22,4426%5D,%5B%22Familie%22,4945%5D,%5B%22Haus%22,1554%5D,%5B%22Garten%22,5938%5D,%5B%22Baum%22,1205%5D,%5B%22Zuhause%22,5492%5D,%5B%22Wohnung%22,3676%5D,%5B%22Ort%22,4543%5D,%5B%22Zeit%22,4387%5D,%5B%22Geschichte%22,2479%5D,%5B%22Krieg%22,4927%5D,%5B%22Waffe%22,2955%5D,%5B%22USA%22,2048%5D,%5B%22Gefahr%22,3002%5D%5D,%5B%5B%22Bau%22,2%5D,%5B%22Bau%22,886%5D,%5B%22Bau%22,867%5D,%5B%22Bau%22,830%5D,%5B%22Bau%22,850%5D,%5B%22Bau%22,2836%5D,%5B%22Bau%22,552%5D,%5B%22Bau%22,256%5D,%5B%22Bau%22,205%5D,%5B%22Bau%22,337%5D,%5B%22Bau%22,268%5D,%5B%22Bau%22,806%5D%5D%5D
    */

    for (List d in data) {
      if (d.length == 1) {
        d.add(d[0]);
      }
    }

    if (widget.widget.code) {
      widget.widget.print0(data);
    }
    MonitorWidget mw =
        MonitorWidget(key: GlobalKey(), title: "Auswertung Schlangenlinie");
    widget.widget.addMonitor(mw);
    TestResult tr = await widget.widget.creativeTest!.validateTestE(mw, data);
    if (tr.errorsExist) {
      widget.widget.error(tr.specificError);
    }
    widget.widget.finishMonitorWidget(mw);

    widget.widget.setState(() {
      widget.widget.nextTask();
    });
  }
}
