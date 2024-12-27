import 'package:creative_test/test.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class Intro extends StatefulWidget {
  TestState state;
  Intro(this.state, {Key? key}) : super(key: key);

  @override
  _IntroState createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  //final TextEditingController _controller = TextEditingController();
  FocusNode focusRequest = FocusNode();
  bool bDayAc = false;
  bool bSchAc = false;
  String snew = "";
  List<String> deg = [
    "Keinen",
    "Hauptschulabschluss",
    "Realschulabschluss",
    "Abitur",
    "Fachhochschulreife",
    "Meister",
    "Bachelor",
    "Master",
    "Promotion"
  ];
  String schLvl = "";
  DateTime dt = DateTime(1900);
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500)).then((value) {
      focusRequest.requestFocus();
    });
  }

  void checkReady() {
    if (snew.length > 1 && schLvl.length > 1 && dt.year != 1900) {
      widget.state.name = snew;
      widget.state.birthday = dt.millisecondsSinceEpoch;
      widget.state.deg = schLvl;
      widget.state.placeButton();
    } else {
      widget.state.displaceButton();
    }
  }

  @override
  Widget build(BuildContext context) {
    /*
    Einführung

    Aufbau

    Regeln

    Beachten
    */
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 220,
        ),
        Text(
          "Einführung",
          style:
              Theme.of(context).textTheme.headline2!.apply(color: Colors.black),
          textAlign: TextAlign.start,
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
            height: 600,
            child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                  Text(
                      "Der KreativTest besteht aus 6 Aufgaben, die wiederum aus Teilaufgaben betstehen können. Es gibt auch Aufgaben, bei denen eine gewisse Zeit zur Bearbeitung vorgesehen ist. Insgesamt dauert der Test nicht länger als 15 - 30 Minuten. Versuche den Anweisungen exakt zu folgen. Dieser Test erfordert Konzentration. Das Ablenken durch Buch oder Handy sollte vermieden werden.",
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1!
                          .apply(color: Colors.black, fontWeightDelta: 0)),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                      "Es gibt folgende Regeln zu beachten:\na) Die Lösung darf nur durch eigenständiges Überlegen erstellt werden.\nb) Die Aufgabenstellung gilt es stets zu beachten.",
                      style: Theme.of(context).textTheme.subtitle1!.apply(
                            color: Colors.black,
                          )),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                      "Viel Glück bei den Aufgaben. Sei Kreativ und habe Freude am Denken!",
                      style: Theme.of(context).textTheme.subtitle1!.apply(
                            color: Colors.black,
                          )),
                  const SizedBox(
                    height: 25,
                  ),
                  Text("Gebe zunächst deinen Namen ein:",
                      style: Theme.of(context).textTheme.subtitle1!.apply(
                            color: Colors.black,
                          )),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                      width: 350,
                      child: TextFormField(
                          focusNode: focusRequest,
                          onChanged: (snew) {
                            this.snew = snew;
                            checkReady();
                          },
                          decoration: InputDecoration(
                              labelText: "Dein Name",
                              border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.blue.shade600),
                                  borderRadius: BorderRadius.circular(12.0))))),
                  const SizedBox(
                    height: 20,
                  ),
                  Text("Alter:",
                      style: Theme.of(context).textTheme.subtitle1!.apply(
                            color: Colors.black,
                          )),
                  const SizedBox(
                    height: 10,
                  ),
                  bDayAc
                      ? SizedBox(
                          width: 350,
                          child: SfDateRangePicker(
                            onSelectionChanged: (change) {
                              setState(() {
                                bDayAc = false;
                                dt = change.value;
                              });
                              checkReady();
                            },
                            selectionMode: DateRangePickerSelectionMode.single,
                            initialDisplayDate: DateTime.utc(1990),
                          ))
                      : GestureDetector(
                          onTap: () {
                            setState(() {
                              bDayAc = true;
                            });
                          },
                          child: Container(
                              height: 50,
                              width: 200,
                              decoration: BoxDecoration(
                                  color: Colors.grey.withAlpha(90),
                                  borderRadius: BorderRadius.circular(12.5)),
                              child: Center(
                                  child: Text(dt.year == 1900
                                      ? "Wähle dein Geburtsdatum."
                                      : (dt.day.toString() +
                                          "." +
                                          dt.month.toString() +
                                          "." +
                                          dt.year.toString()))))),
                  const SizedBox(
                    height: 20,
                  ),
                  Text("Höchster Bildungsabschluss:",
                      style: Theme.of(context).textTheme.subtitle1!.apply(
                            color: Colors.black,
                          )),
                  const SizedBox(
                    height: 10,
                  ),
                  bSchAc
                      ? SizedBox(
                          width: 300,
                          height: 250,
                          child: ListView.separated(
                              itemCount: deg.length,
                              separatorBuilder: (c, x) {
                                return const SizedBox(height: 10);
                              },
                              itemBuilder: (c, x) {
                                return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        schLvl = deg[x];
                                        bSchAc = false;
                                      });
                                      checkReady();
                                    },
                                    child: Container(
                                        height: 35,
                                        decoration: BoxDecoration(
                                            color: Colors.grey.withAlpha(90),
                                            borderRadius:
                                                BorderRadius.circular(12.5)),
                                        child: Center(
                                            child: Text(
                                          deg[x],
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                        ))));
                              }))
                      : GestureDetector(
                          onTap: () {
                            setState(() {
                              bSchAc = true;
                            });
                          },
                          child: Container(
                              height: 50,
                              width: 200,
                              decoration: BoxDecoration(
                                  color: Colors.grey.withAlpha(90),
                                  borderRadius: BorderRadius.circular(12.5)),
                              child: Center(
                                  child: Text(schLvl == ""
                                      ? "Wähle deinen Bildungsgrad."
                                      : (schLvl))))),
                ])))
      ],
    );
  }
}
