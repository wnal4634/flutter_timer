import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:pomo_app/services/theme_services.dart';
import 'dart:async';
import 'package:pomo_app/screens/theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int totalSeconds = 0;
  int changeSeconds = 0;
  int restChangeSeconds = 0;
  int minChange = 0;
  int secChange = 0;
  int restMinChange = 0;
  int restSecChange = 0;
  bool isRunning = false;
  late Timer timer; // late는 나중에 초기화
  String choiceNum = '00:00';
  String choiceNum_2 = '00:00';
  int _selectedRemind = 1;
  List<int> remindList = [
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
  ];
  int _currentValue = 0;
  int _currentValue_2 = 0;

  void onTick(Timer timer) {
    if (totalSeconds == 0) {
      setState(() {
        isRunning = false;
        totalSeconds = 0;
      });
      timer.cancel();
    } else {
      setState(() {
        totalSeconds -= 1; // 남은 시간 1초씩 줄이기
        print(totalSeconds);
        changeSeconds = totalSeconds;
      });
    }
  }

  void onStartPressed() {
    // totalSeconds = stringToInt(choiceNum);
    totalSeconds = changeSeconds;
    timer = Timer.periodic(
      const Duration(seconds: 1), // 1초에 한 번씩 onTick 실행
      onTick, //onTick() <-처럼 괄호넣지 않기. 당장 실행할게 아니기 떄문.
    );
    setState(() {
      isRunning = true;
    });
  }

  void onPausePressed() {
    timer.cancel();
    setState(() {
      isRunning = false;
    });
  }

  // String format(int seconds) {
  //   // var duration = Duration(seconds: seconds);
  //   // return duration.toString().split(".").first.padLeft(8, '0');
  //
  //   var duration = Duration(seconds: seconds);
  //   var short = duration.toString().split(".").first.split(':');
  //   if (short[0] != 0) {
  //     int hour = int.parse(short[0]) * 60;
  //     int min = int.parse(short[1]);
  //     short[1] = (hour + min).toString();
  //     if (short[1].length == 1) {
  //       short[1] = short[1].padLeft(2, '0');
  //     }
  //   }
  //   return '${short[1]}:${short.last}';
  // }

  String format(int seconds) {
    var duration = Duration(seconds: seconds);
    return duration.toString().split(".").first.substring(2, 7);
  }

  // int stringToInt(String time) {
  //   int total = (int.parse(time.split(':').first) * 3600) +
  //       (int.parse(time.split(':')[1]) * 60);
  //   return total;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      backgroundColor: context.theme.colorScheme.background,
      body: _showBody(),
    );
  }

  _showBody() {
    return Column(
      children: [
        Container(
          alignment: Alignment.bottomCenter,
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  format(changeSeconds),
                  style: TextStyle(
                    color: Get.isDarkMode ? Colors.white : darkHeaderClr,
                    fontSize: 70,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                // TimePickerSpinnerPopUp(
                //   mode: CupertinoDatePickerMode.time,
                //   initTime: DateTime.parse('0000-00-00T00+00:00'),
                //   barrierColor: Colors.black12, //Barrier Color when pop up show
                //   minuteInterval: 1,
                //   padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                //   cancelText: 'Cancel',
                //   confirmText: 'OK',
                //   pressType: PressType.singlePress,
                //   timeFormat: 'HH:mm:ss',
                //   // textStyle: const TextStyle(
                //   //   color: Colors.white,
                //   // ),
                //   // Customize your time widget
                //   // timeWidgetBuilder: (dateTime) {},
                //   onChange: (dateTime) {
                //     // Implement your logic with select dateTime
                //     setState(() {
                //       choiceNum =
                //           dateTime.toString().split(' ').last.substring(0, 8);
                //       // changeSeconds = stringToInt(choiceNum);
                //     });
                //   },
                // ),
              ],
            ),
          ),
        ),
        Container(
          alignment: Alignment.bottomCenter,
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: Row(
            // mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                format(restChangeSeconds),
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 50,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Column(
          children: [
            ElevatedButton(
              child: const Text('Set the Time'),
              onPressed: () {
                _showDialog();
              },
            ),
          ],
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                iconSize: 120,
                color: Get.isDarkMode ? Colors.white : darkHeaderClr,
                onPressed: isRunning ? onPausePressed : onStartPressed,
                icon: Icon(
                  isRunning
                      ? Icons.pause_circle_outline
                      : Icons.play_circle_outline,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.colorScheme.background,
      leading: GestureDetector(
        onTap: () {
          ThemeService().SwitchTheme();
        },
        child: Icon(
          Get.isDarkMode ? Icons.light_mode_rounded : Icons.nightlight_round,
          size: 20,
          color: Get.isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      actions: [
        Icon(
          Icons.person,
          size: 20,
          color: Get.isDarkMode ? Colors.white : Colors.black,
        ),
        const SizedBox(
          width: 20,
        )
      ],
    );
  }

  _showDialog() {
    showDialog(
      context: context,
      //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              //Dialog Main Title
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text("Set the Time"),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _currentValue = 0;
                        _currentValue_2 = 0;
                        _selectedRemind = 1;
                      });
                    },
                    icon: const Icon(Icons.refresh_rounded),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Min',
                              style: Theme.of(context).textTheme.titleLarge),
                          const SizedBox(height: 16),
                          NumberPicker(
                            value: _currentValue,
                            minValue: 0,
                            maxValue: 60,
                            itemHeight: 40,
                            itemWidth: 80,
                            onChanged: (value) {
                              setState(() {
                                _currentValue = value;
                                minChange = _currentValue * 60;
                              });
                            },
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () {
                                  setState(() {
                                    final newValue = _currentValue - 10;
                                    _currentValue = newValue.clamp(0, 60);
                                  });
                                },
                              ),
                              Text('$_currentValue'),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  setState(() {
                                    final newValue = _currentValue + 10;
                                    _currentValue = newValue.clamp(0, 60);
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Sec',
                              style: Theme.of(context).textTheme.titleLarge),
                          const SizedBox(height: 16),
                          NumberPicker(
                            value: _currentValue_2,
                            minValue: 0,
                            maxValue: 60,
                            itemHeight: 40,
                            itemWidth: 80,
                            onChanged: (value) {
                              setState(() {
                                _currentValue_2 = value;
                                secChange = _currentValue_2;
                              });
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () {
                                  setState(() {
                                    final newValue = _currentValue_2 - 10;
                                    _currentValue_2 = newValue.clamp(0, 60);
                                  });
                                },
                              ),
                              Text('$_currentValue_2'),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  setState(() {
                                    final newValue = _currentValue_2 + 10;
                                    _currentValue_2 = newValue.clamp(0, 60);
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  DropdownButton(
                    value: _selectedRemind,
                    items: remindList
                        .map((e) => DropdownMenuItem(
                              value: e, // 선택 시 onChanged 를 통해 반환할 value
                              child: Text(e.toString()),
                            ))
                        .toList(),
                    onChanged: (value) {
                      // items 의 DropdownMenuItem 의 value 반환
                      setState(() {
                        _selectedRemind = value!;
                      });
                    },
                  ),
                ],
              ),
              actions: <Widget>[
                Container(
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); //창 닫기
                    },
                    child: const Text("Cancel"),
                  ),
                ),
                Container(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); //창 닫기
                      setState(() {
                        changeSeconds = minChange + secChange;
                      });
                    },
                    child: const Text("Set"),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
