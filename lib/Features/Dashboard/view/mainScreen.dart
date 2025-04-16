import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:quality_management_system/Core/Utilts/Constants.dart';
import 'package:quality_management_system/Core/Widgets/CustomCardHolder.dart';
import 'package:quality_management_system/Features/Dashboard/view/widgets/InteractionChart.dart';
import 'package:quality_management_system/Features/Dashboard/view/widgets/card_info_Widget.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _TherapistaccountScreenState();
}

class _TherapistaccountScreenState extends State<MainScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(SizeApp.defaultPadding),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              DashboardCard(
                  icon: Icons.person,
                  title: 'title',
                  count: '12',
                  color: Colors.white
              ) ,
              DashboardCard(
                  icon: Icons.person,
                  title: 'title',
                  count: '12',
                  color: Colors.white
              ) ,
             ],
          ),
        ),

        Padding(
          padding: EdgeInsets.all(SizeApp.defaultPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomContainer(
                margin: EdgeInsets.all(SizeApp.padding),
                  child: const InteractionChart(chartType: ChartType.ring,
                    isGenderBased: true,
                    age18: 45,
                    age19_24: 54,
                    age25_32: 54,
                    age33_50: 5,
                    maleCount: 54,
                    age50Plus: 45,
                    femaleCount: 41,
                    totalViews: 4,),

              ),

              CustomContainer(
                  margin: EdgeInsets.all(SizeApp.padding),
                  child: const InteractionChart(
                    chartType: ChartType.disc,
                    isGenderBased: false,
                    age18: 45,
                    age19_24: 54,
                    maleCount: 54,
                    age50Plus: 45,
                    femaleCount: 41,
                    totalViews: 4,),
              )
            ],
          ),
        ),
      ],
    );
  }

}
