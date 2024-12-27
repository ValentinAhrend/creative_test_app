import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:creative_test/main.dart';
import 'package:creative_test_dart/creative_test_dart.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:germanet_dart/germanet_dart.dart';

class TestHigh {
  //modify this variable in the test.dart/TestA class

  List<String> testAWords = [];
  List<Lexunit> meanings = [];
  List<List<Lexunit>> mutlipleMeanings = [];
  Map<Lexunit, List<Lexunit>> testBMapList = {};
  String testCsentence = "";
  List<List> currentTestD = [];
}

class History {
  static const fileName = "hst.json";

  static Future<History> load() async {
    Directory dir = await getApplicationDocumentsDirectory();
    if (await dir.list().any((element) => element.path.endsWith(fileName))) {
      var history = (await dir
          .list()
          .firstWhere((element) => element.path.endsWith(fileName)));

      File f0 = File(history.path);
      if (await f0.readAsString() == "") {
        await f0.writeAsString("[]");
      }

      return History(jsonDecode(await File(history.path).readAsString()));
    } else {
      return History([]);
    }
  }

  static Future<void> save(TestHigh high) async {
    Directory dir = await getApplicationDocumentsDirectory();
    if (!await dir.list().any((element) => element.path.endsWith(fileName))) {
      File f = File(dir.path + "/" + fileName);
      await f.create();
    }
    File f0 = File((await dir
            .list()
            .firstWhere((element) => element.path.endsWith(fileName)))
        .path);

    List l0 = jsonDecode(await f0.readAsString());

    /*l0.add({
      "author": high.author,
      "testAWord": high.testAWords,
      "meanings": high.meanings,
      "multipleMeanings": high.mutlipleMeanings,
      "dynamicTestAOut": high.dynamicTestAOut,
      "test1length": high.test1length,
      "testBMapList": high.testBMapList,
      "dynamicTestBout": high.dynamicTestBout,
      "dynamicTestCout": high.dynamicTestCout,
      "testCsentence": high.testCsentence,
      "testCerror": high.testCerror,
      "currentTestD": high.currentTestD,
      "dynamicTestDOut": high.dynamicTestDOut,
      "dynamicTestEOut": high.dynamicTestEOut,
      "dynamicTestFout": high.dynamicTestFout,
      "duration": high.duration,
      "startTime": high.startTime,
      "uuid": high.uuid
    });*/
    await f0.writeAsString(jsonEncode(l0));
  }

  static Future<void> saveWithId(TestHigh high) async {
    Directory dir = await getApplicationDocumentsDirectory();
    if (!await dir.list().any((element) => element.path.endsWith(fileName))) {
      File f = File(dir.path + "/" + fileName);
      await f.create();
    }
    File f0 = File((await dir
            .list()
            .firstWhere((element) => element.path.endsWith(fileName)))
        .path);
    if (!(await f0.exists())) {
      await f0.create();
    }
    if (await f0.readAsString() == "") {
      await f0.writeAsString("[]");
    }
    List l0 = jsonDecode(await f0.readAsString());

    for (var item in l0) {
      if (item is Map) {
        if (item.containsKey("uuid")) {
          if (item["uuid"] == "") {
            l0.remove(item);
            break;
          }
        }
      }
    }

    /*l0.add({
      "author": high.author,
      "testAWord": high.testAWords,
      "meanings": high.meanings,
      "multipleMeanings": high.mutlipleMeanings,
      "dynamicTestAOut": high.dynamicTestAOut,
      "test1length": high.test1length,
      "testBMapList": high.testBMapList,
      "dynamicTestBout": high.dynamicTestBout,
      "dynamicTestCout": high.dynamicTestCout,
      "testCsentence": high.testCsentence,
      "testCerror": high.testCerror,
      "currentTestD": high.currentTestD,
      "dynamicTestDOut": high.dynamicTestDOut,
      "dynamicTestEOut": high.dynamicTestEOut,
      "dynamicTestFout": high.dynamicTestFout,
      "duration": high.duration,
      "startTime": high.startTime,
      "uuid": high.uuid
    });*/

    //await f0.writeAsString(jsonEncode(l0));
  }

  late List<Map> entry;
  History(List entry) {
    /*

    entry list format:

    [

      0map: {

        $TestHighValues...

      }

    ]

    */

    this.entry = entry.cast<Map>().reversed.toList();
  }
}

Future<List<PseudoFile>> generatePseudoFiles() async {
  final files = [
    "assets/g/nomen.Pflanze.xml",
    "assets/g/verben.Lokation.xml",
    "assets/g/adj.Gefuehl.xml",
    "assets/g/nomen.Attribut.xml",
    "assets/g/nomen.Tier.xml",
    "assets/g/adj.Zeit.xml",
    "assets/g/verben.Allgemein.xml",
    "assets/g/nomen.Relation.xml",
    "assets/g/verben.Kontakt.xml",
    "assets/g/nomen.Tops.xml",
    "assets/g/nomen.Motiv.xml",
    "assets/g/adj.Ort.xml",
    "assets/g/adj.Bewegung.xml",
    "assets/g/adj.Verhalten.xml",
    "assets/g/nomen.Geschehen.xml",
    "assets/g/verben.Kommunikation.xml",
    "assets/g/nomen.Ort.xml",
    "assets/g/interLingualIndex_DE-EN.xml",
    "assets/g/adj.Perzeption.xml",
    "assets/g/verben.Schoepfung.xml",
    "assets/g/verben.Veraenderung.xml",
    "assets/g/adj.Menge.xml",
    "assets/g/verben.Verbrauch.xml",
    "assets/g/nomen.Gefuehl.xml",
    "assets/g/nomen.Mensch.xml",
    "assets/g/germanet_wiktionary.dtd",
    "assets/g/adj.Substanz.xml",
    "assets/g/nomen.Kommunikation.xml",
    "assets/g/verben.Gesellschaft.xml",
    "assets/g/verben.Besitz.xml",
    "assets/g/nomen.Gruppe.xml",
    "assets/g/adj.Geist.xml",
    "assets/g/nomen.Form.xml",
    "assets/g/nomen.Nahrung.xml",
    "assets/g/adj.Gesellschaft.xml",
    "assets/g/adj.Allgemein.xml",
    "assets/g/verben.Perzeption.xml",
    "assets/g/nomen.Koerper.xml",
    "assets/g/nomen.Kognition.xml",
    "assets/g/nomen.natPhaenomen.xml",
    "assets/g/nomen.natGegenstand.xml",
    "assets/g/adj.Relation.xml",
    "assets/g/wiktionaryParaphrases-adj.xml",
    "assets/g/germanet_relations.dtd",
    "assets/g/nomen.Menge.xml",
    "assets/g/gn_relations.xml",
    "assets/g/verben.natPhaenomen.xml",
    "assets/g/verben.Konkurrenz.xml",
    "assets/g/verben.Koerperfunktion.xml",
    "assets/g/nomen.Besitz.xml",
    "assets/g/verben.Kognition.xml",
    "assets/g/wiktionaryParaphrases-nomen.xml",
    "assets/g/adj.natPhaenomen.xml",
    "assets/g/adj.privativ.xml",
    "assets/g/adj.Koerper.xml",
    "assets/g/nomen.Substanz.xml",
    "assets/g/nomen.Artefakt.xml",
    "assets/g/adj.Pertonym.xml",
    "assets/g/nomen.Zeit.xml",
    "assets/g/germanet_objects.dtd",
    "assets/g/wiktionaryParaphrases-verben.xml",
    "assets/g/verben.Gefuehl.xml",
    "assets/g/germanet_ili.dtd"
  ];
  List<PseudoFile> psf = await Future.wait(
      files.map((e) async => PseudoFileAdpt(rootBundle, e)).toList());
  return psf;
}

class PseudoFileAdpt extends PseudoFile {
  AssetBundle root;
  PseudoFileAdpt(this.root, String title) : super(title);

  @override
  Future<String> readAsString() {
    return root.loadString(path);
  }
}
