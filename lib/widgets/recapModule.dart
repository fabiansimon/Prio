import 'package:flutter/material.dart';
import 'package:prio_project/data/design.dart';
import 'package:prio_project/data/personalInfo.dart';
import 'package:prio_project/data/user.dart';
import 'package:prio_project/provider/personalInfosProv.dart';
import 'package:provider/provider.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class RecapModule extends StatefulWidget {
  @override
  _RecapModuleState createState() => _RecapModuleState();
}

class _RecapModuleState extends State<RecapModule> {
  // Returns the Daily Average income

  int _getCurrentDayInInt(double amount) {
    final int today = DateTime.now().day;
    final int dailyAverage = amount ~/ today;

    return dailyAverage;
  }

  @override
  Widget build(BuildContext context) {
    final PersonalInfo personalData = Provider.of<PersonalInfos>(context).items;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: blackGradient,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(100),
                ),
                color: black2,
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
                child: Text(
                  'This month',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    letterSpacing: -.5,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 38.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      personalData.finishedOrders.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 3),
                    const Text(
                      'finished \norders',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.42,
                  height: MediaQuery.of(context).size.width * 0.42,
                  child: Stack(
                    children: <Widget>[
                      Center(
                        child: SleekCircularSlider(
                          initialValue: ((personalData.monthlyEarnings /
                                          personalData.monthlyGoal) *
                                      100) >
                                  100
                              ? 100
                              : ((personalData.monthlyEarnings /
                                      personalData.monthlyGoal) *
                                  100),
                          appearance: CircularSliderAppearance(
                            size: MediaQuery.of(context).size.width * 0.42,
                            angleRange: 360,
                            startAngle: 270,
                            customWidths: CustomSliderWidths(
                              progressBarWidth: 20,
                              handlerSize: 0,
                              shadowWidth: 0,
                              trackWidth: 20,
                            ),
                            customColors: CustomSliderColors(
                              trackColor: Colors.black,
                              progressBarColors: <Color>[
                                if (((personalData.monthlyEarnings /
                                                personalData.monthlyGoal) *
                                            100)
                                        .toInt() <
                                    100)
                                  purple1
                                else
                                  green1,
                                if (((personalData.monthlyEarnings /
                                                personalData.monthlyGoal) *
                                            100)
                                        .toInt() <
                                    100)
                                  purple2
                                else
                                  green2,
                              ],
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              ((personalData.monthlyEarnings /
                                              personalData.monthlyGoal) *
                                          100)
                                      .toInt()
                                      .toString() +
                                  '%',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '€${personalData.monthlyEarnings.toInt()}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              '/ €${personalData.monthlyGoal.toInt()}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w200,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: <Widget>[
                    Text(
                      '€${_getCurrentDayInInt(personalData.monthlyEarnings)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 3),
                    const Text(
                      'daily \naverage',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                      ),
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
