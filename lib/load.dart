import 'package:creative_test/test.dart';
import 'package:flutter/material.dart';

class Load extends StatefulWidget {
  final bool correct;
  final SimpleListener listener;
  final TestState state;
  const Load(this.correct, this.state, {Key? key, required this.listener})
      : super(key: key);

  @override
  _LoadState createState() => _LoadState();
}

class _LoadState extends State<Load> {
  @override
  void initState() {
    super.initState();
    //load
    //call python
    if (widget.state.code) {
      widget.state.print0("load");
    }
    if (widget.correct) {
      //call test init in state
      //use future to return to state
      widget.state.initTest().then((value) {
        widget.listener.onLoadingFinished(0);
      });
    }
  }

  String port = "";

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
              child: Image.asset("assets/logo_full_loaded.png")),
        ),
        Text(
          "Laden...",
          style: Theme.of(context).textTheme.bodyText1!.apply(fontSizeDelta: 2),
        )
      ],
    );
  }
}
