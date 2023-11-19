// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:jadkul/data/database.dart';

class EditClassPage extends StatefulWidget {
  const EditClassPage({super.key});

  @override
  State<EditClassPage> createState() => _EditClassPageState();
}

class _EditClassPageState extends State<EditClassPage> {
  // Database
  final _myBox = Hive.box("myBox");
  scheduleDatabase db = scheduleDatabase();

  @override
  void initState(){
    if(_myBox.get("SCHEDULEDATA") == null){
      db.createInitialData();
    } else {
      db.loadData();
      setState(() {
        Map classData = db.scheduleData[db.activeScheduleIndex]["schedule_data"][db.editPosition[0]][db.editPosition[1]];
        _fromHourValue = classData["time"][0][0];
        _fromMinuteValue = classData["time"][0][1];
        _toHourValue = classData["time"][1][0];
        _toMinuteValue = classData["time"][1][1];
        _className = classData["class_name"];
        classNameController.text = _className;
        _roomName = classData["room_name"];
        roomNameController.text = _roomName;
        _lecturersName = classData["lecturers_name"];
        lecturersNameController.text = _lecturersName.join("\n");
        _description = classData["description"];
        descriptionController.text = _description;
        _ringtoneName = classData["ringtone"];
        _ringTime = classData["ring_time"];
      });
    }
  }
  
  // TextField Controller
  TextEditingController classNameController = TextEditingController();
  TextEditingController roomNameController = TextEditingController();
  TextEditingController lecturersNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  // Variables
  // ignore: prefer_final_fields
 // Map _classData = db.scheduleData[db.activeScheduleIndex]["schedule_data"][db.editPosition[0]][db.editPosition[1]];

  Map _formData = {
    "time": [[], []],
    "ringtone": "",
    "ring_time": "",
    "class_name": "",
    "room_name": "",
    "lecturers_name": [],
    "description": ""
  };

  int _fromHourValue = 0;
  int _fromMinuteValue = 0;
  int _toHourValue = 0;
  int _toMinuteValue = 0;
  final List<String?> _ringtones =  [
      "Alarm1.mp3",
      "Alarm2.mp3",
      "Alarm3.mp3",
      "Alarm4.mp3",
      "Alarm5.mp3",
      "Alarm6.mp3",
      "Alarm7.mp3",
      "Alarm8.mp3",
      "Alarm9.mp3",
      "Alarm10.mp3",
      "Alarm11.mp3",
      "Alarm12.mp3",
      "Alarm13.mp3",
      "Alarm14.mp3",
      "Alarm15.mp3",
      "Alarm16.mp3",
      "Alarm17.mp3",
      "Alarm18.mp3",
      "Alarm19.mp3",
      "Alarm20.mp3",
      "None"
  ];
  String? _ringtoneName = "Alarm1.mp3";
  final List<String?> _ringTimes =  [
      "At class time",
      "5 minutes before class time",
      "10 minutes before class time",
      "15 minutes before class time",
      "20 minutes before class time",
      "25 minutes before class time",
      "30 minutes before class time",
      "35 minutes before class time",
      "40 minutes before class time",
      "45 minutes before class time",
      "50 minutes before class time",
      "55 minutes before class time",
      "1 hour before class time"
  ];
  String? _ringTime = "At class time";
  String _className = "";
  String _roomName = "";
  List _lecturersName = [""];
  String _description = "";

  // method
  String _getTimeValue(intTime){
    String stringVar = intTime.toString();
    String stringTime = stringVar.length < 2 ? "0" + stringVar : stringVar;
    return stringTime;
  }
  void _fromHourValueAdd(){
    if((_fromHourValue >= 0) && (_fromHourValue < 24)){
      setState(() {
        if(_fromHourValue == 23){
          _fromHourValue = 0;
        } else {
          _fromHourValue++;
        }
      });
    }
  }
  void _fromHourValueMin(){
    if((_fromHourValue >= 0) && (_fromHourValue <= 24)){
      setState(() {
        if(_fromHourValue == 0){
          _fromHourValue = 23;
        } else {
          _fromHourValue--;
        }
      });
    }
  }
  void _fromMinuteValueAdd(){
    if((_fromMinuteValue >= 0) && (_fromMinuteValue < 60)){
      setState(() {
        if(_fromMinuteValue == 59){
          _fromMinuteValue = 0;
        } else {
          _fromMinuteValue++;
        }
      });
    }
  }
  void _fromMinuteValueMin(){
    if((_fromMinuteValue >= 0) && (_fromMinuteValue <= 60)){
      setState(() {
        if(_fromMinuteValue == 0){
          _fromMinuteValue = 59;
        } else {
          _fromMinuteValue--;
        }
      });
    }
  }
  
  void _toHourValueAdd(){
    if((_toHourValue >= 0) && (_toHourValue < 24)){
      setState(() {
        if(_toHourValue == 23){
          _toHourValue = 0;
        } else {
          _toHourValue++;
        }
      });
    }
  }
  void _toHourValueMin(){
    if((_toHourValue >= 0) && (_toHourValue <= 24)){
      setState(() {
        if(_toHourValue == 0){
          _toHourValue = 23;
        } else {
          _toHourValue--;
        }
      });
    }
  }
  void _toMinuteValueAdd(){
    if((_toMinuteValue >= 0) && (_toMinuteValue < 60)){
      setState(() {
        if(_toMinuteValue == 59){
          _toMinuteValue = 0;
        } else {
          _toMinuteValue++;
        }
      });
    }
  }
  void _toMinuteValueMin(){
    if((_toMinuteValue >= 0) && (_toMinuteValue <= 60)){
      setState(() {
        if(_toMinuteValue == 0){
          _toMinuteValue = 59;
        } else {
          _toMinuteValue--;
        }
      });
    }
  }
  
  void _changeRingtone(String? ringtone){
    setState(() {
      ringtone = ringtone == null ? "None" : ringtone;
      _ringtoneName = ringtone;
    });
  }

  void _changeRingTime(String? ringTime){
    setState(() {
      ringTime = ringTime == null ? "At class time" : ringTime;
      _ringTime = ringTime;
    });
  }

  void _changeClassName(){
    setState(() {
      _className = classNameController.text;
    });
  }
  void _changeRoomName(){
    setState(() {
      _roomName = roomNameController.text;
    });
  }
  void _changeLecturersName(){
    setState(() {
      _lecturersName = lecturersNameController.text.split("\n");
    });
  }
  void _changeDescription(){
    setState(() {
      _description = descriptionController.text;
    });
  }
  void _cancellEditClass(){
    Navigator.pushNamed(context, "/mainpage");
  }
  void _saveEditClass(){
    setState(() {
      _formData["is_ring"] = (_ringtoneName == "None") ? false : true;
      _formData["time"] = [[_fromHourValue, _fromMinuteValue], [_toHourValue, _toMinuteValue]];
      _formData["ringtone"] = _ringtoneName;
      _formData["ring_time"] = _ringTime;
      _formData["class_name"] = _className;
      _formData["room_name"] = _roomName;
      _formData["lecturers_name"] = _lecturersName;
      _formData["description"] = _description;

      db.scheduleData[db.activeScheduleIndex]["schedule_data"][db.editPosition[0]][db.editPosition[1]] = _formData;
      db.updateDatabase();
      Navigator.pushNamed(context, "/mainpage");
    });
  }
  void _deleteClass(){
    List scheduleData = db.scheduleData[db.activeScheduleIndex]["schedule_data"][db.editPosition[0]];
    scheduleData.removeAt(db.editPosition[1]);
    db.scheduleData[db.activeScheduleIndex]["schedule_data"][db.editPosition[0]] = scheduleData;
    db.updateDatabase();
    Navigator.pushNamed(context, "/mainpage");
  }

  // Widgets 
  Widget _fromTimeInput(){
    return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "From",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Europa',
                  fontSize: 20,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Container(
                        child: Transform(
                          transform: Matrix4.translationValues(0, 8.0, 0.0),
                          child: GestureDetector(
                            onTap: _fromHourValueAdd,
                            child: Icon(
                              Icons.arrow_drop_up,
                              color: const Color.fromARGB(100, 255, 255, 255),
                              size: 50,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 75,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Color(0xFF17133B),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            _getTimeValue(_fromHourValue),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontFamily: 'Europa',
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: Transform(
                          transform: Matrix4.translationValues(0, -8.0, 0.0),
                          child: GestureDetector(
                            onTap: _fromHourValueMin,
                            child: Icon(
                              Icons.arrow_drop_down,
                              color: const Color.fromARGB(100, 255, 255, 255),
                              size: 50,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      ":",
                      style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Europa',
                              fontWeight: FontWeight.w700,
                              fontSize: 30
                      ),
                    )
                  ),
                  Column(
                    children: [
                      Container(
                        child: Transform(
                          transform: Matrix4.translationValues(0, 8.0, 0.0),
                          child: GestureDetector(
                            onTap: _fromMinuteValueAdd,
                            child: Icon(
                              Icons.arrow_drop_up,
                              color: const Color.fromARGB(100, 255, 255, 255),
                              size: 50,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 75,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Color(0xFF17133B),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            _getTimeValue(_fromMinuteValue),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontFamily: 'Europa',
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: Transform(
                          transform: Matrix4.translationValues(0, -8.0, 0.0),
                          child: GestureDetector(
                            onTap: _fromMinuteValueMin,
                            child: Icon(
                              Icons.arrow_drop_down,
                              color: const Color.fromARGB(100, 255, 255, 255),
                              size: 50,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          );
  }
  
  Widget _toTimeInput(){
    return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "To",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Europa',
                  fontSize: 20,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Container(
                        child: Transform(
                          transform: Matrix4.translationValues(0, 8.0, 0.0),
                          child: GestureDetector(
                            onTap: _toHourValueAdd,
                            child: Icon(
                              Icons.arrow_drop_up,
                              color: const Color.fromARGB(100, 255, 255, 255),
                              size: 50,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 75,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Color(0xFF17133B),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            _getTimeValue(_toHourValue),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontFamily: 'Europa',
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: Transform(
                          transform: Matrix4.translationValues(0, -8.0, 0.0),
                          child: GestureDetector(
                            onTap: _toHourValueMin,
                            child: Icon(
                              Icons.arrow_drop_down,
                              color: const Color.fromARGB(100, 255, 255, 255),
                              size: 50,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      ":",
                      style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Europa',
                              fontWeight: FontWeight.w700,
                              fontSize: 30
                      ),
                    )
                  ),
                  Column(
                    children: [
                      Container(
                        child: Transform(
                          transform: Matrix4.translationValues(0, 8.0, 0.0),
                          child: GestureDetector(
                            onTap: _toMinuteValueAdd,
                            child: Icon(
                              Icons.arrow_drop_up,
                              color: const Color.fromARGB(100, 255, 255, 255),
                              size: 50,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 75,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Color(0xFF17133B),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            _getTimeValue(_toMinuteValue),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontFamily: 'Europa',
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: Transform(
                          transform: Matrix4.translationValues(0, -8.0, 0.0),
                          child: GestureDetector(
                            onTap: _toMinuteValueMin,
                            child: Icon(
                              Icons.arrow_drop_down,
                              color: const Color.fromARGB(100, 255, 255, 255),
                              size: 50,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          );
  }
  
  Widget _ringtoneInput(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
          Text(
              "Ringtone",
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Europa',
                fontSize: 18
              ),
            ),
          SizedBox(height: 10),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Color(0xFF17133B)
            ),
            child: DropdownButton<String?>(
                    dropdownColor: Color(0xFF17133B),
                    padding: EdgeInsets.symmetric(horizontal: 18),
                    isExpanded: true,
                    underline: SizedBox(),
                    value: _ringtoneName,
                    onChanged: _changeRingtone,
                    items: _ringtones.map<DropdownMenuItem<String?>>((ringtone){
                      return DropdownMenuItem(
                        value: ringtone,
                        child: Text(
                          ringtone.toString(),
                          style: TextStyle(
                            color: Colors.white,
                          fontFamily: 'Europa',
                          ),
                        ),
                      );
                    }).toList(),
            ),
          )
      ],
    );
  }

  Widget _ringTimeInput(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
          Text(
              "Ring Time",
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Europa',
                fontSize: 18
              ),
            ),
          SizedBox(height: 10),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Color(0xFF17133B)
            ),
            child: DropdownButton<String?>(
                    dropdownColor: Color(0xFF17133B),
                    padding: EdgeInsets.symmetric(horizontal: 18),
                    isExpanded: true,
                    underline: SizedBox(),
                    value: _ringTime,
                    onChanged: _changeRingTime,
                    items: _ringTimes.map<DropdownMenuItem<String?>>((ringTime){
                      return DropdownMenuItem(
                        value: ringTime,
                        child: Text(
                          ringTime.toString(),
                          style: TextStyle(
                            color: Colors.white,
                          fontFamily: 'Europa',
                          ),
                        ),
                      );
                    }).toList(),
            ),
          )
      ],
    );
  }

  Widget _classNameInput(){
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Class name",
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Europa',
              fontSize: 18
            ),
          ),
          SizedBox(height: 10),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Color(0xFF17133B)
            ),
            child: TextField(
              controller: classNameController,
              onChanged: (context) => _changeClassName(),
              style: TextStyle(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 18),
                hintText: "Class name...",
                hintStyle: TextStyle(
                  color: Color.fromARGB(50, 255, 255, 255)
                )
              ),
            ),
          )
        ],
      );
  }

  Widget _RoomNameInput(){
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Room name",
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Europa',
              fontSize: 18
            ),
          ),
          SizedBox(height: 10),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Color(0xFF17133B)
            ),
            child: TextField(
              controller: roomNameController,
              onChanged: (context) => _changeRoomName(),
              style: TextStyle(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 18),
                hintText: "Room name...",
                hintStyle: TextStyle(
                  color: Color.fromARGB(50, 255, 255, 255)
                )
              ),
            ),
          )
        ],
      );
  }

   Widget _LecturersNameInput(){
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Lecturers name",
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Europa',
              fontSize: 18
            ),
          ),
          SizedBox(height: 10),
          Container(
            alignment: Alignment.topCenter,
            height: 110,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Color(0xFF17133B)
            ),
            child: TextField(
              controller: lecturersNameController,
              onChanged: (context) => _changeLecturersName(),
              keyboardType: TextInputType.multiline,
              maxLines: null,
              style: TextStyle(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                hintText: "Lecturers name...",
                hintStyle: TextStyle(
                  color: Color.fromARGB(50, 255, 255, 255)
                )
              ),
            ),
          )
        ],
      );
    }

    Widget _DescriptionInput(){
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Description",
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Europa',
              fontSize: 18
            ),
          ),
          SizedBox(height: 10),
          Container(
            alignment: Alignment.topCenter,
            height: 110,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Color(0xFF17133B)
            ),
            child: TextField(
              controller: descriptionController,
              onChanged: (context) => _changeDescription(),
              keyboardType: TextInputType.multiline,
              maxLines: null,
              style: TextStyle(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                hintText: "Description...",
                hintStyle: TextStyle(
                  color: Color.fromARGB(50, 255, 255, 255)
                )
              ),
            ),
          )
        ],
      );
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          GestureDetector(
            onTap: _deleteClass,
            child: Container(
              padding: EdgeInsets.only(right: 25),
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
        backgroundColor: Colors.transparent,
        title: Text(
            "Edit Class",
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Europa',
            ),
          ),
      ),
      backgroundColor: Color(0XFF03001C),
      body: Container(
        height: double.infinity,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: 25,
            vertical: 50,
          ),
          child: Column(
            children: [
              _fromTimeInput(),
              _toTimeInput(),
              SizedBox(height:20),
              _ringtoneInput(),
              SizedBox(height:20),
              _ringTimeInput(),
              SizedBox(height:20),
              _classNameInput(),
              SizedBox(height:20),
              _RoomNameInput(),
              SizedBox(height:20),
              _LecturersNameInput(),
              SizedBox(height:20),
              _DescriptionInput(),
              SizedBox(height:35),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _cancellEditClass,
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      minimumSize: Size(110, 42),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                      )
                    ),
                    child: Text(
                       "Cancel",
                       style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Europa',
                        fontSize: 18
                       ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _saveEditClass,
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Color(0xFFE74646),
                      minimumSize: Size(110, 42),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                      )
                    ),
                    child: Text(
                       "Save",
                       style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Europa',
                        fontSize: 18
                       ),
                    ),
                  ),
                ],
              ),
              SizedBox(height:25),
            ],
          ),
        ),
      ),
    );
  }
}