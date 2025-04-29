import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:quality_management_system/Core/Utilts/Constants.dart';
import 'package:quality_management_system/Core/Widgets/CustomCardHolder.dart';

import 'package:quality_management_system/Features/Dashboard/view/widgets/InteractionChart.dart';
import 'package:quality_management_system/Features/Dashboard/view/widgets/card_info_Widget.dart';
import 'package:quality_management_system/Features/Dashboard/view/widgets/sectionTitle.dart';
import 'package:quality_management_system/Features/Dashboard/view_model/dashboard_cubit.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(SizeApp.defaultPadding),
      child: BlocProvider(
        create: (context) => DashboardCubit()..loadDashboardData(),
        child: BlocBuilder<DashboardCubit, DashboardState>(
          builder: (context, state) {
            if (state is DashboardLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is DashboardError) {
              return Center(child: Text(state.message));
            } else if (state is DashboardLoaded) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const SectionTitle(title: 'معلومات سريعة'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      DashboardCard(
                        icon: Icons.person,
                        title: 'عدد الموظفين',
                        count: state.userCount.toString(),
                        color: ColorApp.primaryColor,
                      ),
                      DashboardCard(
                        icon: Icons.timelapse,
                        title: 'أقرب موعد تسليم',
                        count: state.nearestDeadlineWithOrder,
                        color: ColorApp.primaryColor,
                      ),
                    ],
                  ),
                  const SectionTitle(title: 'اخر المستجدات'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomContainer(
                        margin: EdgeInsets.all(SizeApp.padding),
                        child: InteractionChart(
                          chartType: ChartType.ring,
                          isOrderBased: true,
                          doneCount:  state.completedOrders,
                          notDoneCount: state.inProgress,
                          totalViews:  state.totalOrders,
                        ),
                      ),
                      CustomContainer(
                        margin: EdgeInsets.all(SizeApp.padding),
                        child: InteractionChart(
                          chartType: ChartType.disc,
                          isOrderBased: false,
                          totalCollections: state.completedOrders,
                          returns: state.rejectedOrders,
                          pending: state.pendingOrders,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }

            return const SizedBox(); // fallback
          },
        ),
      ),
    );
  }
}
