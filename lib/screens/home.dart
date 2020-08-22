import 'package:agenda/screens/show_date.dart';
import 'package:flutter/material.dart';
import 'package:agenda/domain/worker.dart';
import 'package:agenda/screens/form_worker.dart';
import 'package:agenda/screens/detail_worker.dart';
import 'package:agenda/service/app_service.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  String _searchCriteria = '';
  bool _showTextField = false;
  List<Worker> _workers = [];
  bool _shouldWidgetUpdate = true;
  int _selectedIndex = 0;


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

//  String email = "", nama = "";
//  TabController tabController;

  _fetchData() {
    if (!_shouldWidgetUpdate) {
      return Future.value(_workers);
    }

    return AppService.workerService.findAllWorkers(_searchCriteria);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: _showTextField
            ? TextField(
          // expands: true,
          decoration: InputDecoration(
            hintText: 'Cari Agenda',
            fillColor: Colors.white,
            filled: true,

          ),
          autofocus: true,
          onSubmitted: (value) {
            setState(() {
              _searchCriteria = value;
              _shouldWidgetUpdate = true;
            });
          },
        )
            : Center(child: Text('List Agenda')),
        actions: <Widget>[
          IconButton(

              icon: _showTextField ? Icon(Icons.close) : Icon(Icons.search),
              onPressed: () {
                setState(() {
                  _showTextField = !_showTextField;
                  _shouldWidgetUpdate = false;
                });
              }),

        ],
      ),

      body: FutureBuilder<List<Worker>>(
          future: _fetchData(),
          initialData: <Worker>[],
          builder: (context, snapshot) {
            if (_shouldWidgetUpdate) {
              if ((snapshot.connectionState == ConnectionState.none &&
                  snapshot.hasData == null) ||
                  snapshot.connectionState == ConnectionState.waiting) {
                // print('project snapshot data is: ${snapshot.data}');
                return LinearProgressIndicator();
              } else if (snapshot.hasData && snapshot.data.length == 0) {
                _workers = snapshot.data;
                return Container();
              }
            }
            //  print('snapshot.data.length ${snapshot.data.length}');
            if (_selectedIndex == 0 || _selectedIndex == 2) {
              return ListView.separated(
                itemCount: snapshot.hasData ? snapshot.data.length : 0,
                separatorBuilder: (BuildContext context, int i) =>
                    Divider(
                      color: Colors.grey[400],
                    ),
                itemBuilder: (BuildContext context, int i) {
                  _workers = snapshot.data;
                  final Worker worker = _workers[i];
                  return ListTile(
                    key: ValueKey(worker.id),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  DetailWorker(
                                    id: worker.id,
                                    key: ValueKey(worker.id),
                                  )));
                    },
                    title: Text("user A"),
                    subtitle: Text(
                        "${worker.taskName}\n${worker.waktuMulai.substring(
                            0, 16)}-${worker.waktuSelesai.substring(0, 16)}"),
                  );
                },
              );
            }
            else if (_selectedIndex == 1) {
              return ShowDate();
            }
          }),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.format_list_bulleted),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            title: Text('Business'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mail),
            title: Text('School'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () async {
          _shouldWidgetUpdate = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    FormWorker(
                      title: 'Buat Agenda',
                      isEdit: false,
                    )),
          ) ??
              true;
        },
      ),
    );
  }
}
