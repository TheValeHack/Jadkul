// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:hive/hive.dart';
import 'package:jadkul/data/database.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';


class AddSchedulePage extends StatefulWidget {
  const AddSchedulePage({super.key});

  @override
  State<AddSchedulePage> createState() => _AddSchedulePageState();
}

class _AddSchedulePageState extends State<AddSchedulePage> {
  // Hive box
  final _myBox = Hive.box("myBox");
  scheduleDatabase db = scheduleDatabase();

  @override
  void initState(){
    if(_myBox.get("SCHEDULEDATA") == null){
      db.createInitialData();
    } else {
      db.loadData();
    }
  }
  
  // TextField Controller
  TextEditingController scheduleNameController = TextEditingController();

  // Variables
  // ignore: prefer_final_fields
  Map _formData = {
      "schedule_name": "",
      "schedule_data": [
        [],
        [],
        [],
        [],
        [],
        [],
        [],
      ]
  };
  File? _pickedFile;
  String _scheduleName = "";
  String apiUrl = "https://ugm-tech-scraper-red-frog-920-white-sun-6887.fly.dev/api/jadwalsimaster";

  // method
  List _getJam(String jam){
    List result = jam.split("-").map((e) => e.split(":").map((x) => int.parse(x))).toList();
    return result;
  }
  void updateDatabase(List scheduleDatabase){
    db.scheduleData = scheduleDatabase;
    db.updateDatabase();
    Navigator.pushNamed(context, "/mainpage");
  }
  void _changescheduleName(){
    setState(() {
      _scheduleName = scheduleNameController.text;
    });
  }
  void _cancellAddSchedule(){
    Navigator.pushNamed(context, "/mainpage");
  }
  Future<void> _saveAddSchedule() async {
    if(_scheduleName != ""){
        if(_pickedFile != null){
          String? response = await _uploadFile();
          print(response);
          Map simasterData = json.decode(response);
          if(simasterData.containsKey("error") == false){
            List simasterJadwal = simasterData["jadwal kuliah"];
            for(int i = 0; i < simasterJadwal.length; i++){
              String nameData = simasterJadwal[i]["matkul"];
              List dosenData = simasterJadwal[i]["dosen"];
              List jadwalData = simasterJadwal[i]["jadwal"];
              Map hariIndex = {
                "senin": 0,
                "selasa": 1,
                "rabu": 2,
                "kamis": 3,
                "jumat": 4,
                "sabtu": 5,
                "minggu": 6,
              };
              
              for(int j = 0; j < jadwalData.length; j++){
                String hari = jadwalData[j]["hari"];
                List jam = _getJam(jadwalData[j]["jam"]).map((iterable) => iterable.toList()).toList();
                String ruang = jadwalData[j]["ruang"];
                
                _formData["schedule_data"][hariIndex[hari.toLowerCase()]].add({
                "is_ring": true,
                "time": jam,
                "ringtone": "Alarm1.mp3",
                "ring_time": "15 minutes before class time",
                "class_name": nameData,
                "room_name": ruang,
                "lecturers_name": dosenData,
                "description": ""
              });
              }
            }
          }
        }
        _formData["schedule_name"] = _scheduleName;
        List scheduleData = [...db.scheduleData];
        scheduleData.add(_formData);
        db.scheduleData = scheduleData;
        db.updateDatabase();
        Navigator.pushNamed(context, "/mainpage");
      }
  }

  Future<String> _uploadFile() async {
    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
    String filePath = _pickedFile?.path ?? "";
    var filePart = await http.MultipartFile.fromPath(
      'jadwal_pdf', 
      filePath,
      contentType: MediaType('application', 'pdf'),
      );
    print(filePath);
    request.files.add(filePart);

    try {
    var response = await request.send();

    if (response.statusCode == 200) {
      // Read the response data
      var responseData = await response.stream.toBytes();
      var responseString = utf8.decode(responseData);

      return responseString;
    } else {
      return '{"error": "${response.statusCode}"}';
    }
  } catch (error) {
    return '{"error": "$error"}';
  }
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _pickedFile = File(result.files.single.path!);
      });
    }
  }
  String _getFileName() {
    return _pickedFile != null ? _pickedFile!.path.split('/').last : 'No file selected.';
  }

  // Widgets 
  Widget _scheduleNameInput(){
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Schedule name",
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
              controller: scheduleNameController,
              onChanged: (context) => _changescheduleName(),
              style: TextStyle(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 18),
                hintText: "Schedule name...",
                hintStyle: TextStyle(
                  color: Color.fromARGB(50, 255, 255, 255)
                )
              ),
            ),
          )
        ],
      );
  }
  
  Widget _uploadButton(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            ElevatedButton(
              onPressed: _pickFile,
              style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Color(0xFF17133B),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)
                      )
              ),
              child: Text(
                "Upload",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Europa',
                ),
              ),
            ),
            SizedBox(width: 20,),
            Expanded(
            child: Text(
              _getFileName(),
              maxLines: null,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Europa',
              ),
            ),
          ),
          ],
        ),
      ],
    );
  }
  
  Widget _scheduleUpload(){
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Simaster's College Schedule PDF (Optional)",
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Europa',
              fontSize: 18
            ),
          ),
          SizedBox(height: 10),
          _uploadButton()
        ],
      );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        backgroundColor: Colors.transparent,
        title: Text(
            "Add Schedule",
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
              _scheduleNameInput(),
              SizedBox(height: 20,),
              _scheduleUpload(),
              SizedBox(height:35),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _cancellAddSchedule,
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
                    onPressed: _saveAddSchedule,
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