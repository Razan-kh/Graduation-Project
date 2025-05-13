
// // import 'package:flutter/material.dart';
// // import 'package:frontend1/templates/collaboration_template/ghantChart.dart';

// // class SettingsPage extends StatefulWidget {
// //     final String token;
// //   final String templateId;

// //   SettingsPage({required this.token, required this.templateId});
// //   @override
// //   _SettingsPageState createState() => _SettingsPageState();
// // }

// // class _SettingsPageState extends State<SettingsPage> {



// //   Future<void> _selectDate(BuildContext context) async {
// //     final DateTime? pickedDate = await showDatePicker(
// //       context: context,
// //       initialDate: selectedDate ?? DateTime.now(),
// //       firstDate: DateTime(2000),
// //       lastDate: DateTime(2100),
// //     );

// //     if (pickedDate != null && pickedDate != selectedDate) {
// //       setState(() {
// //         selectedDate = pickedDate;
// //       });
// //     }
// //   }
  
// //   Future<void> AddHoliday(BuildContext context) async {
// //     final DateTime? pickedDate = await showDatePicker(
// //       context: context,
// //       initialDate: DateTime.now(),
// //       firstDate: DateTime(2000),
// //       lastDate: DateTime(2100),
// //     );

// //     if (pickedDate != null ) {
// //       setState(() {
// //         customHolidays.add(pickedDate);
// //       });
// //     }
// //   }
// //   @override
// //   Widget build(BuildContext context) {
 
// //     return Scaffold(
// //       appBar: AppBar(
// //         leading:    IconButton(onPressed:(){
// //         Navigator.push(
// //           context,
// //           MaterialPageRoute(builder:(context) => CustomGanttChart(token: widget.token,templateId: widget.templateId,) )
// //         );
// //         }
// //         , icon:Icon( Icons.arrow_back)
// //         ),
// //         title: Row(children: [
       
// //         Text('Settings'),
// //         ]
// //         )
// //         ,),
// //       body: ListView(
// //         children: [
// //           SwitchListTile.adaptive(
// //             value: showDaysRow,
// //             title: const Text('Show Days Row?'),
// //             onChanged: (v) => setState(() => showDaysRow = v),
// //           ),
// //           SwitchListTile.adaptive(
// //             value: showStickyArea!,
// //             title: const Text('Show Sticky Area?'),
// //             onChanged: (v) => setState(() => showStickyArea = v),
// //           ),
// //           SwitchListTile.adaptive(
// //             value: customWeekHeader,
// //             title: const Text('Custom Week Header?'),
// //             onChanged: (v) => setState(() => customWeekHeader = v),
// //           ),
// //           SwitchListTile.adaptive(
// //             value: customDayHeader,
// //             title: const Text('Custom Day Header?'),
// //             onChanged: (v) => setState(() => customDayHeader = v),
// //           ),
// //           ListTile(
// //             title: Text('Start Date'),
// //             trailing: IconButton(onPressed: (){
// //  _selectDate(context);
// //             },
// //              icon: Icon(Icons.date_range)),
// //           ),
// //              ListTile(
// //             title: Text('Add Holiday'),
// //             trailing: IconButton(onPressed: (){
// //  AddHoliday(context);
// //             },
// //              icon: Icon(Icons.date_range)),
// //           )
// //         ],
// //       ),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:frontend1/templates/collaboration_template/ghantChart.dart';

// class SettingsPage extends StatefulWidget {
//   final String token;
//   final String templateId;

//   SettingsPage({required this.token, required this.templateId});

//   @override
//   _SettingsPageState createState() => _SettingsPageState();
// }

// class _SettingsPageState extends State<SettingsPage> {
//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: selectedDate ?? DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2100),
//     );

//     if (pickedDate != null && pickedDate != selectedDate) {
//       setState(() {
//         selectedDate = pickedDate;
//       });
//     }
//   }

//   Future<void> AddHoliday(BuildContext context) async {
//     final DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2100),
//     );

//     if (pickedDate != null) {
//       setState(() {
//         customHolidays.add(pickedDate);
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => CustomGanttChart(
//                   token: widget.token,
//                   templateId: widget.templateId,
//                 ),
//               ),
//             );
//           },
//         ),
//         title: Text(
//           'Settings',
//           style: GoogleFonts.montserrat(
//             fontWeight: FontWeight.bold,
//             fontSize: 20,
//             color: Colors.black,
//           ),
//         ),
//         iconTheme: const IconThemeData(color: Colors.black),
//       ),
//       body: ListView(
//         children: [
//           SwitchListTile.adaptive(
//             activeColor: Colors.blue[800],
//             title: Text(
//               'Show Days Row?',
//               style: GoogleFonts.montserrat(
//                 fontSize: 14,
//                 color: Colors.black87,
//               ),
//             ),
//             value: showDaysRow,
//             onChanged: (v) => setState(() => showDaysRow = v),
//           ),
//           SwitchListTile.adaptive(
//             activeColor: Colors.blue[800],
//             title: Text(
//               'Show Sticky Area?',
//               style: GoogleFonts.montserrat(
//                 fontSize: 14,
//                 color: Colors.black87,
//               ),
//             ),
//             value: showStickyArea,
//             onChanged: (v) => setState(() => showStickyArea = v),
//           ),
//           SwitchListTile.adaptive(
//             activeColor: Colors.blue[800],
//             title: Text(
//               'Custom Week Header?',
//               style: GoogleFonts.montserrat(
//                 fontSize: 14,
//                 color: Colors.black87,
//               ),
//             ),
//             value: customWeekHeader,
//             onChanged: (v) => setState(() => customWeekHeader = v),
//           ),
//           SwitchListTile.adaptive(
//             activeColor: Colors.blue[800],
//             title: Text(
//               'Custom Day Header?',
//               style: GoogleFonts.montserrat(
//                 fontSize: 14,
//                 color: Colors.black87,
//               ),
//             ),
//             value: customDayHeader,
//             onChanged: (v) => setState(() => customDayHeader = v),
//           ),
//           ListTile(
//             title: Text(
//               'Start Date',
//               style: GoogleFonts.montserrat(
//                 fontSize: 14,
//                 color: Colors.black87,
//               ),
//             ),
//             trailing: IconButton(
//               icon: Icon(Icons.date_range, color: Colors.blue[800]),
//               onPressed: () {
//                 _selectDate(context);
//               },
//               tooltip: "Select Start Date",
//             ),
//           ),
//           ListTile(
//             title: Text(
//               'Add Holiday',
//               style: GoogleFonts.montserrat(
//                 fontSize: 14,
//                 color: Colors.black87,
//               ),
//             ),
//             trailing: IconButton(
//               icon: Icon(Icons.date_range, color: Colors.blue[800]),
//               onPressed: () {
//                 AddHoliday(context);
//               },
//               tooltip: "Add Holiday",
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend1/templates/collaboration_template/ghantChart.dart';

// Global Variables
bool showDaysRow = true;
bool showStickyArea = false;
bool customWeekHeader = false;
bool customDayHeader = false;
DateTime? selectedDate;
final List<DateTime> customHolidays = [];

class SettingsPage extends StatefulWidget {
  final String token;
  final String templateId;

  const SettingsPage({super.key, required this.token, required this.templateId});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  Future<void> addHoliday(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        customHolidays.add(pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CustomGanttChart(
                  token: widget.token,
                  templateId: widget.templateId,
                ),
              ),
            );
          },
        ),
        title: Text(
          'Settings',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView(
        children: [
          SwitchListTile.adaptive(
            activeColor: Colors.blue[800],
            title: Text(
              'Show Days Row?',
              style: GoogleFonts.montserrat(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
            value: showDaysRow,
            onChanged: (v) => setState(() => showDaysRow = v),
          ),
          SwitchListTile.adaptive(
            activeColor: Colors.blue[800],
            title: Text(
              'Show Sticky Area?',
              style: GoogleFonts.montserrat(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
            value: showStickyArea,
            onChanged: (v) => setState(() => showStickyArea = v),
          ),
          SwitchListTile.adaptive(
            activeColor: Colors.blue[800],
            title: Text(
              'Custom Week Header?',
              style: GoogleFonts.montserrat(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
            value: customWeekHeader,
            onChanged: (v) => setState(() => customWeekHeader = v),
          ),
          SwitchListTile.adaptive(
            activeColor: Colors.blue[800],
            title: Text(
              'Custom Day Header?',
              style: GoogleFonts.montserrat(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
            value: customDayHeader,
            onChanged: (v) => setState(() => customDayHeader = v),
          ),
          ListTile(
            title: Text(
              'Start Date',
              style: GoogleFonts.montserrat(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
            trailing: IconButton(
              icon: Icon(Icons.date_range, color: Colors.blue[800]),
              onPressed: () {
                _selectDate(context);
              },
              tooltip: "Select Start Date",
            ),
          ),
          ListTile(
            title: Text(
              'Add Holiday',
              style: GoogleFonts.montserrat(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
            trailing: IconButton(
              icon: Icon(Icons.date_range, color: Colors.blue[800]),
              onPressed: () {
                addHoliday(context);
              },
              tooltip: "Add Holiday",
            ),
          ),
        ],
      ),
    );
  }
}

