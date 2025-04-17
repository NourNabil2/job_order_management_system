import 'package:flutter/material.dart';
import 'package:quality_management_system/Core/Utilts/Constants.dart';

class AddOrderPage extends StatefulWidget {
  const AddOrderPage({super.key});

  @override
  State<AddOrderPage> createState() => _AddOrderPageState();
}

class _AddOrderPageState extends State<AddOrderPage> {
  int? expandedIndex;

  final List<Map<String, dynamic>> orders = [
    {
      'company': 'ABC Co.',
      'supplyOrder': 'SO-1001',
      'itemsStatus': 'Completed',
      'collectionStatus': 'Pending',
      'itemsCount': 12,
      'jobOrderStatus': 'In Progress',
    },
    {
      'company': 'XYZ Ltd.',
      'supplyOrder': 'SO-1002',
      'itemsStatus': 'In Progress',
      'collectionStatus': 'Completed',
      'itemsCount': 8,
      'jobOrderStatus': 'Completed',
    },
    {
      'company': 'Delta Corp.',
      'supplyOrder': 'SO-1003',
      'itemsStatus': 'Pending',
      'collectionStatus': 'Pending',
      'itemsCount': 5,
      'jobOrderStatus': 'Not Started',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: 900,
        ),
        child: Padding(
          padding: EdgeInsets.all(SizeApp.defaultPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                width: double.infinity,
                height: 50,
                decoration: const BoxDecoration(
                  color: ColorApp.primaryColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Add Order",
                        style: TextStyle(
                          color: ColorApp.mainLight,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // زر إضافة أمر توريد جديد
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorApp.mainLight,
                          foregroundColor: ColorApp.primaryColor,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Add New Order',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Table + List
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  final isExpanded = expandedIndex == index;

                  return Column(
                    children: [
                      Container(
                        color: ColorApp.mainLight,
                        child: DataTable(
                          headingRowColor: MaterialStateProperty.resolveWith(
                                (states) => ColorApp.blackColor5,
                          ),
                          columns: const [
                            DataColumn(label: Text('Company Name')),
                            DataColumn(label: Text('Supply Order')),
                            DataColumn(label: Text('Items Status')),
                            DataColumn(label: Text('Collection Status')),
                            DataColumn(label: Text('Items Count')),
                            DataColumn(label: Text('Job Order Status')),
                            DataColumn(label: Text('Actions')),
                          ],
                          rows: [
                            DataRow(cells: [
                              DataCell(Text(order['company'])),
                              DataCell(Text(order['supplyOrder'])),
                              DataCell(Text(order['itemsStatus'])),
                              DataCell(Text(order['collectionStatus'])),
                              DataCell(Text(order['itemsCount'].toString())),
                              DataCell(Text(order['jobOrderStatus'])),
                              DataCell(IconButton(
                                icon: Icon(
                                  isExpanded ? Icons.expand_less : Icons.expand_more,
                                ),
                                onPressed: () {
                                  setState(() {
                                    expandedIndex = isExpanded ? null : index;
                                  });
                                },
                              )),
                            ]),
                          ],
                        ),
                      ),
                      if (isExpanded)
                        Container(
                          width: double.infinity,
                          color: Colors.grey.shade100,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ElevatedButton.icon(
                                onPressed: () {
                                  // تفاصيل أمر الشغل
                                },
                                icon: const Icon(Icons.info_outline),
                                label: const Text('Job Order Details'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ColorApp.primaryColor,
                                ),
                              ),
                              const SizedBox(width: 16),
                              ElevatedButton.icon(
                                onPressed: () {
                                  // الفواتير
                                },
                                icon: const Icon(Icons.receipt_long),
                                label: const Text('Invoices'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ColorApp.primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 8),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
