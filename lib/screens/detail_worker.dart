import 'package:agenda/screens/form_worker.dart';
import 'package:flutter/material.dart';
import 'package:agenda/domain/worker.dart';
import 'package:agenda/service/app_service.dart';
import 'package:agenda/util/capitalize.dart';
import 'package:toast/toast.dart';

import 'home.dart';

class DetailWorker extends StatefulWidget {
  final int id;

  const DetailWorker({Key key, @required this.id}) : super(key: key);

  @override
  _DetailWorkerState createState() => _DetailWorkerState();
}

class _DetailWorkerState extends State<DetailWorker> {
  Worker worker;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    //  _student = AppService.studentService.findStudentBy(index: 1);
  }
  handleError(e) {

    _showSnackBar('Error: ${e.toString()}');

  }

  void _showSnackBar(message) {
    final snackBar = SnackBar(
      content: Text(message),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Detail Agenda'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => FormWorker(title: 'Agenda Baru',
                  isEdit:true, data: worker, id: worker.id

              )));
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              AppService.workerService.deleteWorkerBy(id:widget.id).then((val){

                Toast.show
                  ("Data berhasil di hapus", context);

                Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (BuildContext context) => Home()));

              }).catchError((onError){
                handleError(onError);
              });
            },
          ),
        ],
      ),
      body: Center(
          child: FutureBuilder<Worker>(
              future: AppService.workerService.findWorkerBy(id: widget.id),
              builder: (context, snapshot) {
                print(
                    'snapshot ${snapshot.connectionState} data: ${snapshot.data.taskName}');
                if (snapshot.connectionState == ConnectionState.none &&
                    snapshot.hasData == null) {
                  return LinearProgressIndicator();
                }
                worker = snapshot.data;
                return ListView(
                  children: <Widget>[
                    ListTile(

                      leading: Icon(Icons.account_box),
                      title: Text(worker.taskName),
                      subtitle: const Text('Nama Agenda'),
                    ),
                    ListTile(
                      leading: Icon(Icons.access_time),
                      title: Text(worker.waktuMulai.substring(0,16)),
                      subtitle: const Text('Waktu Mulai'),
                    ),
                    ListTile(
                      leading: Icon(Icons.access_time),
                      title: Text(capitalize(worker.waktuSelesai.substring(0,16))),
                      subtitle: const Text('Waktu Selesai'),
                    ),
                    ListTile(
                      leading: Icon(Icons.access_alarm),
                      title: Text(worker.alarm.toUpperCase()),
                      subtitle: const Text('Alarm Notifikasi'),
                    ),
                    ListTile(
                      leading: Icon(Icons.location_on),
                      title: Text(worker.lokasi),
                      subtitle: const Text('Lokasi'),
                    ),
                    ListTile(
                      leading: Icon(Icons.note),
                      title: Text(worker.deskripsi),
                      subtitle: const Text('Deskripsi'),
                    ),
                    ListTile(
                      leading: Icon(Icons.event_note),
                      title: Text(worker.notulensi),
                      subtitle: const Text('Notulensi'),
                    ),
                  ],
                );
              })),
    );
  }
}