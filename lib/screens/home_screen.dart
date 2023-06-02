import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:pomo_app/services/noti_services.dart';
import 'package:pomo_app/services/theme_services.dart';
import 'dart:async';
import 'package:pomo_app/screens/theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var notifyHelper;
  int totalSeconds = 0;
  int totalRestSeconds = 0;
  int changeSeconds = 0;
  int restChangeSeconds = 0;
  int minChange = 0;
  int secChange = 0;
  int restMinChange = 0;
  int restSecChange = 0;
  bool isRunning = false;
  late Timer timer; // late는 나중에 초기화
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
  int _currentMinValue = 0;
  int _currentSecValue = 0;
  int _currentRestMinValue = 0;
  int _currentRestSecValue = 0;

  void onTick(Timer timer) {
    if (totalSeconds == 0) {
      if (totalRestSeconds == 0) {
        setState(() {
          isRunning = false;
          totalSeconds = 0;
          // notifyHelper.displayNotification(
          //   title: 'Timer Finish',
          //   body: "Timer's time is up",
          // );
        });
        timer.cancel();
      } else {
        setState(() {
          totalRestSeconds -= 1;
          restChangeSeconds = totalRestSeconds;
        });
      }
    } else {
      setState(() {
        totalSeconds -= 1; // 남은 시간 1초씩 줄이기
        changeSeconds = totalSeconds;
      });
    }
  }

  void onStartPressed() {
    totalSeconds = changeSeconds;
    totalRestSeconds = restChangeSeconds;
    _validateDate();
  }

  _validateDate() {
    if (totalSeconds == 0) {
      Get.snackbar(
        'Required',
        'Work time cannot be zero !',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: pinkClr,
        colorText: Colors.white,
        icon: const Icon(
          Icons.warning_amber_rounded,
        ),
      );
    } else {
      timer = Timer.periodic(
        const Duration(seconds: 1), // 1초에 한 번씩 onTick 실행
        onTick, //onTick() <-처럼 괄호넣지 않기. 당장 실행할게 아니기 떄문.
      );
      setState(() {
        isRunning = true;
      });
    }
  }

  void onPausePressed() {
    timer.cancel();
    setState(() {
      isRunning = false;
    });
  }

  void stateChangeSeconds() {
    setState(() {
      changeSeconds = minChange + secChange;
      restChangeSeconds = restMinChange + restSecChange;
      _selectedRemind;
    });
  }

  String format(int seconds) {
    var duration = Duration(seconds: seconds);
    return duration.toString().split(".").first.substring(2, 7);
  }

  @override
  void initState() {
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      backgroundColor: context.theme.colorScheme.background,
      body: _showBody(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showDialog();
        },
        label: Text(
          'Set the Time',
          style: GoogleFonts.lato(
            textStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        icon: const Icon(
          Icons.edit,
          color: Colors.white,
        ),
        backgroundColor: Colors.indigo[400],
      ),
    );
  }

  _showBody() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.2,
          ),
          child: Column(
            children: [
              Text(
                format(changeSeconds),
                style: TextStyle(
                  color: Get.isDarkMode ? Colors.white : darkHeaderClr,
                  fontSize: 70,
                  fontWeight: FontWeight.w600,
                ),
              ),
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
                  Text(
                    "Set the Time",
                    style: headingStyle,
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _currentMinValue = 0;
                        _currentSecValue = 0;
                        _currentRestMinValue = 0;
                        _currentRestSecValue = 0;
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
                  Text(
                    'Work',
                    style: subHeadingStyle,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Work Min',
                            style: GoogleFonts.lato(
                              textStyle: titleStyle,
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          NumberPicker(
                            value: _currentMinValue,
                            minValue: 0,
                            maxValue: 60,
                            itemHeight: 35,
                            itemWidth: 80,
                            onChanged: (value) {
                              setState(() {
                                _currentMinValue = value;
                                minChange = _currentMinValue * 60;
                              });
                            },
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () {
                                  setState(() {
                                    final newValue = _currentMinValue - 10;
                                    _currentMinValue = newValue.clamp(0, 60);
                                  });
                                },
                              ),
                              Text('$_currentMinValue'),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  setState(() {
                                    final newValue = _currentMinValue + 10;
                                    _currentMinValue = newValue.clamp(0, 60);
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
                          Text(
                            'Work Sec',
                            style: titleStyle,
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          NumberPicker(
                            value: _currentSecValue,
                            minValue: 0,
                            maxValue: 60,
                            itemHeight: 35,
                            itemWidth: 80,
                            onChanged: (value) {
                              setState(() {
                                _currentSecValue = value;
                                secChange = _currentSecValue;
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
                                    final newValue = _currentSecValue - 10;
                                    _currentSecValue = newValue.clamp(0, 60);
                                  });
                                },
                              ),
                              Text('$_currentSecValue'),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  setState(() {
                                    final newValue = _currentSecValue + 10;
                                    _currentSecValue = newValue.clamp(0, 60);
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 26,
                  ),
                  Text(
                    'Rest',
                    style: subHeadingStyle,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Rest Min',
                            style: titleStyle,
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          NumberPicker(
                            value: _currentRestMinValue,
                            minValue: 0,
                            maxValue: 60,
                            itemHeight: 35,
                            itemWidth: 80,
                            onChanged: (value) {
                              setState(() {
                                _currentRestMinValue = value;
                                restMinChange = _currentRestMinValue * 60;
                              });
                            },
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () {
                                  setState(() {
                                    final newValue = _currentRestMinValue - 10;
                                    _currentRestMinValue =
                                        newValue.clamp(0, 60);
                                  });
                                },
                              ),
                              Text('$_currentRestMinValue'),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  setState(() {
                                    final newValue = _currentRestMinValue + 10;
                                    _currentRestMinValue =
                                        newValue.clamp(0, 60);
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
                          Text(
                            'Rest Sec',
                            style: titleStyle,
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          NumberPicker(
                            value: _currentRestSecValue,
                            minValue: 0,
                            maxValue: 60,
                            itemHeight: 35,
                            itemWidth: 80,
                            onChanged: (value) {
                              setState(() {
                                _currentRestSecValue = value;
                                restSecChange = _currentRestSecValue;
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
                                    final newValue = _currentRestSecValue - 10;
                                    _currentRestSecValue =
                                        newValue.clamp(0, 60);
                                  });
                                },
                              ),
                              Text('$_currentRestSecValue'),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  setState(() {
                                    final newValue = _currentRestSecValue + 10;
                                    _currentRestSecValue =
                                        newValue.clamp(0, 60);
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
                    icon: const RotatedBox(
                      quarterTurns: 3,
                      child: Icon(Icons.arrow_back_ios_new_rounded),
                    ),
                    iconSize: 12,
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
              actions: [
                Container(
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); //창 닫기
                    },
                    child: Text(
                      "Cancel",
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(
                          color: Colors.indigo[400],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  child: ElevatedButton(
                    onPressed: () {
                      stateChangeSeconds();
                      Navigator.of(context).pop(); //창 닫기
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo[400],
                    ),
                    child: Text(
                      "Set",
                      style: GoogleFonts.lato(
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
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
