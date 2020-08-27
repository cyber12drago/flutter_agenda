import 'package:agenda/domain/worker.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

// Example holidays
final Map<DateTime, List> _holidays = {
  DateTime(2020, 1, 1): ['Libur tahun baru 2020'],
  DateTime(2021, 1, 1): ['Libur tahun baru 2021'],
};


class ShowDate extends StatefulWidget {
  ShowDate({Key key, this.worker,this.workerLength}) : super(key: key);
  final List<Worker> worker;
  final int workerLength;
  _ShowDateState createState() => _ShowDateState();
}

class _ShowDateState extends State<ShowDate> with TickerProviderStateMixin {
  Map<DateTime, List> _events;
  List _selectedEvents;
  AnimationController _animationController;
  CalendarController _calendarController;
  int tahun,bulan,tanggal,differ;

  @override
  void initState() {
    super.initState();
    final _selectedDay = DateTime.now();

    _events = {
      DateTime(2020, 8, 1): ['Check A'],
      DateTime(2020, 8, 6): ['Check B'],
      DateTime(2020, 8, 14): ['Check C'],

    };
    _events[DateTime(2020, 8, 22)] = ['Check D'];
    if(_events[DateTime(2020, 8, 21)]==null) {
      _events[DateTime(2020, 8, 21)] = ['Check E'];
    }
    else {
      _events[DateTime(2020, 8, 21)].add("Check E");
    }
    print("1");
    for(int i=0;i<widget.workerLength;i++){

      tahun= int.parse(widget.worker[i].waktuMulai.substring(0,4));
      bulan= int.parse(widget.worker[i].waktuMulai.substring(5,7));
      tanggal= int.parse(widget.worker[i].waktuMulai.substring(8,10));
      differ= DateTime.parse(widget.worker[i].waktuSelesai.substring(0,10)).difference(DateTime.parse(widget.worker[i].waktuMulai.substring(0,10))).inDays;
      for(int j=0;j<=differ;j++) {

        if (_events[DateTime(tahun, bulan, tanggal+j)] == null) {
          _events[DateTime(tahun, bulan, tanggal+j)] =
          ["${widget.worker[i].taskName} (${widget.worker[i].waktuMulai.substring(11,16)}-${widget.worker[i].waktuSelesai.substring(11,16)})"];
        }
        else {
          _events[DateTime(tahun, bulan, tanggal+j)].add("${widget.worker[i].taskName} (${widget.worker[i].waktuMulai.substring(11,16)}-${widget.worker[i].waktuSelesai.substring(11,16)})");
        }

      }

    }



    _selectedEvents = _events[_selectedDay] ?? [];
    _calendarController = CalendarController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }


  void _onDaySelected(DateTime day, List events) {
    print('CALLBACK: _onDaySelected');
    setState(() {
      _selectedEvents = events;
    });
  }

  void _onVisibleDaysChanged(DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
  }

  void _onCalendarCreated(DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onCalendarCreated');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[

                       _buildTableCalendarWithBuilders(),
                      const SizedBox(height: 8.0),
                      Expanded(child: _buildEventList()),
                    ],
                  )
    );
  }

  Widget _buildTableCalendarWithBuilders() {
    return TableCalendar(
      locale: 'id_ID',
      calendarController: _calendarController,
      events: _events,
      holidays: _holidays,
      initialCalendarFormat: CalendarFormat.month,
      formatAnimation: FormatAnimation.slide,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      availableGestures: AvailableGestures.all,
      availableCalendarFormats: const {
        CalendarFormat.month: '',
        CalendarFormat.week: '',
      },
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,
        weekendStyle: TextStyle().copyWith(color: Colors.blue[800]),
        holidayStyle: TextStyle().copyWith(color: Colors.blue[800]),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekendStyle: TextStyle().copyWith(color: Colors.blue[600]),
      ),
      headerStyle: HeaderStyle(
        centerHeaderTitle: true,
        formatButtonVisible: false,
      ),
      builders: CalendarBuilders(
        selectedDayBuilder: (context, date, _) {
          return FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0).animate(_animationController),
            child: Container(
              margin: const EdgeInsets.all(4.0),
              padding: const EdgeInsets.only(top: 5.0, left: 6.0),
              color: Colors.deepOrange[300],
              width: 100,
              height: 100,
              child: Text(
                '${date.day}',
                style: TextStyle().copyWith(fontSize: 16.0),
              ),
            ),
          );
        },
        todayDayBuilder: (context, date, _) {
          return Container(
            margin: const EdgeInsets.all(4.0),
            padding: const EdgeInsets.only(top: 5.0, left: 6.0),
            color: Colors.amber[400],
            width: 100,
            height: 100,
            child: Text(
              '${date.day}',
              style: TextStyle().copyWith(fontSize: 16.0),
            ),
          );
        },
        markersBuilder: (context, date, events, holidays) {
          final children = <Widget>[];

          if (events.isNotEmpty) {
            children.add(
              Positioned(
                right: 1,
                bottom: 1,
                child: _buildEventsMarker(date, events),
              ),
            );
          }

          if (holidays.isNotEmpty) {
            children.add(
              Positioned(
                right: -2,
                top: -2,
                child: _buildHolidaysMarker(),
              ),
            );
          }

          return children;
        },
      ),
      onDaySelected: (date, events) {
        _onDaySelected(date, events);
        _animationController.forward(from: 0.0);
      },
      onVisibleDaysChanged: _onVisibleDaysChanged,
      onCalendarCreated: _onCalendarCreated,
    );
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: _calendarController.isSelected(date)
            ? Colors.brown[500]
            : _calendarController.isToday(date) ? Colors.brown[300] : Colors.blue[400],
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: TextStyle().copyWith(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }

  Widget _buildHolidaysMarker() {
    return Icon(
      Icons.add_box,
      size: 20.0,
      color: Colors.blueGrey[800],
    );
  }

  Widget _buildEventList() {
    return ListView(
      children: _selectedEvents
          .map((event) => Container(
        decoration: BoxDecoration(
          border: Border.all(width: 0.8),
          borderRadius: BorderRadius.circular(12.0),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: ListTile(
          title: Text(event.toString()),
          onTap: () => print('$event tapped!'),
        ),
      ))
          .toList(),
    );
  }

}