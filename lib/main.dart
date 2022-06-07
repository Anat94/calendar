import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_calendar/calendar.dart';

void main() {
  runApp(new JsonData());
}

class JsonData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, routes: {
      '/': (context) => OnlineJsonData(),
    });
  }
}

class DayViewExample extends State<OnlineJsonData> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold();
  }

  Future<List<Meeting>> getDataFromWeb() async {
    var data = await http.get(Uri.parse("http://10.0.2.2:5000"));
    print(data);
    var jsonData = json.decode(data.body);

    final List<Meeting> appointmentData = [];
    for (var data in jsonData) {
      Meeting meetingData = Meeting(
          eventName: data['Subject'],
          from: _convertDateFromString(
            data['StartTime'],
          ),
          to: _convertDateFromString(data['EndTime']),
          background: (data['className'] == "chill")
              ? Colors.green
              : (data['className'] == "info")
                  ? Colors.blue
                  : (data['className'] == "pompier")
                      ? Colors.red
                      : Colors.black,
          allDay: data['AllDay']);
      appointmentData.add(meetingData);
    }
    return appointmentData;
  }

  DateTime _convertDateFromString(String date) {
    return DateTime.parse(date);
  }
}

class OnlineJsonData extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CalendarExample();
}

Future<List<Meeting>> getDataFromWeb() async {
  var data = null;
  data = await http.get(Uri.parse("http://10.0.2.2:5000"));
  print("Http req => ok");
  var jsonData = json.decode(data.body);

  final List<Meeting> appointmentData = [];
  for (var data in jsonData) {
    Meeting meetingData = Meeting(
        eventName: data['Subject'],
        from: _convertDateFromString(
          data['StartTime'],
        ),
        to: _convertDateFromString(data['EndTime']),
        background: (data['className'] == "chill")
            ? Colors.green
            : (data['className'] == "info")
                ? Colors.blue
                : (data['className'] == "pompier")
                    ? Colors.red
                    : Colors.black,
        allDay: data['AllDay']);
    appointmentData.add(meetingData);
  }
  return appointmentData;
}

Future<List<Meeting>> getDataFromWeb2() async {
  var data = null;
  data = await http.get(Uri.parse("http://10.0.2.2:5000"));
  print("Http req => ok");
  var jsonData = json.decode(data.body);

  final List<Meeting> appointmentData = [];
  for (var data in jsonData) {
    Meeting meetingData = Meeting(
        eventName: data['Subject'],
        from: _convertDateFromString(
          data['StartTime'],
        ),
        to: _convertDateFromString(data['EndTime']),
        background: (data['className'] == "chill")
            ? Colors.green
            : (data['className'] == "info")
                ? Colors.blue
                : (data['className'] == "pompier")
                    ? Colors.red
                    : Colors.black,
        allDay: data['AllDay']);
    appointmentData.add(meetingData);
  }
  return appointmentData;
}

DateTime _convertDateFromString(String date) {
  return DateTime.parse(date);
}

CalendarController _calendarController1 = CalendarController();
CalendarController _calendarController2 = CalendarController();

class CalendarExample extends State<OnlineJsonData> {
  int _selectedIndex = 0;
  List<Widget> _widgetOptions = <Widget>[
    Container(
      child: FutureBuilder(
        future: getDataFromWeb(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data != null) {
            return SafeArea(
              child: Container(
                child: SfCalendar(
                  view: CalendarView.month,
                  controller: _calendarController1,
                  monthViewSettings: MonthViewSettings(showAgenda: true),
                  firstDayOfWeek: 1,
                  showNavigationArrow: true,
                  selectionDecoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(color: Colors.red, width: 2),
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                    shape: BoxShape.rectangle,
                  ),
                  dataSource: MeetingDataSource(snapshot.data),
                ),
              ),
            );
          } else {
            // ! Faire en sorte de reessayer quand sa marche pas
            return SizedBox(
              height: (MediaQuery.of(context).size.width) / 2,
              width: (MediaQuery.of(context).size.height) / 2,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    ),
    Container(
      child: FutureBuilder(
        future: getDataFromWeb2(),
        builder: (BuildContext context2, AsyncSnapshot snapshot2) {
          if (snapshot2.data != null) {
            return SafeArea(
              child: Container(
                child: SfCalendar(
                  view: CalendarView.day,
                  // controller: _calendarController2,
                  // monthViewSettings: MonthViewSettings(showAgenda: true),
                  firstDayOfWeek: 1,
                  showNavigationArrow: true,
                  selectionDecoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(color: Colors.red, width: 2),
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                    shape: BoxShape.rectangle,
                  ),
                  dataSource: MeetingDataSource(snapshot2.data),
                ),
              ),
            );
          } else {
            // ! Faire en sorte de reessayer quand sa marche pas
            return SizedBox(
              height: (MediaQuery.of(context2).size.width) / 2,
              width: (MediaQuery.of(context2).size.height) / 2,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    ),
    Container(
      child: Card(child: Text('Hello World!')),
    )
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      // ! swipe to reload
      appBar: new AppBar(
        title: Text('Calendrier'),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Month',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_view_week),
            label: 'Week',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.today),
            label: 'Day',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].allDay;
  }
}

class Meeting {
  Meeting({this.eventName, this.from, this.to, this.background, this.allDay});

  String? eventName;
  DateTime? from;
  DateTime? to;
  Color? background;
  bool? allDay;
}
