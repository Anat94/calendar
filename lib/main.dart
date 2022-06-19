import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_calendar/calendar.dart';

const EPILINK =
    "https://intra.epitech.eu/auth-946e2bf8910dc415d92d10145bdf4f3b33dcabe2";

void main() {
  runApp(new JsonData());
}

Future<Album> fetchAlbum() async {
  final response = await http.get(Uri.parse('$EPILINK/user?format=json'));

  if (response.statusCode == 200) {
    print("JE RENTRE");
    return Album.fromJson(jsonDecode(response.body));
  } else {
    print("JE PETE");
    throw Exception('Failed to load album');
  }
}

class Album {
  final String gpa;
  final String email;
  final String title;
  final String image;
  final String city;
  final String scolaryear;
  final int promo;
  final int credits;

  Album({
    required this.gpa,
    required this.email,
    required this.title,
    required this.image,
    required this.city,
    required this.scolaryear,
    required this.promo,
    required this.credits,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      gpa: json['gpa'][0]['gpa'],
      email: json['internal_email'],
      title: json['title'],
      image: json['picture'],
      city: json['groups'][0]['name'],
      scolaryear: json['scolaryear'],
      promo: json['promo'] as int,
      credits: json['credits'] as int,
    );
  }
}

class JsonData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => OnlineJsonData(),
      },
    );
  }
}

class OnlineJsonData extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CalendarExample();
}

Future<List<Meeting>> getDataFromWeb() async {
  var data =
      await http.get(Uri.parse("https://calendar-node-js.herokuapp.com/"));
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
  var data =
      await http.get(Uri.parse("https://calendar-node-js.herokuapp.com/"));
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

Future<List<Meeting>> getDataFromWeb3() async {
  var data = null;
  data = await http.get(Uri.parse("https://calendar-node-js.herokuapp.com/"));
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

class CalendarExample extends State<OnlineJsonData> {
  late Future<Album> futureAlbum;
  int _selectedIndex = 0;
  List<Widget> _widgetOptions = <Widget>[
    Container(
      child: FutureBuilder(
        future: getDataFromWeb(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          // retry:
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
            getDataFromWeb();
            // ! Faire en sorte de reessayer quand sa marche pas
            // if (snapshot.data != null) break retry;
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
                  view: CalendarView.week,
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
    Center()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text('Calendrier'),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.account_circle_sharp),
              tooltip: 'Voir mes infos',
              onPressed: () {
                Navigator.push(context, MaterialPageRoute<void>(
                  builder: (BuildContext context) {
                    return Scaffold(
                        appBar: AppBar(
                          title: const Text('Informations :'),
                        ),
                        body: SafeArea(
                          child: Column(
                            children: [
                              FutureBuilder<Album>(
                                future: fetchAlbum(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return Column(children: [
                                      Container(
                                        width: double.infinity,
                                        height: 150,
                                        child: Container(
                                          alignment: Alignment(0.0, 2.5),
                                          child: CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                "$EPILINK${snapshot.data!.image}"),
                                            radius: 60.0,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 60,
                                      ),
                                      Text(
                                        '${snapshot.data!.title}',
                                        style: TextStyle(
                                            fontSize: 25.0,
                                            color: Colors.blueGrey,
                                            letterSpacing: 2.0,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "${snapshot.data!.email}",
                                        style: TextStyle(
                                            fontSize: 15.0,
                                            color: Colors.black45,
                                            letterSpacing: 2.0,
                                            fontWeight: FontWeight.w300),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Card(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 20.0, vertical: 8.0),
                                          elevation: 2.0,
                                          child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 12, horizontal: 30),
                                              child: Text(
                                                "${snapshot.data!.city}"
                                                        .toUpperCase() +
                                                    " (${snapshot.data!.scolaryear} - ${snapshot.data!.promo})",
                                                // - (2021 - 2026)",
                                                style: TextStyle(
                                                    letterSpacing: 2.0,
                                                    fontWeight:
                                                        FontWeight.w300),
                                              ))),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Card(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 20.0, vertical: 8.0),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      "GPA :",
                                                      style: TextStyle(
                                                          color:
                                                              Colors.blueAccent,
                                                          fontSize: 22.0,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                    SizedBox(
                                                      height: 7,
                                                    ),
                                                    Text(
                                                      '${snapshot.data!.gpa}',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 22.0,
                                                          fontWeight:
                                                              FontWeight.w300),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      "Crédits",
                                                      style: TextStyle(
                                                          color:
                                                              Colors.blueAccent,
                                                          fontSize: 22.0,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                    SizedBox(
                                                      height: 7,
                                                    ),
                                                    Text(
                                                      '${snapshot.data!.credits}',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 22.0,
                                                          fontWeight:
                                                              FontWeight.w300),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 50,
                                      ),
                                    ]);
                                  } else {
                                    return SizedBox(
                                      height:
                                          (MediaQuery.of(context).size.width) /
                                              2,
                                      width:
                                          (MediaQuery.of(context).size.height) /
                                              2,
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ));
                  },
                ));
              }),
        ],
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
