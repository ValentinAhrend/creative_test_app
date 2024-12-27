import 'dart:math';

import 'package:creative_test/mechanics.dart';
import 'package:creative_test/test.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  runApp(const CreativityTest());
}

class CreativityTest extends StatelessWidget {
  const CreativityTest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: "KreativTest",
      debugShowCheckedModeBanner: false,
      theme: CupertinoTheme.of(context),
      home: StartPage(),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('de', ''), // English, no country code
      ],
    );
  }
}

class StartPage extends StatefulWidget {
  StartPage({Key? key}) : super(key: key);

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage>
    with SingleTickerProviderStateMixin {
  int load = 2;
  int pattern0 = 0;

  bool loading = false;
  bool welcome = true;
  bool info = false;
  late AnimationController _offSlide;
  late Animation<double> _offAnim;
  late Future future0;
  late History history;
  Map focuesElement = {};

  @override
  void initState() {
    // Create and store the VideoPlayerController. The VideoPlayerController
    // offers several different constructors to play videos from assets, files,
    // or the internet.
    future0 = rootBundle.loadString("assets/KreativTest.html");
    _offSlide = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _offAnim = Tween<double>(begin: 1.0, end: 0.0).animate(_offSlide);

    History.load().then((value) {
      history = value;
    });

    super.initState();
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(250, 250, 250, 250),
      body: Stack(
        alignment: Alignment.center,
        children: [
          loading
              ? Center(
                  child: SizedBox(
                  width: 800,
                  height: 600,
                  child: Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          load == 0
                              ? Container()
                              : load == 1
                                  ? Image.asset(
                                      "assets/logo_half_loaded.png",
                                      width: 300,
                                      height: 300,
                                    )
                                  : Image.asset("assets/load.gif",
                                      width: 300, height: 300)
                        ]),
                  ),
                ))
              : Container(),
          welcome
              ? Center(
                  child: SizedBox(
                    width: 800,
                    height: 600,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Willkommen bei KreativTest",
                          style: Theme.of(context)
                              .textTheme
                              .headline4!
                              .apply(color: Colors.black),
                        ),
                        Container(
                          height: 15,
                        ),
                        SizedBox(
                            width: 120,
                            height: 40,
                            child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    welcome = false;
                                    info = true;
                                  });
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      border: Border.all(
                                          color: Colors.black,
                                          width: 2,
                                          style: BorderStyle.solid),
                                      borderRadius: BorderRadius.circular(33.3),
                                    ),
                                    child: Center(
                                        child: Text(
                                      "Los geht's",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2!
                                          .apply(color: Colors.black),
                                    )))))
                      ],
                    ),
                  ),
                )
              : Container(),
          info
              ? Center(
                  child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  width: 739,
                  height: 555,
                  child: Center(
                      child: FadeTransition(
                    opacity: _offAnim,
                    child: pattern0 == 0
                        ? Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 1),
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.grey[200]!.withAlpha(120),
                            ),
                            width: 717,
                            height: 533,
                            child: Stack(children: [
                              FutureBuilder(
                                future: future0,
                                builder: (x, y) {
                                  if (!y.hasData) {
                                    return Container();
                                  } else {
                                    return Center(
                                        child: SizedBox(
                                            width: 690,
                                            child: Html(
                                                data: y.data!.toString())));
                                  }
                                },
                              ),
                              Positioned(
                                bottom: 15,
                                left: 20,
                                right: 20,
                                child: SizedBox(
                                    height: 40,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        GestureDetector(
                                            onTap: () {
                                              // see licenses
                                              launch(
                                                  "https://pitch-hisser-5d9.notion.site/Validierung-von-Kreativit-t-durch-KI-424f86d400724c27aeab6bce77ac47ca");
                                            },
                                            child: Container(
                                              width: 160,
                                              height: 30,
                                              decoration: BoxDecoration(
                                                color: Colors.transparent,
                                                border: Border.all(
                                                    color: Colors.black
                                                        .withAlpha(200),
                                                    width: 2,
                                                    style: BorderStyle.solid),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                      height: 20,
                                                      width: 120,
                                                      child: Center(
                                                          child: Text(
                                                        "Funktionsweise",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyText2!
                                                            .apply(
                                                                color: Colors
                                                                    .black
                                                                    .withAlpha(
                                                                        220)),
                                                      )))
                                                ],
                                              ),
                                            )),
                                        GestureDetector(
                                            onTap: () {
                                              // open test
                                              //
                                              //scroll down to see history

                                              _offSlide.forward().then((value) {
                                                setState(() {
                                                  pattern0 = 1;
                                                });
                                                _offSlide.reverse();
                                              });
                                            },
                                            child: Container(
                                              width: 160,
                                              height: 30,
                                              decoration: BoxDecoration(
                                                color: Colors.transparent,
                                                border: Border.all(
                                                    color: Colors.black
                                                        .withAlpha(240),
                                                    width: 2,
                                                    style: BorderStyle.solid),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                      height: 20,
                                                      width: 120,
                                                      child: Center(
                                                          child: Text(
                                                        "Verlauf",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyText2!
                                                            .apply(
                                                                color: Colors
                                                                    .black
                                                                    .withAlpha(
                                                                        240)),
                                                      )))
                                                ],
                                              ),
                                            )),
                                        GestureDetector(
                                            onTap: () async {
                                              // open test
                                              //
                                              if (await windowManager
                                                      .isMaximized() &&
                                                  await windowManager
                                                      .isFullScreen()) {
                                                Navigator.of(context)
                                                    .push(_createRoute());
                                              } else {
                                                await windowManager.maximize();
                                                await windowManager
                                                    .setFullScreen(true);

                                                Navigator.of(context)
                                                    .push(_createRoute());
                                              }
                                            },
                                            child: Container(
                                              width: 160,
                                              height: 30,
                                              decoration: BoxDecoration(
                                                color: Colors.transparent,
                                                border: Border.all(
                                                    color: Colors.black
                                                        .withAlpha(240),
                                                    width: 2,
                                                    style: BorderStyle.solid),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                      height: 20,
                                                      width: 120,
                                                      child: Center(
                                                          child: Text(
                                                        "Test Starten",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyText2!
                                                            .apply(
                                                                color: Colors
                                                                    .black
                                                                    .withAlpha(
                                                                        240)),
                                                      )))
                                                ],
                                              ),
                                            ))
                                      ],
                                    )),
                              ),
                            ]))
                        : pattern0 == 1
                            ? Container(
                                child: Column(
                                  children: [
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            top: 15.0, left: 25.0, right: 25.0),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              GestureDetector(
                                                  onTap: () {
                                                    _offSlide
                                                        .forward()
                                                        .then((value) {
                                                      setState(() {
                                                        pattern0 = 0;
                                                      });
                                                      _offSlide.reverse();
                                                    });
                                                  },
                                                  child: const Icon(
                                                    Icons.arrow_back_ios,
                                                    color: Colors.black,
                                                  )),
                                              Text(
                                                "Test Verlauf",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline5,
                                              ),
                                              const Icon(
                                                Icons.arrow_back_ios,
                                                color: Colors.white,
                                              ),
                                            ])),
                                    const SizedBox(
                                      height: 33,
                                    ),
                                    Container(
                                        height: 420,
                                        child: ListView.separated(
                                            itemBuilder: (w, c) {
                                              return Container(
                                                height: 75,
                                                child: Stack(
                                                  children: [
                                                    Positioned(
                                                      left: 15.0,
                                                      top: 0.0,
                                                      bottom: 0.0,
                                                      child: Center(
                                                          child: Text(
                                                        "Test " +
                                                            numToStr(history
                                                                    .entry
                                                                    .length -
                                                                c),
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyText1,
                                                      )),
                                                    ),
                                                    Positioned(
                                                      left: 15.0,
                                                      right: 15.0,
                                                      top: 0.0,
                                                      bottom: 0.0,
                                                      child: Center(
                                                          child: Text(
                                                        returnBiggestCharacteristic(DateTime
                                                                .now()
                                                            .difference(DateTime
                                                                .fromMillisecondsSinceEpoch(
                                                                    history.entry[
                                                                            c][
                                                                        "startTime"]))),
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyText1,
                                                      )),
                                                    ),
                                                    Positioned(
                                                      right: 15.0,
                                                      top: 0.0,
                                                      bottom: 0.0,
                                                      child: GestureDetector(
                                                          onTap: () {
                                                            _offSlide
                                                                .forward()
                                                                .then((value) {
                                                              setState(() {
                                                                focuesElement =
                                                                    history
                                                                        .entry[c];
                                                                pattern0 = 2;
                                                              });
                                                              _offSlide
                                                                  .reverse();
                                                            });
                                                          },
                                                          child: Center(
                                                              child: Text(
                                                                  "Mehr Informationen",
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .bodyText1!
                                                                      .apply(
                                                                          decoration:
                                                                              TextDecoration.underline)))),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                            separatorBuilder: (w, c) {
                                              return const Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 15.0),
                                                  child: Divider(
                                                    height: 10.0,
                                                    thickness: 1.0,
                                                    color: Colors.black,
                                                  ));
                                            },
                                            itemCount: history.entry.length))
                                  ],
                                ),
                              )
                            : Container(
                                child: Column(children: [
                                Padding(
                                    padding: const EdgeInsets.only(
                                        top: 15.0, left: 25.0, right: 25.0),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          GestureDetector(
                                              onTap: () {
                                                _offSlide
                                                    .forward()
                                                    .then((value) {
                                                  setState(() {
                                                    pattern0 = 1;
                                                  });
                                                  _offSlide.reverse();
                                                });
                                              },
                                              child: const Icon(
                                                Icons.arrow_back_ios,
                                                color: Colors.black,
                                              )),
                                          Text(
                                            "Test " +
                                                numToStr(history.entry.length -
                                                    history.entry.indexOf(
                                                        focuesElement)),
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline5,
                                          ),
                                          const Icon(
                                            Icons.arrow_back_ios,
                                            color: Colors.white,
                                          ),
                                        ])),
                                const SizedBox(
                                  height: 33,
                                ),
                                Container(
                                    height: 420,
                                    child: ListView.separated(
                                        itemBuilder: (x, c) {
                                          String key =
                                              focuesElement.keys.toList()[c];
                                          String value = "2423424234234234";

                                          if (c == 0) {
                                            key = "Durchgeführt von";
                                            value = focuesElement.values
                                                .toList()[0];
                                          }

                                          if (c == 1) {
                                            key = "Wörter aus Aufgabe 1";
                                            var s0 = focuesElement.values
                                                .toList()[1]
                                                .toString();
                                            //s0 = " 928374923874923874982374923874293847293847928742983479283749283749238749238749283472983479283749238749238749238742938479238749283749238472937 ";
                                            value =
                                                s0.substring(1, s0.length - 1);
                                          }

                                          if (c == 2) {
                                            //skipping to 3
                                            key = "Ergebnis aus Aufgabe 1";
                                            value = (focuesElement.values
                                                    .toList()[4][3][1])
                                                .toStringAsPrecision(6);
                                          }

                                          if (c == 3) {
                                            //skipping to 6
                                            key = "Ergebnis aus Aufgabe 2";

                                            value = (focuesElement.values
                                                    .toList()[7][3][0])
                                                .toStringAsPrecision(6);
                                          }
                                          if (c == 4) {
                                            //skipping to 8
                                            key = "Satz aus Aufgabe 3";
                                            value = focuesElement.values
                                                .toList()[9];
                                          }
                                          if (c == 5) {
                                            //skipping to 7
                                            key = "Ergebnis aus Aufgabe 3";
                                            if (focuesElement.values
                                                    .toList()[8]
                                                    .length ==
                                                0) {
                                              value = "";
                                            } else {
                                              //exx
                                              value = focuesElement.values
                                                  .toList()[8][3][0]
                                                  .toStringAsPrecision(6);
                                            }
                                          }
                                          if (c == 6) {
                                            key = "Ergebnisse aus Aufgabe 4";
                                            value = "";
                                            var i = 0;
                                            for (List cc in (focuesElement
                                                .values
                                                .toList()[12])) {
                                              if (cc.isEmpty) {
                                                value += " ,";
                                              } else {
                                                //exx
                                                value += cc[3][0].toString() +
                                                    " Richtig" +
                                                    ((i < 2) ? " | " : "");
                                              }
                                              i++;
                                            }
                                          }
                                          if (c == 7) {
                                            key = "Ergebnis aus Aufgabe 5";
                                            if (focuesElement.values
                                                    .toList()[13]
                                                    .length ==
                                                0) {
                                              value = "";
                                            } else {
                                              //exx
                                              value = focuesElement.values
                                                  .toList()[13][3][0]
                                                  .toStringAsPrecision(6);
                                            }
                                          }
                                          if (c == 8) {
                                            key = "Ergebnis aus Aufgabe 6";
                                            if (focuesElement.values
                                                    .toList()[14]
                                                    .length ==
                                                0) {
                                              value = "";
                                            } else {
                                              //exx
                                              value = focuesElement.values
                                                  .toList()[14][3][0]
                                                  .toStringAsPrecision(6);
                                            }
                                          }
                                          if (c == 9) {
                                            key = "Dauer";
                                            value = durationFormat(Duration(
                                                milliseconds: focuesElement
                                                    .values
                                                    .toList()[15]));
                                          }
                                          DateTime.now();
                                          if (c == 10) {
                                            key = "Startzeit";
                                            value = format(DateTime
                                                .fromMillisecondsSinceEpoch(
                                                    focuesElement.values
                                                        .toList()[16]));
                                          }
                                          if (c == 11) {
                                            key = "Id";
                                            value = focuesElement["uuid"];
                                          }

                                          return Container(
                                            height: 75,
                                            child: Stack(
                                              children: [
                                                Positioned(
                                                  left: 15.0,
                                                  top: 0.0,
                                                  bottom: 0.0,
                                                  child: Center(
                                                      child: Text(
                                                    key,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1,
                                                  )),
                                                ),
                                                Positioned(
                                                  right: 15.0,
                                                  top: 0.0,
                                                  bottom: 0.0,
                                                  child: Center(
                                                      child: SizedBox(
                                                          width: 500,
                                                          child: Text(value,
                                                              textAlign:
                                                                  TextAlign
                                                                      .right,
                                                              maxLines: 3,
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyText1!
                                                                  .apply(
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                  )))),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        separatorBuilder: (x, c) {
                                          return const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 15.0),
                                              child: Divider(
                                                height: 10.0,
                                                thickness: 1.0,
                                                color: Colors.black,
                                              ));
                                        },
                                        itemCount: 12))
                              ])),
                  )),
                ))
              : Container()
        ],
      ),
    );
  }
}

String format(DateTime dt) {
  return dt.hour.toString() +
      ":" +
      dt.minute.toString() +
      ", " +
      dt.day.toString() +
      "." +
      dt.month.toString() +
      "." +
      dt.year.toString();
}

String durationFormat(Duration d) {
  return d.toString().substring(0, d.toString().length - 3);
}

String returnBiggestCharacteristic(Duration dt) {
  if (dt.inDays > 365) {
    if (dt.inDays < 356 * 2) {
      return "vor einem Jahr";
    } else {
      return "vor ${(dt.inDays % 365).toString()} Jahren";
    }
  }
  if (dt.inDays > 30) {
    if (dt.inDays < 30 * 2) {
      return "vor einem Monat";
    } else {
      return "vor ${(dt.inDays % 30).toString()} Monaten";
    }
  }
  if (dt.inDays != 0) {
    if (dt.inDays == 1) {
      return "vor einem Tag";
    } else {
      return "vor ${dt.inDays.toString()} Tagen";
    }
  }
  if (dt.inHours != 0) {
    if (dt.inHours == 1) {
      return "vor einer Stunde";
    } else {
      return "vor ${dt.inHours.toString()} Stunden";
    }
  }
  if (dt.inMinutes != 0) {
    if (dt.inMinutes == 1) {
      return "vor einer Minute";
    } else {
      return "vor ${dt.inMinutes.toString()} Minuten";
    }
  }
  print(dt);
  return "gerade eben";
}

String numToStr(int n) {
  final cetta = [
    "eins",
    "zwei",
    "drei",
    "vier",
    "fünf",
    "sechs",
    "sieben",
    "acht",
    "neun",
    "zehn",
    "elf",
    "zwölf",
  ];
  final gamma = [
    "zehn",
    "zwanzig",
    "dreißig",
    "vierzig",
    "fünfzig",
    "sechzig",
    "siebzig",
    "achtzig",
    "neunzig"
  ];
  if (n < 13) {
    return cetta[n - 1];
  }
  String ending = "";
  if (int.parse(n.toString().substring(n.toString().length - 2)) < 13) {
    ending =
        cetta[int.parse(n.toString().substring(n.toString().length - 2)) - 1];
  } else {
    var end0 = n.toString().substring(n.toString().length - 2);
    if (int.parse(end0.substring(0, 1)) == 1) {
      ending = cetta[int.parse(end0.substring(1)) - 1] + "zehn";
    } else {
      if (int.parse(end0.substring(1)) == 1) {
        ending = "einund" + gamma[int.parse(end0.substring(0, 1)) - 1];
      }
      ending = cetta[int.parse(end0.substring(1)) - 1] +
          "und" +
          gamma[int.parse(end0.substring(0, 1)) - 1];
    }
  }

  final omicron = [
    "hundert",
    "tausend",
  ];

  int tenExp = 2;
  while (true) {
    if (tenExp == 5) {
      return n.toString();
    }

    if (n > pow(10, tenExp) - 1) {
      //adding ^x-t component
      String xr = omicron[tenExp - 2];
      String pos = n.toString()[n.toString().length - tenExp - 1];

      if (pos == "1") {
        xr = "ein" + xr;
      } else {
        xr = cetta[int.parse(pos) - 1] + xr;
      }

      ending = xr + ending;
      tenExp++;
    } else {
      break;
    }
  }

  return ending;
}

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => const TestWidget(),
    transitionDuration: const Duration(milliseconds: 100),
    reverseTransitionDuration: const Duration(milliseconds: 0),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const end = Offset.zero;
      const begin = Offset(0.0, -1.0);
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
