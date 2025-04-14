import 'package:flutter/material.dart';
import 'package:quality_management_system/Core/Utilts/Constants.dart';


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
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: _buildCard(
                      icon: Icons.pie_chart,
                      title: "# of workers",
                      count: "514 Therapists",
                      color: Colors.pink,
                ),
              ),
              Expanded(
                child: _buildCard(
                      icon: Icons.people_alt,
                      title: "# of Users",
                      count: "561 Users",
                      color: Colors.purple,
                    )
              ),
            ],
          ),
        ),
        // Search Bar
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(width: 10),
            SizedBox(
              width: 300.0,
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: "Search...",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black26,
                    ),
                  ),
                ),
                onChanged: (value) {
                  setState(() {

                  });
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
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
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Manage Therapist",
                  style: TextStyle(
                      color: ColorApp.mainLight,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: () {
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:  ColorApp.mainLight,
                    foregroundColor:  ColorApp.primaryColor,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Add New Therapist',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          width: double.infinity,
          color: ColorApp.mainLight,
          height: 500,
          child: DataTable(
                headingRowColor: MaterialStateProperty.resolveWith(
                      (states) => ColorApp.blackColor5,
                ),
                columns: const [
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Experience')),
                  DataColumn(label: Text('Subspecialties')),
                  DataColumn(label: Text('Bio')),
                  DataColumn(label: Text('Session')),
                  DataColumn(label: Text('Actions')), // Actions column
                ], rows: [],

              )
        ),
      ],
    );
  }

////////////////////////////////////////////////

  Widget _buildCard({
    required IconData icon,
    required String title,
    required String count,
    required Color color,
  }) {
    return Flexible(
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, size: 26.0, color: color),
                  const SizedBox(width: 15.0),
                  Expanded(
                    child: Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontSize: 26.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              Text(
                count,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  fontSize: 20,
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
