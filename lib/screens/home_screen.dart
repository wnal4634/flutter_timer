import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pomo_app/services/theme_services.dart';
import 'dart:async';
import 'package:pomo_app/screens/theme.dart';
import 'package:pomo_app/widgets/input_field.dart';

import 'package:time_picker_spinner_pop_up/time_picker_spinner_pop_up.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int totalSeconds = 0;
  int changeSeconds = 0;
  bool isRunning = false;
  int totalPomodoros = 0;
  late Timer timer; // late는 나중에 초기화
  String choice_num = '00:00:00';
  int _selectedRemind = 5;
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

  void onTick(Timer timer) {
    if (totalSeconds == 0) {
      setState(() {
        totalPomodoros += 1;
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

  int saveSeconds(int s) {
    return 2;
  }

  void onStartPressed() {
    totalSeconds = stringToInt(choice_num);
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

  String format(int seconds) {
    var duration = Duration(seconds: seconds);
    return duration.toString().split(".").first.padLeft(8, '0');
  }

  int stringToInt(String time333) {
    int total = (int.parse(time333.split(':').first) * 3600) +
        (int.parse(time333.split(':')[1]) * 60);
    return total;
  }

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
        Flexible(
          flex: 2,
          child: Container(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  format(changeSeconds),
                  style: TextStyle(
                    color: Get.isDarkMode ? Colors.white : darkHeaderClr,
                    fontSize: 89,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TimePickerSpinnerPopUp(
                  mode: CupertinoDatePickerMode.time,
                  initTime: DateTime.parse('0000-00-00T00+00:00'),
                  barrierColor: Colors.black12, //Barrier Color when pop up show
                  minuteInterval: 1,
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                  cancelText: 'Cancel',
                  confirmText: 'OK',
                  pressType: PressType.singlePress,
                  timeFormat: 'HH:mm:ss',
                  // textStyle: const TextStyle(
                  //   color: Colors.white,
                  // ),
                  // Customize your time widget
                  // timeWidgetBuilder: (dateTime) {},
                  onChange: (dateTime) {
                    // Implement your logic with select dateTime
                    setState(() {
                      choice_num =
                          dateTime.toString().split(' ').last.substring(0, 8);
                      changeSeconds = stringToInt(choice_num);
                    });
                  },
                ),
                MyInputField(
                  title: 'Repetition',
                  hint: '$_selectedRemind번 반복',
                  widget: DropdownButton(
                    icon: Transform.translate(
                      offset: const Offset(-5, 0),
                      child: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.grey,
                      ),
                    ),
                    iconSize: 32,
                    elevation: 4,
                    style: subTitleStyle,
                    underline: Container(
                      height: 0,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedRemind = int.parse(newValue!);
                      });
                    },
                    items: remindList.map<DropdownMenuItem<String>>(
                      (int value) {
                        return DropdownMenuItem<String>(
                          value: value.toString(),
                          child: Text(
                            value.toString(),
                          ),
                        );
                      },
                    ).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
        Flexible(
          flex: 3,
          child: Center(
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
                // IconButton(
                //   iconSize: 120,
                //   color: Theme.of(context).cardColor,
                //   onPressed: onResetPressed,
                //   icon: const Icon(
                //     Icons.refresh_outlined,
                //   ),
                // )
              ],
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(40),
                    ),
                    color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Pomodoros',
                        style: TextStyle(
                          fontSize: 20,
                          color:
                              Theme.of(context).textTheme.displayLarge!.color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '$totalPomodoros',
                        style: TextStyle(
                          fontSize: 58,
                          color:
                              Theme.of(context).textTheme.displayLarge!.color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
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
          // notifyHelper.displayNotification(
          //   title: 'Theme Changed',
          //   body: Get.isDarkMode
          //       ? 'Activated light Theme'
          //       : 'Activated Dark Theme',
          // );
          // notifyHelper.scheduledNotification();
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
}
