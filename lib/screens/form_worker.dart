import 'package:flutter/material.dart';
import 'package:agenda/domain/worker.dart';
import 'package:agenda/service/app_service.dart';
import 'package:toast/toast.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

import 'home.dart';

class FormWorker extends StatefulWidget {
  final String title;
  final bool isEdit;
  final Worker data;
  final int id;

  const FormWorker(
      {Key key,
        @required this.title,
        @required this.isEdit,

        this.data
        ,

        this.id
      })
      : super(key: key);


  @override
  _FormWorkerState createState() => _FormWorkerState();
}

class _FormWorkerState extends State<FormWorker> {
  static const alarms = Worker.alarms;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  double _gap = 16.0;
  FocusNode _taskNameFocus,_lokasiFocus;
  TextEditingController _taskNameCtrl,
      _lokasiCtrl,
      _deskripsiCtrl,
      _notulensiCtrl;
  String _taskName, _lokasi, _deskripsi, _notulensi, _alarm, _waktuMulai, _waktuSelesai;
  final List<DropdownMenuItem<String>> _alarmItems = alarms
      .map((String val) => DropdownMenuItem<String>(
    value: val,
    child: Text(val.toUpperCase()),
  ))
      .toList();

  @override
  void initState() {
    super.initState();


    _taskNameFocus = FocusNode();
    _lokasiFocus = FocusNode();

    _taskNameCtrl = TextEditingController();
    _lokasiCtrl = TextEditingController();
    _deskripsiCtrl = TextEditingController();
    _notulensiCtrl = TextEditingController();

    if (
    widget.data
        != null &&
        widget.data
        is Worker && widget.isEdit) {
      setState(() {

        _taskName = widget.data.taskName;
        _waktuMulai = widget.data.waktuMulai;
        _waktuSelesai = widget.data.waktuSelesai;
        _lokasi = widget.data.lokasi;
        _alarm = widget.data.alarm;
        _deskripsi = widget.data.deskripsi;
        _notulensi = widget.data.notulensi;



        _taskNameCtrl.value = TextEditingValue(
            text: widget.data.taskName,
            selection:
            TextSelection.collapsed(offset: widget.data.taskName.length));
        _lokasiCtrl.value = TextEditingValue(
            text: widget.data.lokasi,
            selection:
            TextSelection.collapsed(offset: widget.data.lokasi.length));
        _deskripsiCtrl.value = TextEditingValue(
            text: widget.data.deskripsi,
            selection:
            TextSelection.collapsed(offset: widget.data.deskripsi.length));
        _notulensiCtrl.value = TextEditingValue(
            text: widget.data.notulensi,
            selection:
            TextSelection.collapsed(offset: widget.data.notulensi.length));

      });
    }




  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    _taskNameFocus.dispose();
    _lokasiFocus.dispose();


    super.dispose();
  }

  void _showSnackBar(message) {
    final snackBar = SnackBar(
      content: Text(message),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  handleError(e) {
    _showSnackBar('Error: ${e.toString()}');

  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);

          },
        ),
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(),
          child: Form(
            key: _formKey,
            autovalidate: _autoValidate,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                    TextFormField(
                      focusNode: _taskNameFocus,
                      controller: _taskNameCtrl,
                      textInputAction:
                      TextInputAction.next
                      ,
                      decoration: const InputDecoration(
                        labelText: 'Nama Agenda',
                      ),

                      onSaved: (String value) {
                        // will trigger when saved
                        print('onsaved taskName: $value');
                        _taskName = value;
                      },
                      onFieldSubmitted: (term) {
                        // process
                        _taskNameFocus.unfocus();
                        FocusScope.of(context)
                            .requestFocus(_lokasiFocus);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Nama agenda wajib diisi';
                        }
                        return null;
                      },
                    ),
                  SizedBox(
                    width: 5.0,
                    height: _gap,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[

                      Expanded(
                        child: Container(
                          child: DateTimeField(
                            format: DateFormat("yyyy-MM-dd HH:mm"),
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Waktu Mulai',
                            ),
                            onShowPicker: (context, currentValue) async {
                              final date = await showDatePicker(
                                  context: context,
                                  firstDate: DateTime(2000),
                                  initialDate: currentValue ?? DateTime.now(),
                                  lastDate: DateTime(2100));
                              if (date != null) {
                                final time = await showTimePicker(
                                  context: context,
                                  initialTime:
                                  TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                                );
                                _waktuMulai= DateTimeField.combine(date, time).toString();
                                return DateTimeField.combine(date, time);
                              }  else {
                                _waktuMulai = currentValue.toString();
                                return currentValue;
                              }
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                          width: 4.0,
                          height: _gap,
                      ),

                      Expanded(

                        child: Container(
                          child: DateTimeField(
                            format: DateFormat("yyyy-MM-dd HH:mm"),
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Waktu Selesai',
                            ),
                            onShowPicker: (context, currentValue) async {
                              final date = await showDatePicker(
                                  context: context,
                                  firstDate: DateTime(2000),
                                  initialDate: currentValue ?? DateTime.now(),
                                  lastDate: DateTime(2100));
                              if (date != null) {
                                final time = await showTimePicker(
                                  context: context,
                                  initialTime:
                                  TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                                );
                                 _waktuSelesai= DateTimeField.combine(date, time).toString();
                                 return DateTimeField.combine(date, time);
                              }  else {
                                _waktuSelesai = currentValue.toString();
                                return currentValue;
                              }
                            },

                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: _gap,
                  ),
                  TextFormField(
                    maxLines: 3,
                    focusNode: _lokasiFocus,
                    controller: _lokasiCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Alamat',
                    ),
                    onSaved: (String value) {
                      // will trigger when saved
                      print('onsaved _address $value');
                      _lokasi= value;
                    },
                    onFieldSubmitted: (term) {
                      // process
                    },
                  ),
                  SizedBox(
                    height: _gap,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: DropdownButton(
                      value: _alarm,
                      hint: Text('Notifikasi Alarm'),
                      items: _alarmItems,
                      isExpanded: true,
                      onChanged: (String value) {
                        setState(() {
                          _alarm = value;
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    height: _gap,
                  ),
                  TextFormField(
                    maxLines: 3,
                    controller: _deskripsiCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Deskripsi',
                    ),
                    onSaved: (String value) {
                      // will trigger when saved
                      print('onsaved _deskripsi $value');
                      _deskripsi = value;
                    },
                  ),

                  SizedBox(
                    height: _gap,
                  ),

                  TextFormField(
                    maxLines: 3,
                    controller: _notulensiCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Notulensi',
                    ),
                    onSaved: (String value) {
                      // will trigger when saved
                      print('onsaved _notulensi $value');
                      _notulensi = value;
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(

            Icons.save
            ,
            color: Colors.white,
          ),
          onPressed: () {


            final form = _formKey.currentState;
            if (form.validate()) {
              // Process data.
              if (_waktuMulai == null) {
                _showSnackBar('Waktu Mulai wajib diisi!');
              }
              else if (_waktuSelesai == null) {
                _showSnackBar('Waktu Selesai wajib diisi!');
              }
              else if (_alarm == null) {
                _showSnackBar('Alarm wajib diisi!');
              }

              else {

                form.save
                  (); // required to trigger onSaved props
                Worker _worker = Worker();
                _worker.taskName = _taskName ;
                _worker.lokasi= _lokasi;
                _worker.waktuMulai= _waktuMulai;
                _worker.waktuSelesai=_waktuSelesai;
                _worker.alarm = _alarm;
                _worker.deskripsi=_deskripsi;
                _worker.notulensi=_notulensi;

//                                print(_worker);

                if (widget.isEdit){

                  AppService.workerService.updateWorkerBy(id:widget.data.id,domain:_worker).then((val) {

                    Toast.show
                      ("Updated sukses", context);
                    Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (BuildContext context) => Home()));
                  }).catchError((onError) {
                    handleError(onError);
                  });

                }else {
                  AppService.workerService.createWorker(_worker).then((val) {

                    Toast.show
                      ("Sukses tersimpan", context);
                    Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (BuildContext context) => Home()));
                  }).catchError((onError) {
                    handleError(onError);
                  });
                }
//                                AppService.wtudentService.createWtudent(_wtudent).then((int idx) =>

//                                        .catchError(handleError)
//                                );



              }


            }else {
              setState(() {
                _autoValidate = true;
              });
            }
          }),
    );
  }
}