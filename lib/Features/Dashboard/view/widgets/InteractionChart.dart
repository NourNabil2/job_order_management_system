import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:quality_management_system/Core/Utilts/Constants.dart';
import 'package:quality_management_system/Core/Utilts/Responsive_Helper.dart';
import 'components/InteractionItem.dart';
import 'sectionTitle.dart';

class InteractionChart extends StatelessWidget {
  final ChartType chartType;
  final bool isGenderBased;

  // Gender-based values
  final int totalViews;
  final int maleCount;
  final int femaleCount;

  // Age-based values
  final int age18;
  final int age19_24;
  final int age25_32;
  final int age33_50;
  final int age50Plus;

  const InteractionChart({
    super.key,
    this.totalViews = 0,
    required this.chartType,
    required this.isGenderBased,
    this.maleCount = 0,
    this.femaleCount = 0,
    this.age18 = 0,
    this.age19_24 = 0,
    this.age25_32 = 0,
    this.age33_50 = 0,
    this.age50Plus = 0,
  });

  @override
  Widget build(BuildContext context) {
    final Map<String, double> dataMap = isGenderBased
        ? {
            "Male": maleCount.toDouble(),
            "Female": femaleCount.toDouble(),
          }
        : {
            "18": age18.toDouble(),
            "19-24": age19_24.toDouble(),
            "25-32": age25_32.toDouble(),
            "33-50": age33_50.toDouble(),
            "+50": age50Plus.toDouble(),
          };

    final Map<String, String> legendLabels = isGenderBased
        ? {
            "Male": 'Male $maleCount',
            "Female": 'Female $femaleCount',
          }
        : {
            "18": '18 ($age18)',
            "19-24": '19-24 ($age19_24)',
            "25-32": '25-32 ($age25_32)',
            "33-50": '33-50 ($age33_50)',
            "+50": '50+ ($age50Plus)',
          };

    final List<Color> colorList = isGenderBased
        ? [ColorApp.primaryColor, ColorApp.mainLight]
        : const [
            Color(0xffEA3354),
            Color(0xff357AF6),
            Color(0xff6B4B46),
            Color(0xff5CC8BE),
            Color(0xffAF52DE),
          ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(
          title: isGenderBased ? 'Gender' : 'Age',
          fontWeight: FontWeight.bold,
        ),
        ResponsiveBuilder(
          mobileBuilder: (p0) => LayoutBuilder(
            builder: (context, constraints) {
              double chartSize = 120;
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: PieChart(
                      dataMap: dataMap,
                      animationDuration: Duration(milliseconds: 1200),
                      chartRadius: chartSize * chartSize,
                      colorList: colorList,
                      chartType: chartType,
                      ringStrokeWidth: chartSize * 0.15,
                      centerWidget: isGenderBased == false
                          ? null
                          : RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Total Views\n",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(
                                          color: ColorApp.blackColor60,
                                        ),
                                  ),
                                  TextSpan(
                                    text: totalViews.toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 24.sp),
                                  ),
                                ],
                              ),
                            ),
                      chartValuesOptions: const ChartValuesOptions(
                        showChartValues: false,
                      ),
                      legendLabels: legendLabels,
                      legendOptions: const LegendOptions(
                        legendPosition: LegendPosition.bottom,
                        showLegendsInRow: true,
                        showLegends: false,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: SizeApp.s16,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: isGenderBased
                        ? [
                            Expanded(
                              // Ensures the Row fits inside the available space
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceEvenly, // Adjusts spacing
                                  children: [
                                    InteractionItem(
                                      color: ColorApp.purpleColor,
                                      title: 'Male',
                                      count: femaleCount,
                                    ),
                                    InteractionItem(
                                      color: ColorApp.primaryColor,
                                      title: 'Female',
                                      count: maleCount,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ]
                        : [
                            Expanded(
                              child: Column(
                                children: [
                                  IntrinsicWidth(
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          InteractionItem(
                                            radius: SizeApp.s4,
                                            color: Color(0xffEA3354),
                                            title: '-18',
                                            count: null,
                                          ),
                                          InteractionItem(
                                            radius: SizeApp.s4,
                                            color: Color(0xff357AF6),
                                            title: '19_24',
                                            count: null,
                                          ),
                                          InteractionItem(
                                            radius: SizeApp.s4,
                                            color: Color(0xff6B4B46),
                                            title: '25_32',
                                            count: null,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: SizeApp.s12),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      InteractionItem(
                                        radius: SizeApp.s4,
                                        color: Color(0xff5CC8BE),
                                        title: '33-50',
                                        count: null,
                                      ),
                                      InteractionItem(
                                        radius: SizeApp.s4,
                                        color: Color(0xffAF52DE),
                                        title: '+50',
                                        count: null,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                  ),
                  SizedBox(
                    height: SizeApp.s16,
                  ),
                ],
              );
            },
          ),
          desktopBuilder: (p0) => LayoutBuilder(
            builder: (context, constraints) {
              double chartSize = 120;
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // PieChart Section
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: PieChart(
                        dataMap: dataMap,
                        animationDuration: Duration(milliseconds: 1200),
                        chartRadius: chartSize * chartSize,
                        colorList: colorList,
                        chartType: chartType,
                        ringStrokeWidth: chartSize * 0.15,
                        centerWidget: isGenderBased == false
                            ? null
                            : RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Total Views\n",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                            color: ColorApp.blackColor60,
                                          ),
                                    ),
                                    TextSpan(
                                      text: totalViews.toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!,
                                    ),
                                  ],
                                ),
                              ),
                        chartValuesOptions: const ChartValuesOptions(
                          showChartValues: false,
                        ),
                        legendLabels: legendLabels,
                        legendOptions: const LegendOptions(
                          legendPosition: LegendPosition.bottom,
                          showLegendsInRow: true,
                          showLegends: false,
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                  // Interaction Section (Horizontal Scrollable Row)
                  Expanded(
                    flex: 3,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: isGenderBased
                            ? [
                                InteractionItem(
                                  color: ColorApp.purpleColor,
                                  title: 'Male',
                                  count: femaleCount,
                                ),
                                InteractionItem(
                                  color: ColorApp.primaryColor,
                                  title: 'Female',
                                  count: maleCount,
                                ),
                              ]
                            : [
                               Column(
                                 children: [
                                   Row(
                                     children: [
                                       InteractionItem(
                                         radius: SizeApp.s4,
                                         color: Color(0xffEA3354),
                                         title: '-18',
                                         count: null,
                                       ),
                                       InteractionItem(
                                         radius: SizeApp.s4,
                                         color: Color(0xff357AF6),
                                         title: '19_24',
                                         count: null,
                                       ),
                                       InteractionItem(
                                         radius: SizeApp.s4,
                                         color: Color(0xff6B4B46),
                                         title: '25_32',
                                         count: null,
                                       ),
                                     ],
                                   ),
                                   const SizedBox(height: 16), // Space between rows
                                   Row(
                                     children: [
                                       InteractionItem(
                                         radius: SizeApp.s4,
                                         color: Color(0xff5CC8BE),
                                         title: '33-50',
                                         count: null,
                                       ),
                                       InteractionItem(
                                         radius: SizeApp.s4,
                                         color: Color(0xffAF52DE),
                                         title: '+50',
                                         count: null,
                                       )
                                     ],
                                   )
                                 ],
                               )
                              ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        )
      ],
    );
  }
}
