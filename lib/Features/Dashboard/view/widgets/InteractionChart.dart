import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:quality_management_system/Core/Utilts/Constants.dart';
import 'package:quality_management_system/Core/Utilts/Responsive_Helper.dart';
import 'components/InteractionItem.dart';
import 'sectionTitle.dart';

class InteractionChart extends StatelessWidget {
  final ChartType chartType;
  final bool isOrderBased;

  // Gender-based values
  final int totalViews;
  final int doneCount;
  final int notDoneCount;

  // Age-based values
  final int totalCollections;
  final int returns;
  final int invoices;

  const InteractionChart({
    super.key,
    this.totalViews = 0,
    required this.chartType,
    required this.isOrderBased,
    this.doneCount = 0,
    this.notDoneCount = 0,
    this.totalCollections = 0,
    this.returns = 0,
    this.invoices = 0,
  });

  @override
  Widget build(BuildContext context) {
    final Map<String, double> dataMap = isOrderBased
        ? {
            "done": doneCount.toDouble(),
            "notDone": notDoneCount.toDouble(),
          }
        : {
            "totalCollections": totalCollections.toDouble(),
            "returns": returns.toDouble(),
            "invoices": invoices.toDouble(),
          };

    final Map<String, String> legendLabels = isOrderBased
        ? {
            "done": 'تم الانهاء $doneCount',
            "notDone": 'قيد العمل $notDoneCount',
          }
        : {
            "totalCollections": 'اجمالي التحصيلات ($totalCollections)',
            "returns": 'اجمالي المرتجعات ($returns)',
            "invoices": 'اجمالي الفواتير ($invoices)',
          };

    final List<Color> colorList = isOrderBased
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
          title: isOrderBased ? 'أوامر التوريد' : 'ملخص العمل',
          fontWeight: FontWeight.bold,
        ),
        ResponsiveBuilder(
          tabletBuilder: (p0) =>  LayoutBuilder(
            builder: (context, constraints) {
              double chartSize = 120;
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: PieChart(
                      dataMap: dataMap,
                      animationDuration: const Duration(milliseconds: 1200),
                      chartRadius: chartSize ,
                      colorList: colorList,
                      chartType: chartType,
                      ringStrokeWidth: chartSize * 0.15,
                      centerWidget: isOrderBased == false
                          ? null
                          : RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Total\n",
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
                    children: isOrderBased
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
                                title: StringApp.notDone,
                                count: notDoneCount,
                              ),
                              InteractionItem(
                                color: ColorApp.primaryColor,
                                title: StringApp.done,
                                count: doneCount,
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
                                      title: StringApp.totalCollections,
                                      count: null,
                                    ),
                                    InteractionItem(
                                      radius: SizeApp.s4,
                                      color: Color(0xff357AF6),
                                      title: StringApp.returns,
                                      count: null,
                                    ),
                                    InteractionItem(
                                      radius: SizeApp.s4,
                                      color: Color(0xff6B4B46),
                                      title: StringApp.invoices,
                                      count: null,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: SizeApp.s12),

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
          mobileBuilder: (p0) => LayoutBuilder(
            builder: (context, constraints) {
              double chartSize = 120;
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: PieChart(
                      dataMap: dataMap,
                      animationDuration: const Duration(milliseconds: 1200),
                      chartRadius: chartSize,
                      colorList: colorList,
                      chartType: chartType,
                      ringStrokeWidth: chartSize * 0.15,
                      centerWidget: isOrderBased == false
                          ? null
                          : RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Total\n",
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
                    children: isOrderBased
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
                                      title: StringApp.done,
                                      count: notDoneCount,
                                    ),
                                    InteractionItem(
                                      color: ColorApp.primaryColor,
                                      title: StringApp.notDone,
                                      count: doneCount,
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
                                            title: StringApp.totalCollections,
                                            count: null,
                                          ),
                                          InteractionItem(
                                            radius: SizeApp.s4,
                                            color: Color(0xff357AF6),
                                            title: StringApp.returns,
                                            count: null,
                                          ),
                                          InteractionItem(
                                            radius: SizeApp.s4,
                                            color: Color(0xff6B4B46),
                                            title: StringApp.invoices,
                                            count: null,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: SizeApp.s12),

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
                        animationDuration: const Duration(milliseconds: 1200),
                        chartRadius: chartSize ,
                        colorList: colorList,
                        chartType: chartType,
                        ringStrokeWidth: chartSize * 0.15,
                        centerWidget: isOrderBased == false
                            ? null
                            : RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Total\n",
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
                  const Spacer(),
                  // Interaction Section (Horizontal Scrollable Row)
                  Expanded(
                    flex: 3,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: isOrderBased
                            ? [
                                InteractionItem(
                                  color:  ColorApp.primaryColor,
                                  title: StringApp.done,
                                  count: doneCount,
                                ),
                                InteractionItem(
                                  color: ColorApp.mainLight,
                                  title: StringApp.notDone,
                                  count: notDoneCount,
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
                                         title: StringApp.totalCollections,
                                         count: null,
                                       ),
                                       InteractionItem(
                                         radius: SizeApp.s4,
                                         color: Color(0xff357AF6),
                                         title: StringApp.returns,
                                         count: null,
                                       ),
                                       InteractionItem(
                                         radius: SizeApp.s4,
                                         color: Color(0xff6B4B46),
                                         title: StringApp.invoices,
                                         count: null,
                                       ),
                                     ],
                                   ),
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
