import 'package:flutter/material.dart';

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
        Icon(
          Icons.timer_off,
          color: Colors.grey[400]!,
          size: 80.0,
        ),
        SizedBox(
            height: 80,
            child: Center(
              child: Text(
                "Die Zeit ist abgelaufen",
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .apply(color: Colors.grey[400]!),
              ),
            )),
        SizedBox(
          height: 100,
          child: Center(
              child: GestureDetector(
                  onTap: () {
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
                            border: Border.all(
                                color: Colors.blue.shade600, width: 2),
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: Text(
                            "Weiter",
                            style: Theme.of(context).textTheme.subtitle1!.apply(
                                color: focus ? Colors.blue : Colors.white),
                          ),
                        ),
                      )))),
        )
      ],
    );
  }
}
