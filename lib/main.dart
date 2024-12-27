import 'package:creative_test/test.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:window_manager/window_manager.dart';

void main() async{
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

class _StartPageState extends State<StartPage> with SingleTickerProviderStateMixin{
  
  int load = 2;

  bool loading = false;
  bool welcome = true;
  bool info = false;

  late Future future0;

  @override
  void initState() {
    // Create and store the VideoPlayerController. The VideoPlayerController
    // offers several different constructors to play videos from assets, files,
    // or the internet.
    future0 = rootBundle.loadString("assets/KreativTest.html");
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

      backgroundColor: const Color.fromARGB(250, 250,250,250),
      body: Stack(
        alignment: Alignment.center,
        children: [
          loading ? Center(child: SizedBox(
            width: 800,
            height: 600,  
            child: Center(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                load == 0 ? Container(): load == 1 ? Image.asset("assets/logo_half_loaded.png", width: 300, height: 300,) : 
                Image.asset("assets/load.gif", width: 300, height: 300)
              ]
            ),),
          )): Container(),
          welcome ? Center(
            child: SizedBox(
              width: 800,
              height: 600,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Willkommen bei KreativTest",
                    style: Theme.of(context).textTheme.headline4!.apply(
                      color: Colors.black
                    ),

                  ),
                  Container(
                    height: 15,
                  ),
                  SizedBox(
                      width: 120,
                      height: 40,
        child: GestureDetector(
                    onTap: (){  
                      setState(() {
                        welcome = false;
                        info = true;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: Colors.black, width: 2, style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(33.3),
                      
                      ),
                      child: Center(child: Text(
                          "Los geht's",
                          style: Theme.of(context).textTheme.bodyText2!.apply(
                            color: Colors.black 
                          ),
                    
                      ))
                  )))

                ],
              ),
            ),
          ): Container(),
          info ? Center(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1),
                borderRadius: BorderRadius.circular(12),

              ),
              width: 739,
              height: 555,
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey[200]!.withAlpha(120),
                  ),
                  width: 717,
                  height: 533,
                  child: Stack(children: [
                    
                    FutureBuilder(future: future0,builder: (x,y) {
                    if(!y.hasData){
                      return Container();
                    }else{
                      return Center(child: SizedBox(
                        width: 690,
                        
                         child: Html(data: y.data!.toString())));
                    }
                  },),
                  Positioned(
                      bottom: 15,
                      left: 20,
                      right: 20,
                      child: SizedBox(
                        height: 40,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                    onTap: (){  
                      // see licenses
                      launch("https://pitch-hisser-5d9.notion.site/Validierung-von-Kreativit-t-durch-KI-424f86d400724c27aeab6bce77ac47ca");
                    },
                    child: Container(
                      width: 160,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: Colors.black.withAlpha(200), width: 2, style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(12),
                      
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [SizedBox(
                          height: 20,
                          width: 120,
                          child: Center(
                          child: Text(
                          "Funktionsweise",
                          style: Theme.of(context).textTheme.bodyText2!.apply(
                            color: Colors.black.withAlpha(220)
                          ),
                        )))],
                      ),
                  )),
                  GestureDetector(
                    onTap: () async{
                      
                      // open test
                      //
                      if (await windowManager.isMaximized() && await windowManager.isFullScreen()){
                        
                        Navigator.of(context).push(_createRoute());

                      }else{
                        await windowManager.maximize();
                        await windowManager.setFullScreen(true);

                        Navigator.of(context).push(_createRoute());
                      }
                    },
                    child: Container(
                      width: 160,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: Colors.black.withAlpha(240), width: 2, style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(12),
                      
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [SizedBox(
                          height: 20,
                          width: 120,
                          child: Center(
                          child: Text(
                          "Test Starten",
                          style: Theme.of(context).textTheme.bodyText2!.apply(
                            color: Colors.black.withAlpha(240)
                          ),
                        )))],
                      ),
                  ))
                        ],
                      )),
                    ),
                ])),
              ),
            )) : Container()
          ],
      ),
    );
  }

}

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => const Test(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
