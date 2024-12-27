import 'dart:async';

import 'package:creative_test/test.dart';
import 'package:creative_test_dart/creative_test_dart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Results extends StatefulWidget {
  const Results(this.state, this.results, {Key? key}) : super(key: key);
  final TestState state;
  final List results;

  @override
  _ResultsState createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
  late Timer t0;

  @override
  void initState() {
    t0 = Timer.periodic(const Duration(seconds: 5), (timer) {
      setState(() {});
      //save testHigh with id
      //IMPL
      //History.saveWithId(testHigh);
    });

    //save state

    super.initState();
  }

  @override
  void dispose() {
    t0.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.results);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SizedBox(
        height: 100,
      ),
      Text(
        "Ergebnisse",
        style:
            Theme.of(context).textTheme.headline2!.apply(color: Colors.black),
      ),
      const SizedBox(
        height: 10,
      ),
      SizedBox(
        height: 800,
        child: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Divider(),
            SizedBox(
              height: 25,
              child: Text(
                "Kreuzverhör",
                style: Theme.of(context)
                    .textTheme
                    .subtitle1!
                    .apply(fontWeightDelta: 1, fontSizeDelta: 2),
              ),
            ),
            const SizedBox(height: 20),
            widget.results[0] != null && !widget.results[0]!.errorsExist
                ? SizedBox(
                    child: Wrap(
                    runSpacing: 15.0,
                    direction: Axis.horizontal,
                    verticalDirection: VerticalDirection.down,
                    children: [
                      Table(
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.top,
                        border: TableBorder.all(color: Colors.grey[400]!),
                        columnWidths: const <int, TableColumnWidth>{
                          0: FixedColumnWidth(70),
                          1: FixedColumnWidth(70),
                          2: FixedColumnWidth(70),
                          3: FixedColumnWidth(70),
                          4: FixedColumnWidth(70),
                          5: FixedColumnWidth(70),
                          6: FixedColumnWidth(70),
                          7: FixedColumnWidth(70),
                          8: FixedColumnWidth(70),
                          9: FixedColumnWidth(70),
                          10: FixedColumnWidth(70),
                        },
                        children: getRows(),
                      ),
                      const SizedBox(
                        width: 33,
                      ),
                      SizedBox(
                          height: 150,
                          width: 400,
                          child: Center(
                              child: Text(
                                  "Die Tabelle zeigt die Unterschiede zwischen zwei Wörtern. Bei einem Unterschied von 0.0 handelt es sich um das gleiche Wort, während bei 1.0 die Wörter sehr verschieden sind. Umso geringer der Zusammenhang, umso höher ist die Kreativität.",
                                  textAlign: TextAlign.justify,
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1!
                                      .apply(
                                          color: Colors.black,
                                          fontSizeDelta: 1)))),
                      const SizedBox(
                        width: 20,
                      ),
                      const VerticalDivider(),
                      SizedBox(
                          height: 150,
                          width: 300,
                          child: Center(
                              child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(children: [
                                    TextSpan(
                                        text:
                                            'Der finale Wert liegt bei (0..unkreativ, 1..kreativ):\n\n',
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1!
                                            .apply(
                                                color: Colors.black,
                                                fontSizeDelta: 0)),
                                    TextSpan(
                                        text: widget.results[0]!.outputValue[1]
                                            .toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1!
                                            .apply(
                                                color: widget.results[0]!
                                                            .outputValue[1] >
                                                        0.67
                                                    ? Colors.green[700]
                                                    : (widget.results[0]!
                                                                .outputValue[1] >
                                                            0.34
                                                        ? Colors.yellow[600]
                                                        : Colors.red[700]),
                                                fontSizeDelta: 4)),
                                  ])))),
                      const VerticalDivider(),
                      const SizedBox(
                        width: 20,
                      ),
                      SizedBox(
                          height: 150,
                          width: 600,
                          child: Center(
                              child: RichText(
                                  text: TextSpan(
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1!
                                          .apply(
                                              color: Colors.black,
                                              fontSizeDelta: 1),
                                      children: [
                                        const TextSpan(
                                            text:
                                                "Diese Form der Messung von Kreativiät ist neuartig und wurde in der Nationalen Akademie für Wissenschaft der Vereinigten Staaten veröffentlicht "),
                                        TextSpan(
                                            text: "(mehr)",
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle1!
                                                .apply(
                                                    color: Colors.blue,
                                                    fontWeightDelta: 0,
                                                    fontSizeDelta: 1),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                //open link
                                                launchUrlString(
                                                    'https://doi.org/10.1073/pnas.2022340118');
                                              }),
                                        const TextSpan(
                                          text: ". ",
                                        ),
                                        const TextSpan(
                                          text:
                                              "Die Methode der Messung von Zusammenhängen ist hier allerdings einzigartig, nicht nur durch die Sprache, sondern auch durch Genauigkeit und verschiedene neue Verfahren. Um die Funktionsweise kennenzulernen ",
                                        ),
                                        TextSpan(
                                            text: "hier",
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle1!
                                                .apply(
                                                    color: Colors.blue,
                                                    fontWeightDelta: 0,
                                                    fontSizeDelta: 1),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                //goto documentary
                                                if (widget.state.code) {
                                                  widget.state.print0("?");
                                                }
                                                launchUrlString(
                                                    'https://pitch-hisser-5d9.notion.site/Aufgabe-1-Kreuzverh-r-5fb633b618ae41b7914212860e3a3b11');
                                              }),
                                        const TextSpan(
                                          text: " klicken.",
                                        ),
                                      ]),
                                  textAlign: TextAlign.justify))),
                    ],
                  ))
                : SizedBox(
                    height: 50,
                    child: Center(
                        child: Text("Keine Daten verfügbar.",
                            style: Theme.of(context).textTheme.subtitle1!))),
            const SizedBox(height: 20),
            const Divider(),
            SizedBox(
              height: 25,
              child: Text(
                "Buchstabenkette",
                style: Theme.of(context)
                    .textTheme
                    .subtitle1!
                    .apply(fontWeightDelta: 1, fontSizeDelta: 2),
              ),
            ),
            const SizedBox(height: 20),
            widget.results[1] != null && widget.results[1]!.outputValue != null && !widget.results[1]!.errorsExist
                ? SizedBox(
                    height: 120,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                            height: 120,
                            width: 230,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                    widget.results[1]!.outputValue != null ? (widget.results[1]!.outputValue[1] as Map)
                                        .keys
                                        .toList()[0]
                                        .orthform : "",
                                    style:
                                        Theme.of(context).textTheme.headline6),
                                const Divider(),
                                Text(
                                    "Gesamtergebnis: " + (
                                        widget.results[1]!.outputValue != null ? (widget.results[1]!.outputValue[1]
                                                as Map)
                                            .values
                                            .toList()[0].toString() : "")
                                            ,
                                    style:
                                        Theme.of(context).textTheme.subtitle1),
                              ],
                            )),
                        const SizedBox(width: 50),
                        SizedBox(
                            height: 120,
                            width: 230,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                    widget.results[1]!.outputValue != null ? (widget.results[1]!.outputValue[1] as Map)
                                        .keys
                                        .toList()[1].toString() : "",
                                    style:
                                        Theme.of(context).textTheme.headline6),
                                const Divider(),
                                Text(
                                    "Gesamtergebnis: " +
                                        (widget.results[1]!.outputValue != null ? (widget.results[1]!.outputValue[1]
                                                as Map)
                                            .values
                                            .toList()[1][0]
                                            .toStringAsPrecision(4) : ""),
                                    style:
                                        Theme.of(context).textTheme.subtitle1)
                              ],
                            )),
                        const SizedBox(width: 50),
                        SizedBox(
                            height: 120,
                            width: 230,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                    widget.results[1]!.outputValue != null ? (widget.results[1]!.outputValue[1] as Map)
                                        .keys
                                        .toList()[2].orthform : "",
                                    style:
                                        Theme.of(context).textTheme.headline6),
                                const Divider(),
                                Text(
                                    "Gesamtergebnis: " +
                                        (widget.results[1]!.outputValue != null ? (widget.results[1]!.outputValue[1]
                                                as Map)
                                            .values
                                            .toList()[2][0]
                                            .toStringAsPrecision(4) : ""),
                                    style:
                                        Theme.of(context).textTheme.subtitle1),
                              ],
                            ))
                      ],
                    ))
                : SizedBox(
                    height: 50,
                    child: Center(
                        child: Text("Keine Daten verfügbar.",
                            style: Theme.of(context).textTheme.subtitle1!))),
            widget.results[1] != null && widget.results[1]!.outputValue != null && !widget.results[1]!.errorsExist
                ? SizedBox(
                    child: Text(
                        "Diese Aufgabe soll den Wortschatz und die Fähigkeit Wörter zu verknüpfen testen. Die Zusammenhänge geben an, wie gut die Eingabe durchschnittlich mit dem jeweiligen Wort zusammen passt. Das Gesamtergebnis wird neben den Zusammenhängen noch durch die Anzahl an Eingaben bestimmt. Diese wird mit der Anzahl an allen möglichen ähnlichen Wörtern verglichen, sodass ein faires Ergebnis entsteht. Der finale Wert dieser Aufgabe beträgt: ",
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1!
                            .apply(color: Colors.black, fontSizeDelta: 1),
                        textAlign: TextAlign.left))
                : Container(),
            widget.results[1] != null && widget.results[1]!.outputValue != null && !widget.results[1]!.errorsExist
                ? SizedBox(
                    height: 50,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.results[1]!.outputValue != null ? widget.results[1]!.outputValue[0].toString() : "",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6!
                                  .apply(
                                      color: widget.results[1]!.outputValue != null ? (widget.results[1]!.outputValue[0] >
                                              0.34
                                          ? (widget.results[1]!.outputValue[0] >
                                                  0.67
                                              ? Colors.green[700]
                                              : Colors.yellow[600])
                                          : Colors.red[700]):Colors.red))
                        ]))
                : Container(),
            const SizedBox(height: 20),
            const Divider(),
            SizedBox(
              height: 25,
              child: Text(
                "Satz-Kombination: " + testHigh.testCsentence,
                style: Theme.of(context)
                    .textTheme
                    .subtitle1!
                    .apply(fontWeightDelta: 1, fontSizeDelta: 2),
              ),
            ),
            const SizedBox(height: 20),
            widget.results[2] != null && widget.results[2]!.outputValue != null && !widget.results[2]!.errorsExist
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        widget.results[2]!.outputValue[1][0] != 3
                            ? Text("- Der Satz ist womöglich nicht originell.",
                                style: Theme.of(context).textTheme.subtitle1)
                            : Text("+ Der Satz ist originell.",
                                style: Theme.of(context).textTheme.subtitle1),
                        widget.results[2]!.outputValue[1][2] != 0
                            ? Text(
                                "- Die Begriff befinden sich womöglich in einer Aufzählung.",
                                style: Theme.of(context).textTheme.subtitle1)
                            : Text(
                                "+ Die Begriffe sind nicht Teil einer Aufzählung.",
                                style: Theme.of(context).textTheme.subtitle1),
                        const SizedBox(height: 20),
                        Text(
                          widget.results[2]!.outputValue[0]
                              .toStringAsPrecision(4),
                          style: Theme.of(context).textTheme.headline6!.apply(
                              color: widget.results[2]!.outputValue[0] < 0
                                  ? Colors.red[700]
                                  : (widget.results[2]!.outputValue[0] > 0.5
                                      ? Colors.green[700]
                                      : Colors.yellow[600])),
                        ),
                        const SizedBox(height: 10),
                        RichText(
                            text: TextSpan(
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1!
                              .apply(color: Colors.black, fontSizeDelta: 1),
                          children: [
                            const TextSpan(
                              text:
                                  "Der Wert wurde mit drei verschiedenen Faktoren erstellt. Details zur Funktionsweise finden sie ",
                            ),
                            TextSpan(
                                text: "hier",
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .apply(
                                        color: Colors.blue,
                                        fontWeightDelta: 0,
                                        fontSizeDelta: 1),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    //goto documentary 3
                                    launch(
                                        'https://pitch-hisser-5d9.notion.site/Aufgabe-3-Satz-Kombination-59c3f981f04941618c47d4599463a813',
                                        enableJavaScript: true);
                                  }),
                            const TextSpan(text: ".")
                          ],
                        )),
                        const SizedBox(height: 10),
                        widget.results[0] != null &&
                                !widget.results[0]!.errorsExist
                            ? Text(
                                "Im Zusammenhang zur Schwierigkeit (bzw. zur Verschiedenheit der verwendeten Wörter) ergibt sich folgendes Ergebnis: ",
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .apply(
                                        color: Colors.black, fontSizeDelta: 1))
                            : Container(),
                        const SizedBox(height: 10),
                        widget.results[0] != null &&
                                !widget.results[0]!.errorsExist
                            ? Text(
                                (widget.results[2]!.outputValue[0] *
                                        (1 + widget.results[0]!.outputValue[1]))
                                    .toStringAsPrecision(4),
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .apply(
                                        color: widget.results[2]!
                                                        .outputValue[0] *
                                                    (1 +
                                                        widget.results[0]!
                                                            .outputValue[1]) <
                                                0.25
                                            ? Colors.red[700]
                                            : (widget.results[2]!
                                                            .outputValue[1] *
                                                        widget.results[0]!
                                                            .outputValue[1] >
                                                    0.5
                                                ? Colors.green[700]
                                                : Colors.yellow[600])),
                              )
                            : Container()
                      ])
                : SizedBox(
                    height: 50,
                    child: Center(
                        child: Text("Keine Daten verfügbar.",
                            style: Theme.of(context).textTheme.subtitle1!))),
            const SizedBox(height: 20),
            const Divider(),
            SizedBox(
              height: 25,
              child: Text(
                "Problemzauber: ",
                style: Theme.of(context)
                    .textTheme
                    .subtitle1!
                    .apply(fontWeightDelta: 1, fontSizeDelta: 2),
              ),
            ),
            const SizedBox(height: 20),
            widget.results.length >= 7 && !widget.results
                    .getRange(5, 7)
                    .any((element) => element == null || element.outputValue == null || element.errorsExist)
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.grey[300]),
                              width: 300,
                              height: 25,
                              child: Center(
                                  child: Text(
                                      "Richtige Lösungen Problem 1: " +
                                          widget
                                              .results[5]!.outputValue[0].length
                                              .toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1!
                                          .apply(
                                              color: Colors.black,
                                              fontSizeDelta: 1)))),
                          const SizedBox(
                            width: 15,
                          ),
                          Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.grey[300]),
                              width: 300,
                              height: 25,
                              child: Center(
                                  child: Text(
                                      "Richtige Lösungen Problem 2: " +
                                          widget
                                              .results[5]!.outputValue[1].length
                                              .toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1!
                                          .apply(
                                              color: Colors.black,
                                              fontSizeDelta: 1)))),
                          const SizedBox(
                            width: 15,
                          ),
                          Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.grey[300]),
                              width: 300,
                              height: 25,
                              child: Center(
                                  child: Text(
                                      "Richtige Lösungen Problem 3: " +
                                          widget
                                              .results[5]!.outputValue[2].length
                                              .toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1!
                                          .apply(
                                              color: Colors.black,
                                              fontSizeDelta: 1))))
                        ],
                      )
                    ],
                  )
                : SizedBox(
                    height: 50,
                    child: Center(
                        child: Text("Keine Daten verfügbar.",
                            style: Theme.of(context).textTheme.subtitle1!))),
            const SizedBox(height: 20),
            const SizedBox(height: 20),
            const Divider(),
            SizedBox(
              height: 25,
              child: Text(
                "Schlangenlinie: ",
                style: Theme.of(context)
                    .textTheme
                    .subtitle1!
                    .apply(fontWeightDelta: 1, fontSizeDelta: 2),
              ),
            ),
            const SizedBox(height: 20),
            widget.results[3] is! List && widget.results[3] != null && widget.results[3]!.outputValue != null  && !widget.results[3]!.errorsExist
                ? SizedBox(
                    height: 50,
                    child: Row(
                      children: [
                        Text(
                          widget.results[3]!.outputValue[0]
                              .toStringAsPrecision(4),
                          style: Theme.of(context).textTheme.headline6!.apply(
                              color: widget.results[3]!.outputValue[0] < 0
                                  ? Colors.red[700]
                                  : (widget.results[3]!.outputValue[0] > 0.5
                                      ? Colors.green[700]
                                      : Colors.yellow[600])),
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        SizedBox(
                            width: 400,
                            child: Text(
                              "Anhand von Anzahl und Zusammenhang zwischen den Eingaben wird der Score bewertet. Der Score ist ein Durchschnitt aus allen 3 Wort-Ketten.",
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .apply(fontSizeDelta: 1),
                              maxLines: 2,
                            ))
                      ],
                    ))
                : SizedBox(
                    height: 50,
                    child: Center(
                        child: Text("Keine Daten verfügbar.",
                            style: Theme.of(context).textTheme.subtitle1!))),
            const SizedBox(height: 20),
            const Divider(),
            SizedBox(
              height: 25,
              child: Text(
                "Reimspiel: ",
                style: Theme.of(context)
                    .textTheme
                    .subtitle1!
                    .apply(fontWeightDelta: 1, fontSizeDelta: 2),
              ),
            ),
            const SizedBox(height: 20),
            widget.results[4] != null && widget.results[4]!.outputValue != null && !widget.results[4]!.errorsExist
                ? SizedBox(
                    height: 50,
                    child: Row(
                      children: [
                        Text(
                          widget.results[4]!.outputValue[0]
                              .toStringAsPrecision(4),
                          style: Theme.of(context).textTheme.headline6!.apply(
                              color: widget.results[4]!.outputValue[0] < 0
                                  ? Colors.red[700]
                                  : (widget.results[4]!.outputValue[0] > 0.5
                                      ? Colors.green[700]
                                      : Colors.yellow[600])),
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        SizedBox(
                            width: 500,
                            child: Text(
                              "Anhand von Länge, Reimanzahl, Besonderheit der Reime und Besnoderheit der Wörter wird das Gedicht bewertet.",
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .apply(fontSizeDelta: 1),
                              maxLines: 2,
                            ))
                      ],
                    ))
                : SizedBox(
                    height: 50,
                    child: Center(
                        child: Text("Keine Daten verfügbar.",
                            style: Theme.of(context).textTheme.subtitle1!))),
          ],
        )),
      )
    ]);
  }

  List<TableRow> getRows() {
    List<TableRow> rows = [];
    //get matrix from testA
    Matrix matrix = widget.results[0]!.outputValue[0];

    for (var i = -1; i < matrix.xAxisRow.length; i++) {
      if (i == -1) {
        List<Widget> childs = [];
        for (var j = -1; j < matrix.xAxisRow.length; j++) {
          if (j == -1) {
            childs.add(const SizedBox(height: 30, width: 50));
          } else {
            childs.add(SizedBox(
                height: 30,
                width: 68,
                child: Center(
                    child: Text(testHigh.testAWords[j],
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1!
                            .apply(color: Colors.black)))));
          }
        }
        // childs.add(SizedBox(height: 10,width: 10));
        rows.add(TableRow(children: childs));
        continue;
      }
      List<Widget> childs = [];
      for (var j = -1; j < matrix.xAxisRow[i].length; j++) {
        if (j == -1) {
          childs.add(SizedBox(
              height: 30,
              width: 50,
              child: Center(
                  child: Text(testHigh.testAWords[i],
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1!
                          .apply(color: Colors.black)))));
        } else {
          var value = normTestAValue(matrix.get(j, i), false);
          childs.add(SizedBox(
              height: 30,
              width: 68,
              child: Container(
                  decoration: value.toString() == ""
                      ? BoxDecoration(color: Colors.grey[400]!.withAlpha(120))
                      : BoxDecoration(
                          color: double.parse(value) > 0.67
                              ? Colors.green.withAlpha(120)
                              : (double.parse(value) > 0.34
                                  ? Colors.yellow.withAlpha(120)
                                  : Colors.red.withAlpha(120))),
                  child: Center(
                      child: Text(value.toString(),
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1!
                              .apply(color: Colors.black))))));
        }
      }
      // childs.add(SizedBox(height: 10,width: 10));
      rows.add(TableRow(children: childs));
    }

    return rows;
  }

  dynamic normTestAValue(dynamic d, bool safe) {
    double d0 = double.parse(d.toString());
    if (!safe) {
      if (d0 == 0.0 || d0 == -1.0) {
        return "";
      } else {
        return d0.toStringAsFixed(2);
      }
    }
  }
}
