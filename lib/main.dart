import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:agenda/screens/form_login.dart';
import 'package:agenda/service/app_service.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:agenda/util/lifecycle_event_handler.dart';

void main(){
  initializeDateFormatting().then((_) => runApp(MyApp()));
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppstate createState() => _MyAppstate();
}

class _MyAppstate extends State<MyApp> {
  bool databaseIsReady = false;
  LifecycleEventHandler _lifecycleEventHandler;

  @override
  void initState() {
    super.initState();
    AppService.open().then((database) {
      setState(() {
        databaseIsReady = true;
      });
    });
    _lifecycleEventHandler = LifecycleEventHandler(onResume: (state) async {
      return AppService.open().then((database) {
        setState(() {
          databaseIsReady = true;
        });

        return databaseIsReady;
      });
    }, onSuspend: (state) async {
      return AppService.close().then((val) {
        setState(() {
          databaseIsReady = false;
        });

        return databaseIsReady;
      });
    });
    WidgetsBinding.instance.addObserver(_lifecycleEventHandler);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(_lifecycleEventHandler);
    AppService.close().then((val) {
      setState(() {
        databaseIsReady = false;
      });
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('databaseIs ready? $databaseIsReady');
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sekolahku',
      theme: ThemeData(
        // primarySwatch:
        primaryColor: const Color(0xff203878),
        accentColor: const Color(0xfff8c018),
      ),
      home: databaseIsReady
          ? FormLogin()
          : Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}