import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:time_picker_spinner_pop_up/time_picker_spinner_pop_up.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int totalSeconds = 0;
  bool isRunning = false;
  int totalPomodoros = 0;
  late Timer timer; // late는 나중에 초기화
  // final DateTime _selectedDate = DateTime.now();
  // final String _endTime = '9:30 PM';
  // String _startTime = DateFormat('hh:mm a').format(DateTime.now()).toString();
  String choice_num = '00:05:00';

  void onTick(Timer timer) {
    setState(() {
      totalSeconds = stringToInt(choice_num);
      print(totalSeconds);
    });
    if (totalSeconds == 0) {
      setState(() {
        totalPomodoros += 1;
        isRunning = false;
        totalSeconds = 0;
      });
      timer.cancel();
    } else {
      setState(() {
        totalSeconds = totalSeconds - 1; // 남은 시간 1초씩 줄이기
        print(totalSeconds);
      });
    }
  }

  void onStartPressed() {
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

  void onResetPressed() {
    timer.cancel();
    setState(() {
      isRunning = false;
      totalSeconds = 300;
    });
    // onStartPressed();  // 이거 넣으면 restart까지 됨
  }

  String format(int seconds) {
    var duration = Duration(seconds: seconds);
    print(duration);
    return duration.toString().split(".").first;
  }

  // String format(String time) {
  //   return time;
  // }

  int stringToInt(String time333) {
    int total = 0;
    total = (int.parse(time333.split(':').first) * 3600) +
        (int.parse(time333.split(':')[1]) * 60);
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        children: [
          Flexible(
            flex: 2,
            child: Container(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    child: Text(
                      format(stringToInt(choice_num)),
                      style: TextStyle(
                        color: Theme.of(context).cardColor,
                        fontSize: 89,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: () {},
                  ),
                  TimePickerSpinnerPopUp(
                    mode: CupertinoDatePickerMode.time,
                    initTime: DateTime.parse('0000-00-00T00+23:55'),
                    barrierColor:
                        Colors.black12, //Barrier Color when pop up show
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
                      });
                    },
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
                    color: Theme.of(context).cardColor,
                    onPressed: isRunning ? onPausePressed : onStartPressed,
                    icon: Icon(
                      isRunning
                          ? Icons.pause_circle_outline
                          : Icons.play_circle_outline,
                    ),
                  ),
                  IconButton(
                    iconSize: 120,
                    color: Theme.of(context).cardColor,
                    onPressed: onResetPressed,
                    icon: const Icon(
                      Icons.refresh_outlined,
                    ),
                  )
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
                      color: Theme.of(context).cardColor,
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
      ),
    );
  }

  // _getTimeFromUser({required bool isStartTime}) async {
  //   var pickedTime = await _showTimePicker();
  //   if (pickedTime == null) {
  //     print('Time canceled');
  //   } else if (isStartTime == true) {
  //     setState(() {
  //       _startTime = pickedTime.format(context);
  //     });
  //   } else {
  //     setState(() {
  //       // _endTime = formatedTime;
  //     });
  //   }
  // }

  // _showTimePicker() {
  //   return showTimePicker(
  //     initialEntryMode: TimePickerEntryMode.input,
  //     context: context,
  //     initialTime: TimeOfDay(
  //       hour: int.parse(
  //         _startTime.split(':')[0],
  //       ),
  //       minute: int.parse(
  //         _startTime.split(':')[1].split(' ')[0],
  //       ),
  //     ),
  //   );
  // }
}
