//the last test omg its 4:12 am.
import 'dart:convert';

import 'package:creative_test/monitor.dart';
import 'package:creative_test/test.dart';
import 'package:creative_test_dart/creative_test_dart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TestF extends StatefulWidget {
  final Function(int) error;
  final Function con;
  final TestState state;
  const TestF(this.state, this.con, this.error, {Key? key}) : super(key: key);

  @override
  TestFState createState() => TestFState();
}

class TestFState extends State<TestF> {
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
      children: [
        const SizedBox(
          height: 100,
        ),
        Text(
          "Reimspiel",
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
                  "Schreibe ein sich reimendes Gedicht. Versuche dich gut auszudrücken und besondere, strukturierte Reime zu verwenden. Auch hier gibt es kein zeitliches Limit.",
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
                child: Stack(alignment: Alignment.topRight, children: [
                  SizedBox.expand(
                      child: TextField(
                          focusNode: focusNode,
                          controller: _controller,
                          maxLines: 200,
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
                          ))),
                  SizedBox(
                      height: 80,
                      width: 200,
                      child: Center(
                          child: GestureDetector(
                        onTap: () {
                          //finish
                          finalValidate(_controller.value.text);
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
                                height: 50,
                                width: 140,
                                decoration: BoxDecoration(
                                    color: sv0 ? Colors.white : Colors.blue,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: Colors.blue.shade600, width: 2)),
                                child: Center(
                                    child: Text(
                                  "Weiter",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6!
                                      .apply(
                                          color:
                                              sv0 ? Colors.blue : Colors.white),
                                )))),
                      )))
                ])))
      ],
    );
  }

  bool c0 = false;
  void finalValidate(String p) async {
    if (c0) {
      return;
    }
    c0 = true;
    MonitorWidget mw =
        MonitorWidget(key: GlobalKey(), title: "Auswertung Problemzauber");
    widget.state.addMonitor(mw);
    TestResult tr = await widget.state.creativeTest!.validateTestF(
        mw,
        p,
        (jsonDecode(await rootBundle.loadString("assets/trashWords.json"))
                as List)
            .cast());
    if (tr.errorsExist) {
      widget.state.error(tr.specificError);
    }
    widget.state.finishMonitorWidget(mw);
    c0 = false;
    widget.con.call();
  }
}
