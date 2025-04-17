// Container(
// width: double.infinity,
// height: 50,
// decoration: const BoxDecoration(
// color: ColorApp.primaryColor,
// borderRadius: BorderRadius.only(
// topLeft: Radius.circular(10),
// topRight: Radius.circular(10),
// ),
// ),
// child: Padding(
// padding: const EdgeInsets.all(8.0),
// child: Row(
// mainAxisAlignment: MainAxisAlignment.spaceBetween,
// children: [
// const Text(
// "Manage Therapist",
// style: TextStyle(
// color: ColorApp.mainLight,
// fontSize: 20,
// fontWeight: FontWeight.bold),
// ),
// ElevatedButton(
// onPressed: () {},
// style: ElevatedButton.styleFrom(
// backgroundColor: ColorApp.mainLight,
// foregroundColor: ColorApp.primaryColor,
// padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
// shape: RoundedRectangleBorder(
// borderRadius: BorderRadius.circular(10),
// ),
// ),
// child: const Text(
// 'Add New Therapist',
// style: TextStyle(fontSize: 14),
// ),
// ),
// ],
// ),
// ),
// ),
// Container(
// width: double.infinity,
// color: ColorApp.mainLight,
// height: 500,
// child: DataTable(
// headingRowColor: MaterialStateProperty.resolveWith(
// (states) => ColorApp.blackColor5,
// ),
// columns: const [
// DataColumn(label: Text('Name')),
// DataColumn(label: Text('Experience')),
// DataColumn(label: Text('Subspecialties')),
// DataColumn(label: Text('Bio')),
// DataColumn(label: Text('Session')),
// DataColumn(label: Text('Actions')), // Actions column
// ],
// rows: [],
// )),