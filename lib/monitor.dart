import 'dart:developer';

import 'package:creative_test_dart/creative_test_dart.dart';
import 'package:flutter/material.dart';

class MonitorWidget extends StatefulWidget with Message {
  final String title;
  GlobalKey? key;
  MonitorWidget({required this.key, required this.title}) : super(key: key);

  @override
  State<MonitorWidget> createState() => _MonitorWidgetState();

  @override
  void sendCurrentStatus(double percentage, int timeInto, String msg) {
    print("current Status: $percentage $msg");
    if (key != null && key!.currentState != null) {
      (key!.currentState! as _MonitorWidgetState)
          .sendCurrentStatus(percentage, timeInto, msg);
    }
  }

  @override
  bool stillActive() {
    return true;
  }

  void prepareToKill() {
    if (key != null && key!.currentState != null) {
      (key!.currentState as _MonitorWidgetState)
          .sendCurrentStatus(1.0, 0, "Abgeschlossen");
    }
  }
}

class _MonitorWidgetState extends State<MonitorWidget> with Message {
  String currentInformation = "";
  double currentValue = 0.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10)
      ),
      child: Center(child: SizedBox(
        width: 180,
        height: 200,
        child: Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.title,
            style: Theme.of(context).textTheme.bodyLarge!,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15,),
          Text(currentInformation,
          textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .apply(color: Colors.grey)),
          const SizedBox(height: 5,),
          SizedBox(
            width: 400,
            child: LinearProgressIndicator(
            value: currentValue,
            color: Colors.blue,
            backgroundColor: Colors.blue.withAlpha(80),
          ))
        ],
      ))),
    ));
  }

  

  @override
  void sendCurrentStatus(double percentage, int timeInto, String msg) {
    if (percentage > 1.0) {
      percentage = 1.0;
    }
    setState(() {
      currentValue = percentage;
      currentInformation = msg;
    });
  }

  @override
  bool stillActive() {
    return true;
  }
}
