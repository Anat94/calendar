import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

void main() => runApp(CalendarJson());

class CalendarJson extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: 'Hello',
      home: MyAppPage(),
    );
  }
}

class MyAppPage extends StatefulWidget {
  @override
  MyAppPageState createState() => MyAppPageState();
}

class MyAppPageState extends State<MyAppPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: new AppBar(
        title: Text('Calendrier'),
      ),
      body: Center(
        child: FutureBuilder(
          builder: (context, snapshot) {
            var showData = json.decode(snapshot.data.toString());
            List<Meeting> collection = <Meeting>[];
            if (showData != null) {
              for (int i = 0; i < showData.length; i++) {
                collection.add(Meeting(
                    eventName: showData[i]['name'],
                    isAllDay: false,
                    from: DateFormat('yyyy-MM-dd HH:mm:ss').parse(showData[i]['start']),
                    to: DateFormat('yyyy-MM-dd HH:mm:ss').parse(showData[i]['end']),
                    background: (showData[i]['color'] == "red")
                        ? Colors.red
                        : (showData[i]['color'] == "green")
                        ? Colors.green
                        : (showData[i]['color'] == "blue")
                        ? Colors.blue
                        : Colors.black));
              }
            }
            return Container(
                child: SfCalendar(
                  view: CalendarView.month,
                  dataSource: _getCalendarDataSource(collection),
                  monthViewSettings: MonthViewSettings(showAgenda: true),
                  firstDayOfWeek: 1,
                  todayHighlightColor: Colors.red,
                  showNavigationArrow: true,
                  selectionDecoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(color: Colors.red, width: 2),
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                    shape: BoxShape.rectangle,
                  ),
                ));
          },
          future:
          DefaultAssetBundle.of(context).loadString("assets/appointment.json"),
        ),
      ),
    );
  }

  MeetingDataSource _getCalendarDataSource([List<Meeting>? collection]) {
    List<Meeting> meetings = collection ?? <Meeting>[];
    return MeetingDataSource(meetings);
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
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }
}

class Meeting {
  Meeting({this.eventName, this.from, this.to, this.background, this.isAllDay});

  String? eventName;
  DateTime? from;
  DateTime? to;
  Color? background;
  bool? isAllDay;
}
