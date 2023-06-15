import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
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
  AudioPlayer player = AudioPlayer();
  int totalSeconds = 0;
  int changeSeconds = 0;
  int minChange = 0;
  int secChange = 0;
  bool isRunning = false;
  late Timer timer; // late는 나중에 초기화
  int _currentMinValue = 0;
  int _currentSecValue = 0;
  int saveSeconds = 0;

  void onTick(Timer timer) async {
    if (totalSeconds == 0) {
      //타이머가 0초 됐을 때 사운드 재생, 설정한 시간 다시 설정
      // player.setSpeed(1.5);
      // player.setVolume(2.5);
      // player.setAsset('assets/bell_sound.mp3'); //앱용 사운드이나 아래 코드 사용 가능
      await player.setUrl(
          'https://github.com/wnal4634/flutter_timer/assets/90739311/51085b86-bd48-414f-aaad-79688a2c4b2b'); //웹용 사운드
      player.play();
      stateChangeSeconds();
      totalSeconds = changeSeconds;
    } else {
      setState(() {
        totalSeconds -= 1; // 남은 시간 1초씩 줄이기
        changeSeconds = totalSeconds;
      });
    }
  }

  void onStartPressed() {
    totalSeconds = changeSeconds;
    _validateDate();
  }

  _validateDate() {
    //설정한 시간이 0초면 스낵메세지, 아니면 타이머 실행
    if (totalSeconds == 0) {
      Get.snackbar(
        'Required',
        'Time cannot be zero !',
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
    //타이머 일시정지
    timer.cancel();
    setState(() {
      isRunning = false;
    });
  }

  void stateChangeSeconds() {
    //설정한 시간 바로 적용되게
    setState(() {
      changeSeconds = minChange + secChange;
    });
  }

  String format(int seconds) {
    //시간 포맷
    var duration = Duration(seconds: seconds);
    return duration.toString().split(".").first.substring(2, 7);
  }

  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      backgroundColor: context.theme.colorScheme.background,
      body: _showBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showDialog();
        },
        backgroundColor: yellowClr,
        child: const Icon(
          Icons.edit,
          color: Colors.white,
        ),
      ),
    );
  }

  _showBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            Text(
              format(changeSeconds),
              style: TextStyle(
                color: Get.isDarkMode
                    ? Colors.white
                    : darkHeaderClr, //다크모드냐에 따라 글씨 색상 변경
                fontSize: 70,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height * 0.08,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  iconSize: 120,
                  color: Get.isDarkMode ? Colors.white : darkHeaderClr,
                  onPressed: isRunning
                      ? onPausePressed
                      : onStartPressed, //타이머가 실행 중이면 정지가 가능하게, 정지 상태면 실행이 가능하게
                  icon: Icon(
                    isRunning
                        ? Icons.pause_circle_outline
                        : Icons.play_circle_outline,
                  ),
                ),
              ],
            ),
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
        //다크모드
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
              //플로팅 버튼 누르면 나오는 다이얼로그
              titlePadding: const EdgeInsets.only(
                top: 15,
                left: 30,
                right: 15,
              ),
              contentPadding: const EdgeInsets.only(
                left: 10,
                right: 10,
                top: 25,
                bottom: 5,
              ),
              // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              //Dialog Main Title
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Set the Time",
                    style: subHeadingStyle,
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _currentMinValue = 0;
                        _currentSecValue = 0;
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Min',
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
                            textStyle: lato,
                            selectedTextStyle: GoogleFonts.lato(
                              textStyle: const TextStyle(
                                color: yellowClr,
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                //분을 초로 변환해서 저장
                                _currentMinValue = value;
                                minChange = _currentMinValue * 60;
                              });
                            },
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.remove,
                                  color: Get.isDarkMode
                                      ? Colors.grey[600]
                                      : Colors.grey[400],
                                ),
                                onPressed: () {
                                  setState(() {
                                    //10씩 빠르게 뺼 수 있음
                                    final newValue = _currentMinValue - 10;
                                    _currentMinValue = newValue.clamp(0, 60);
                                  });
                                },
                              ),
                              Text(
                                '$_currentMinValue',
                                style: latoBold,
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.add,
                                  color: Get.isDarkMode
                                      ? Colors.grey[600]
                                      : Colors.grey[400],
                                ),
                                onPressed: () {
                                  setState(() {
                                    //10씩 빠르게 더할 수 있음
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Sec',
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
                            textStyle: lato,
                            selectedTextStyle: GoogleFonts.lato(
                              textStyle: const TextStyle(
                                color: yellowClr,
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                //설정한 초 저장
                                _currentSecValue = value;
                                secChange = _currentSecValue;
                              });
                            },
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.remove,
                                  color: Get.isDarkMode
                                      ? Colors.grey[600]
                                      : Colors.grey[400],
                                ),
                                onPressed: () {
                                  setState(() {
                                    //10씩 빠르게 뺼 수 있음
                                    final newValue = _currentSecValue - 10;
                                    _currentSecValue = newValue.clamp(0, 60);
                                  });
                                },
                              ),
                              Text(
                                '$_currentSecValue',
                                style: latoBold,
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.add,
                                  color: Get.isDarkMode
                                      ? Colors.grey[600]
                                      : Colors.grey[400],
                                ),
                                onPressed: () {
                                  setState(() {
                                    //10씩 빠르게 더할 수 있음
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
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); //다이얼로그 창 닫기
                  },
                  child: Text(
                    "Cancel",
                    style: GoogleFonts.lato(
                      textStyle: const TextStyle(
                        color: yellowClr,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    stateChangeSeconds(); //창 닫으면 설정한 시간 적용되게
                    Navigator.of(context).pop(); //다이얼로그 창 닫기
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: yellowClr,
                    elevation: 4,
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
              ],
            );
          },
        );
      },
    );
  }
}
