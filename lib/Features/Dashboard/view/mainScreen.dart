import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:quality_management_system/Core/Utilts/Constants.dart';
import 'package:quality_management_system/Core/Utilts/Responsive_Helper.dart';
import 'package:quality_management_system/Core/Widgets/CustomCardHolder.dart';
import 'package:quality_management_system/Features/Dashboard/view/widgets/InteractionChart.dart';
import 'package:quality_management_system/Features/Dashboard/view/widgets/card_info_Widget.dart';
import 'package:quality_management_system/Features/Dashboard/view/widgets/sectionTitle.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _TherapistaccountScreenState();
}

class _TherapistaccountScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(SizeApp.defaultPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const SectionTitle(title: 'تيست تيست'),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              DashboardCard(
                  icon: Icons.person,
                  title: 'عدد ',
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
           const SectionTitle(title: 'اخر المستجدات'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomContainer(
                margin: EdgeInsets.all(SizeApp.padding),
                  child: const InteractionChart(chartType: ChartType.ring,
                    isOrderBased: true,
                    totalCollections: 45,
                    returns: 54,
                    invoices: 54,
                    doneCount: 54,
                    notDoneCount: 41,
                    totalViews: 4,),

              ),

              CustomContainer(
                  margin: EdgeInsets.all(SizeApp.padding),
                  child: const InteractionChart(
                    chartType: ChartType.disc,
                    isOrderBased: false,
                    totalCollections: 45,
                    returns: 54,
                    doneCount: 54,
                    invoices: 45,
                    notDoneCount: 41,
                    totalViews: 4,),
              )
            ],
          ),
        ],
      ),
    );
  }

}
