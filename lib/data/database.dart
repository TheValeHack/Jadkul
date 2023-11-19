import 'package:hive/hive.dart';

class scheduleDatabase {
  // Hive box

  List scheduleData = [
    {
      "schedule_name": "Main Schedule",
      "schedule_data": [
        [],
        [],
        [],
        [],
        [],
        [],
        [],
      ]
    },
  ];
  int activeScheduleIndex = 0;
  int activeDayIndex = (DateTime.now().weekday) - 1;
  List editPosition = [];

  final _myBox = Hive.box("myBox");

  void createInitialData(){
    scheduleData = [
    {
      "schedule_name": "Main Schedule",
      "schedule_data": [
            [],
            [],
            [],
            [],
            [],
            [],
            [],
          ]
        },
      ];
    activeScheduleIndex = 0;
    activeDayIndex = (DateTime.now().weekday) - 1;
    editPosition = [];
  }
  void loadData(){
    scheduleData = _myBox.get("SCHEDULEDATA");
    activeScheduleIndex = _myBox.get("ACTIVESCHEDULEINDEX");
    activeDayIndex = _myBox.get("ACTIVEDAYINDEX");
    editPosition = _myBox.get("EDITPOSITION");
  }
  void updateDatabase(){
    _myBox.put("SCHEDULEDATA", scheduleData);
    _myBox.put("ACTIVESCHEDULEINDEX", activeScheduleIndex);
    _myBox.put("ACTIVEDAYINDEX", activeDayIndex);
    _myBox.put("EDITPOSITION", editPosition);
  }

}