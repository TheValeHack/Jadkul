// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_field, prefer_final_fields

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:jadkul/data/database.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // Hive box
  final _myBox = Hive.box("myBox");
  scheduleDatabase db = scheduleDatabase();

  @override
  void initState(){
    if(_myBox.get("SCHEDULEDATA") == null){
      db.scheduleData[db.activeScheduleIndex]["schedule_data"][_activeDayIndex].sort(
  (a, b) => a['time'][0][0].compareTo(b['time'][0][0]) as int
);
      db.createInitialData();
      
    } else {
      db.loadData();
    }
  }

  // Date
  DateTime _currentDate = DateTime.now();
  DateTime _mondayDate = DateTime.now().subtract(Duration(days: (DateTime.now().weekday - 1)));
  List<List<DateTime>> _weekList = List.generate(7, (index) {
      return [DateTime.now().subtract(Duration(days: (DateTime.now().weekday - 1))).add(Duration(days: index)), DateTime.now().subtract(Duration(days: (DateTime.now().weekday - 1))).add(Duration(days: index + 1))];
    });

  // Variables
  int _activeDayIndex = (DateTime.now().weekday) - 1;
  List _dayName = [
    "Mon",
    "Tue",
    "Wed",
    "Thu",
    "Fri",
    "Sat",
    "Sun"
  ];
  bool _isActive = true;

  // Widget
  Widget _dayBox(String day, String date, double boxWidth, bool active, int index){
    return Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          //color: Color(0xFF17133B),
          width: boxWidth,
          child: Column(
            children: [
              GestureDetector(
                onTap: () => _changeCurrentDay(index),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: active == true ? Color(0xFFE74646) : Color(0xFF17133B),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      date,
                      style: TextStyle(
                        color: active == true ? Colors.white : Color.fromARGB(100, 255, 255, 255),
                        fontFamily: 'Europa',
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                day,
                style: TextStyle(
                  color: active == true ? Colors.white : Color.fromARGB(130, 255, 255, 255),
                  fontFamily: 'Europa',
                ),
              ),
            ],
          ),
        );
  }


  Widget _classBox(List time, String ringtone, String ringTime, String className, String roomName, List lecturersName, String description, bool isRing, int scheduleIndex, int dayIndex, int classIndex){
    String stringTime(List intTime){
       List stringedTime = intTime.map((e){
          String hour = e[0].toString().length < 2 ? "0"+e[0].toString() : e[0].toString();
          String minute = e[1].toString().length < 2 ? "0"+e[1].toString() : e[1].toString();
          String stringsTime = hour + ":" + minute;

          return stringsTime;
       }).toList();

       return stringedTime[0] + " - " + stringedTime[1];
    }
    List getRingTime(){
      if(ringTime == "At class time"){
        return time[0];
      } else{
        int beforeTime = int.parse(ringTime.substring(0, 2).trim());
        beforeTime = beforeTime == 1 ? 60 : beforeTime;

        int totalMinutes = (time[0][0] * 60) + ( time[0][1]);

        totalMinutes -= beforeTime;

        int updatedHour = totalMinutes ~/ 60;
        int updatedMinute = totalMinutes % 60;

        List<int> updatedTime = [updatedHour, updatedMinute];

        return updatedTime;
      }
    }
    String getTimeRemained(DateTime currentTime, DateTime ringTime){
      int daysDifference = ringTime.day - currentTime.day;
      int ringTotalMinutes = ringTime.hour * 60 + ringTime.minute;
      int currentTotalMinutes = currentTime.hour * 60 + currentTime.minute;
      int minutesDifference = ringTotalMinutes - currentTotalMinutes + (daysDifference * 1440);
      int hours = minutesDifference ~/ 60;
      int minutes = minutesDifference % 60;

      String result = 'Rings in $hours hour${hours != 1 ? 's' : ''} and $minutes minute${minutes != 1 ? 's' : ''}';
      
      return result;
    }
    List newRingTime = getRingTime();
    DateTime ringtoneDateTime = DateTime(
          _weekList[dayIndex][0].year,
          _weekList[dayIndex][0].month,
          _weekList[dayIndex][0].day < _currentDate.day ? _weekList[dayIndex][0].day + 7 : _weekList[dayIndex][0].day,
          newRingTime[0],
          newRingTime[1],
          _weekList[dayIndex][0].second,
          _weekList[dayIndex][0].millisecond,
          _weekList[dayIndex][0].microsecond,
    );

    return GestureDetector(
      onTap: (){
        List editPosition = [dayIndex, classIndex];
        db.editPosition = editPosition;
        db.updateDatabase();
        Navigator.pushNamed(context, "/editclasspage");
      },
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
          constraints: BoxConstraints(
            minHeight: 200,
          ),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Color(0xFF17133B),
            borderRadius: BorderRadius.circular(20)
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                          Icons.access_time,
                          color: Color.fromARGB(160, 255, 255, 255), 
                          size: 15
                        ),
                        SizedBox(width: 5,),
                        Text(
                          stringTime(time),
                          style: TextStyle(
                            color: Color.fromARGB(160, 255, 255, 255),
                            fontFamily: 'Europa',
                            fontSize: 17
                          ),
                        ),
                    ],
                  ),
                  Switch(
                    value: isRing,
                    onChanged: (value){
                      setState(() {
                        db.scheduleData[scheduleIndex]["schedule_data"][dayIndex][classIndex]["is_ring"] = value;
                      });
                    },
                  )
                ],
              ),
              Text(
                className,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Europa',
                  fontSize: 24,
                ),
              ),
        
              SizedBox(height: 10,),
              Row(
                children: [
                  Icon(
                        Icons.access_alarm,
                        color: Color.fromARGB(160, 255, 255, 255), 
                        size: 15
                  ),
                  SizedBox(width: 8,),
                  Text(
                    getTimeRemained(_currentDate, ringtoneDateTime),
                    style: TextStyle(
                      color: Color.fromARGB(160, 255, 255, 255),
                      fontFamily: 'Europa',
                      fontSize: 15
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5,),
              Row(
                children: [
                  Icon(
                        Icons.place,
                        color: Color.fromARGB(160, 255, 255, 255), 
                        size: 15
                  ),
                  SizedBox(width: 8,),
                  Text(
                    roomName,
                    style: TextStyle(
                      color: Color.fromARGB(160, 255, 255, 255),
                      fontFamily: 'Europa',
                      fontSize: 15
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5,),
              Row(
                children: [
                  Icon(
                        Icons.face,
                        color: Color.fromARGB(160, 255, 255, 255), 
                        size: 15
                  ),
                  SizedBox(width: 8,),
                  Text(
                    "Lecturers :",
                    style: TextStyle(
                      color: Color.fromARGB(160, 255, 255, 255),
                      fontFamily: 'Europa',
                      fontSize: 15
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5,),
              Container(
                padding: EdgeInsets.only(left: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: lecturersName.map((lecturer){
                    return Text(
                        "-   " + lecturer.trim(),
                        style: TextStyle(
                          color: Color.fromARGB(160, 255, 255, 255),
                          fontFamily: 'Europa',
                          fontSize: 13
                        ),
                      );
                  }).toList(),
                ),
              ),
              SizedBox(height: 5,),
              Row(
                children: [
                  Icon(
                        Icons.description,
                        color: Color.fromARGB(160, 255, 255, 255), 
                        size: 15
                  ),
                  SizedBox(width: 8,),
                  Text(
                    "Description : ",
                    style: TextStyle(
                      color: Color.fromARGB(160, 255, 255, 255),
                      fontFamily: 'Europa',
                      fontSize: 15
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5,),
              Container(
                padding: EdgeInsets.only(left: 18),
                child: Text(
                  description.length > 0 ? description : "No description.",
                  style: TextStyle(
                    color: Color.fromARGB(160, 255, 255, 255),
                    fontFamily: 'Europa',
                    fontSize: 13
                  ),
                ),
              ),
            ],
          ),
        ),
    );
  }
  Widget _scheduleList(String name, int value, bool active){
    return ListTile(
        title: Text(
          name,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: active == true? Colors.white : Color.fromARGB(100, 255, 255, 255),
            fontFamily: 'Europa',
          ),
        ),
        onTap: () => _changeCurrentSchedule(value),
      );
  }


  // Method
  void _addButtonAction(){
    showDialog(context: context, builder: (context){
      return AlertDialog(
        contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
        ),
        backgroundColor: Color(0xFF17133B),
        content: Container(
          padding: EdgeInsets.symmetric(horizontal: 0),
          height: 120,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ListTile(
                onTap: (){
                  Navigator.pop(context);
                  Navigator.pushNamed(context, "/addclasspage");
                },
                shape: Border(
                  bottom: BorderSide(
                    color: Color.fromARGB(85, 255, 255, 255)
                  )
                ),
                title: Text(
                  "Add new class",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Europa',
                    fontSize: 18
                  ),
                ),
              ),
              ListTile(
                onTap: (){
                  Navigator.pop(context);
                  Navigator.pushNamed(context, "/addschedulepage");
                },
                title: Text(
                  "Add new schedule",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Europa',
                    fontSize: 18
                  ),
                ),
              )
            ],
          ),
        ),
      );
    });
  }
  void _changeCurrentDay(int index){
    setState(() {
      _activeDayIndex = index;
      db.activeDayIndex = index;
      db.scheduleData[db.activeScheduleIndex]["schedule_data"][_activeDayIndex].sort(
  (a, b) => a['time'][0][0].compareTo(b['time'][0][0]) as int
);
      db.updateDatabase();
    });
  }
  void _changeCurrentSchedule(int index){
    setState(() {
      db.activeScheduleIndex = index;
      _activeDayIndex = _currentDate.weekday - 1;
      db.updateDatabase();
    });
  }
  void _deleteSchedule(){
    db.scheduleData.removeAt(db.activeScheduleIndex);
    db.activeScheduleIndex = db.activeScheduleIndex -1;
    db.updateDatabase();
    Navigator.pushNamed(context, "/mainpage");
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double screenWidth = size.width;
    double screenHeight = size.height;

    return Scaffold(
      appBar: AppBar(
        actions: [
          db.activeScheduleIndex == 0 ? SizedBox() : GestureDetector(
            onTap: _deleteSchedule,
            child: Container(
              padding: EdgeInsets.only(right: 20),
              child: Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
          )
        ],
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        title: Text(
            db.scheduleData[db.activeScheduleIndex]["schedule_name"],
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Europa',
            ),
          ),
        backgroundColor: Colors.transparent,
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(1000)
        ),
        backgroundColor: Color(0xFFE74646),
        onPressed: _addButtonAction,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      backgroundColor: Color(0XFF03001C),
      drawer: Drawer(
        backgroundColor: Color.fromARGB(255, 13, 6, 61),
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color.fromARGB(85, 255, 255, 255)
                  )
                )
              ),
              child: Text(
                  "Schedules List",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Europa',
                    fontWeight: FontWeight.w700,
                    fontSize: 22
                  ),
              )
            ),
            SizedBox(height: 10,),
            ...db.scheduleData.asMap().entries.map((entry){
              int index = entry.key;
              Map schedule =  entry.value;
              bool active = db.activeScheduleIndex == index ? true : false;
              return _scheduleList(schedule["schedule_name"], index, active);
            }).toList()
          ],
        ),
      ),
      body: Container(
        height: double.infinity,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.only(left: 25, right: 25, top: 20, bottom: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // _dayBox("Sen", "21", (screenWidth-80)/7, true)
                children: _dayName.asMap().entries.map((entry){
                    int index = entry.key;
                    String day = entry.value;
                    int dayDate = _mondayDate.day + index;
                    bool active = _activeDayIndex == index ? true : false;

                    if(_activeDayIndex == index){
                        db.activeDayIndex = index;
                        db.updateDatabase();
                    }

                    return _dayBox(day, dayDate.toString(), (screenWidth-80)/7, active, index);
                }).toList(),
              ),
              SizedBox(height: 15),
              Container(
                child: Text(
                  "Upcoming classes",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Europa',
                    fontSize: 17
                  ),
                ),
              ),
              SizedBox(height: 25),
              //   Widget _classBox(List time, String ringtone, String ringTime, String className, String roomName, List lecturersName, String description, bool isRing, int scheduleIndex, int dayIndex, int classIndex){
              if(db.scheduleData[db.activeScheduleIndex]["schedule_data"][_activeDayIndex].length > 0) ...db.scheduleData[db.activeScheduleIndex]["schedule_data"][_activeDayIndex].asMap().entries.map((entry){
                int index = entry.key;
                Map data = entry.value;

                return Column(
                  children: [
                    _classBox(data["time"], data["ringtone"], data["ring_time"], data["class_name"], data["room_name"], data["lecturers_name"], data["description"], data["is_ring"], db.activeScheduleIndex, _activeDayIndex, index),
                    SizedBox(height: 25,)
                  ],
                );
              }).toList() else if(db.scheduleData[db.activeScheduleIndex]["schedule_data"][_activeDayIndex].length < 1) ...[
                Container(
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                        "There is no class today. Happy sleeping!",
                          style: TextStyle(
                          color: Color.fromARGB(100, 255, 255, 255),
                          fontFamily: 'Europa',
                          fontSize: 17
                        ),
                      )
                      ],
                      
                    ),
                  ),
                )
              ]
            ],
          ),
        ),        
      ),
    );
  }
}