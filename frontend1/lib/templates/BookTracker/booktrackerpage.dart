// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:syncfusion_flutter_charts/charts.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:frontend1/config.dart';

// class BookTrackerPage extends StatefulWidget {
//   final String token;
//   final String templateId;

//   const BookTrackerPage({
//     Key? key,
//     required this.token,
//     required this.templateId,
//   }) : super(key: key);

//   @override
//   _BookTrackerPageState clsState() => _BookTrackerPageState();
// }

// class _BookTrackerPageState extends State<BookTrackerPage>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;

//   // Data
//   List<dynamic> readingList = [];
//   List<dynamic> wishlist = [];
//   List<dynamic> recommendations = [];
//   List<dynamic> highlights = [];

//   bool isLoading = false;

//   // For chart: we'll group rating distribution by rating 0..5
//   List<_RatingCount> ratingData = [];

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 4, vsync: this);
//     _fetchAllData();
//   }

//   Future<void> _fetchAllData() async {
//     setState(() => isLoading = true);

//     await Future.wait([
//       _fetchReadingList(),
//       _fetchWishlist(),
//       _fetchRecommendations(),
//       _fetchHighlights(),
//     ]);

//     // Build rating data after readingList is fetched
//     _buildRatingData();

//     setState(() => isLoading = false);
//   }

//   void _buildRatingData() {
//     // Count how many books have each rating (0..5)
//     final Map<int, int> ratingCounts = {0: 0, 1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
//     for (var book in readingList) {
//       final rating = (book['rating'] ?? 0).toInt();
//       if (ratingCounts.containsKey(rating)) {
//         ratingCounts[rating] = ratingCounts[rating]! + 1;
//       }
//     }

//     // Convert to a list for the chart
//     final newData = ratingCounts.entries
//         .map((e) => _RatingCount(e.key, e.value))
//         .toList();

//     setState(() {
//       ratingData = newData;
//     });
//   }

//   Future<void> _fetchReadingList() async {
//     try {
//       final response = await http.get(
//         Uri.parse("http://$localhost/api/booktracker/readinglist/${widget.templateId}"),
//         headers: {
//           'Authorization': 'Bearer ${widget.token}',
//         },
//       );
//       if (response.statusCode == 200) {
//         setState(() {
//           readingList = jsonDecode(response.body)['readingList'] ?? [];
//         });
//       }
//     } catch (e) {
//       debugPrint('Error fetching reading list: $e');
//     }
//   }

//   Future<void> _fetchWishlist() async {
//     try {
//       final response = await http.get(
//         Uri.parse("http://$localhost/api/booktracker/wishlist/${widget.templateId}"),
//         headers: {
//           'Authorization': 'Bearer ${widget.token}',
//         },
//       );
//       if (response.statusCode == 200) {
//         setState(() {
//           wishlist = jsonDecode(response.body)['wishlist'] ?? [];
//         });
//       }
//     } catch (e) {
//       debugPrint('Error fetching wishlist: $e');
//     }
//   }

//   Future<void> _fetchRecommendations() async {
//     try {
//       final response = await http.get(
//         Uri.parse("http://$localhost/api/booktracker/recommendations/${widget.templateId}"),
//         headers: {
//           'Authorization': 'Bearer ${widget.token}',
//         },
//       );
//       if (response.statusCode == 200) {
//         setState(() {
//           recommendations = jsonDecode(response.body)['recommendations'] ?? [];
//         });
//       }
//     } catch (e) {
//       debugPrint('Error fetching recommendations: $e');
//     }
//   }

//   Future<void> _fetchHighlights() async {
//     try {
//       final response = await http.get(
//         Uri.parse("http://$localhost/api/booktracker/highlights/${widget.templateId}"),
//         headers: {
//           'Authorization': 'Bearer ${widget.token}',
//         },
//       );
//       if (response.statusCode == 200) {
//         setState(() {
//           highlights = jsonDecode(response.body)['highlights'] ?? [];
//         });
//       }
//     } catch (e) {
//       debugPrint('Error fetching highlights: $e');
//     }
//   }

//   // CRUD for reading list
//   Future<void> _addBookToReadingList(Map<String, dynamic> book) async {
//     try {
//       final response = await http.post(
//         Uri.parse("http://$localhost/api/booktracker/readinglist"),
//         headers: {
//           'Authorization': 'Bearer ${widget.token}',
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode({"trackerId": widget.templateId, "book": book}),
//       );
//       if (response.statusCode == 200) {
//         await _fetchReadingList();
//         _buildRatingData();
//       }
//     } catch (e) {
//       debugPrint('Error adding book: $e');
//     }
//   }

//   Future<void> _updateBookStatus({
//     required String bookId,
//     String? status,
//     double? progress,
//     double? rating,
//     String? review,
//   }) async {
//     try {
//       final response = await http.put(
//         Uri.parse("http://$localhost/api/booktracker/readinglist"),
//         headers: {
//           'Authorization': 'Bearer ${widget.token}',
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode({
//           "trackerId": widget.templateId,
//           "bookId": bookId,
//           "status": status,
//           "progress": progress,
//           "rating": rating,
//           "review": review,
//         }),
//       );
//       if (response.statusCode == 200) {
//         await _fetchReadingList();
//         _buildRatingData();
//       }
//     } catch (e) {
//       debugPrint('Error updating book: $e');
//     }
//   }

//   Future<void> _deleteBookFromReadingList(String bookId) async {
//     try {
//       final response = await http.delete(
//         Uri.parse("http://$localhost/api/booktracker/readinglist"),
//         headers: {
//           'Authorization': 'Bearer ${widget.token}',
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode({"trackerId": widget.templateId, "bookId": bookId}),
//       );
//       if (response.statusCode == 200) {
//         await _fetchReadingList();
//         _buildRatingData();
//       } else {
//         debugPrint('Delete failed: ${response.body}');
//       }
//     } catch (e) {
//       debugPrint('Error deleting book: $e');
//     }
//   }

//   // Additional CRUD for wishlist, recommendations, highlights omitted for brevity...
//   // (They remain the same as before)

//   // Helper method to show 'Add Book' dialog
//   Future<void> _showAddBookDialog(Function(Map<String, dynamic>) onSubmit) async {
//     final _formKey = GlobalKey<FormState>();
//     final Map<String, dynamic> bookData = {
//       'title': '',
//       'author': '',
//       'genre': '',
//       'status': 'To Read',
//       'rating': 0,
//     };

//     await showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//           title: Text(
//             'Add Book',
//             style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
//           ),
//           content: Form(
//             key: _formKey,
//             child: SingleChildScrollView(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   TextFormField(
//                     decoration: InputDecoration(
//                       labelText: 'Title',
//                       labelStyle: GoogleFonts.montserrat(),
//                     ),
//                     onSaved: (value) => bookData['title'] = value ?? '',
//                     validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
//                   ),
//                   TextFormField(
//                     decoration: InputDecoration(
//                       labelText: 'Author',
//                       labelStyle: GoogleFonts.montserrat(),
//                     ),
//                     onSaved: (value) => bookData['author'] = value ?? '',
//                     validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
//                   ),
//                   TextFormField(
//                     decoration: InputDecoration(
//                       labelText: 'Genre',
//                       labelStyle: GoogleFonts.montserrat(),
//                     ),
//                     onSaved: (value) => bookData['genre'] = value ?? '',
//                     validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           actions: [
//             TextButton(
//               child: Text('Cancel', style: GoogleFonts.montserrat(color: Colors.red)),
//               onPressed: () => Navigator.pop(context),
//             ),
//             TextButton(
//               child: Text('Add', style: GoogleFonts.montserrat(color: Colors.blue)),
//               onPressed: () {
//                 if (_formKey.currentState?.validate() ?? false) {
//                   _formKey.currentState?.save();
//                   onSubmit(bookData);
//                   Navigator.pop(context);
//                 }
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   // Build UI
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // Style like your DynamicTablePage
//       appBar: AppBar(
//         title: Text(
//           "Book Tracker",
//           style: GoogleFonts.montserrat(
//             color: Colors.black,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         backgroundColor: Colors.white,
//         elevation: 0,
//         iconTheme: const IconThemeData(color: Colors.black),
//         bottom: TabBar(
//           controller: _tabController,
//           labelColor: Colors.blue,
//           unselectedLabelColor: Colors.grey,
//           indicatorColor: Colors.blue,
//           tabs: const [
//             Tab(text: "Reading List"),
//             Tab(text: "Wishlist"),
//             Tab(text: "Recommendations"),
//             Tab(text: "Highlights"),
//           ],
//         ),
//       ),
//       backgroundColor: Colors.grey[50],
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // By default, we'll add a new book to reading list
//           _showAddBookDialog((bookData) {
//             _addBookToReadingList(bookData);
//           });
//         },
//         child: const Icon(Icons.add),
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : TabBarView(
//               controller: _tabController,
//               children: [
//                 _readingListTab(), 
//                 _wishlistTab(),
//                 _recommendationsTab(),
//                 _highlightsTab(),
//               ],
//             ),
//     );
//   }

//   // 2.1. Reading List
//   Widget _readingListTab() {
//     return Column(
//       children: [
//         // Chart for ratings
//         _buildRatingChart(),
//         Expanded(
//           child: readingList.isEmpty
//               ? Center(
//                   child: Text(
//                     'No books in reading list',
//                     style: GoogleFonts.montserrat(
//                       color: Colors.grey,
//                       fontSize: 16,
//                     ),
//                   ),
//                 )
//               : Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: GridView.builder(
//                     itemCount: readingList.length,
//                     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 2,
//                       childAspectRatio: 0.7,
//                       crossAxisSpacing: 8,
//                       mainAxisSpacing: 8,
//                     ),
//                     itemBuilder: (context, index) {
//                       final book = readingList[index];
//                       return _buildBookCard(book);
//                     },
//                   ),
//                 ),
//         ),
//       ],
//     );
//   }

//   Widget _buildRatingChart() {
//     return Container(
//       margin: const EdgeInsets.only(top: 8, bottom: 8),
//       height: 200,
//       color: Colors.white,
//       child: SfCartesianChart(
//         title: ChartTitle(
//           text: 'Rating Distribution',
//           textStyle: GoogleFonts.montserrat(
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//             color: Colors.black,
//           ),
//         ),
//         primaryXAxis: CategoryAxis(
//           labelStyle: GoogleFonts.montserrat(),
//         ),
//         primaryYAxis: NumericAxis(
//           title: AxisTitle(
//             text: 'Count',
//             textStyle: GoogleFonts.montserrat(),
//           ),
//         ),
//         series: <ChartSeries<_RatingCount, String>>[
//           ColumnSeries<_RatingCount, String>(
//             dataSource: ratingData,
//             xValueMapper: (_RatingCount data, _) => data.rating.toString(),
//             yValueMapper: (_RatingCount data, _) => data.count,
//             dataLabelSettings: const DataLabelSettings(isVisible: true),
//             color: Colors.blue,
//             width: 0.4,
//           )
//         ],
//       ),
//     );
//   }

//   Widget _buildBookCard(Map<String, dynamic> book) {
//     final title = book['title'] ?? 'No Title';
//     final author = book['author'] ?? 'No Author';
//     final coverUrl = book['coverUrl'] ??
//         'https://via.placeholder.com/150?text=No+Cover'; // Use placeholder
//     final status = book['status'] ?? 'To Read';
//     final double rating = (book['rating'] ?? 0).toDouble();
//     final String bookId = book['_id'] ?? '';

//     return Card(
//       elevation: 3,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: InkWell(
//         borderRadius: BorderRadius.circular(12),
//         onTap: () => _showBookDetailDialog(book),
//         child: Column(
//           children: [
//             Expanded(
//               child: ClipRRect(
//                 borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
//                 child: Image.network(
//                   coverUrl,
//                   fit: BoxFit.cover,
//                   width: double.infinity,
//                 ),
//               ),
//             ),
//             ListTile(
//               title: Text(
//                 title,
//                 style: GoogleFonts.montserrat(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               subtitle: Text(
//                 author,
//                 style: GoogleFonts.montserrat(fontSize: 12),
//               ),
//               trailing: IconButton(
//                 icon: const Icon(Icons.delete, color: Colors.red),
//                 onPressed: () {
//                   // Delete book
//                   if (bookId.isNotEmpty) {
//                     _deleteBookFromReadingList(bookId);
//                   }
//                 },
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(bottom: 8.0),
//               child: Text(
//                 "Status: $status | Rating: ${rating.toStringAsFixed(1)}",
//                 style: GoogleFonts.montserrat(
//                   fontSize: 12,
//                   color: Colors.grey[700],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _showBookDetailDialog(Map<String, dynamic> book) async {
//     final _formKey = GlobalKey<FormState>();
//     double progress = (book['progress'] ?? 0).toDouble();
//     double rating = (book['rating'] ?? 0).toDouble();
//     String review = book['review'] ?? '';
//     String bookId = book['_id'] ?? '';

//     return showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//           title: Text(
//             book['title'] ?? '',
//             style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
//           ),
//           content: Form(
//             key: _formKey,
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   if (book['author'] != null)
//                     Text("by ${book['author']}",
//                         style: GoogleFonts.montserrat(color: Colors.grey)),
//                   const SizedBox(height: 12),
//                   // Progress
//                   Text("Progress: ${progress.toStringAsFixed(0)}%",
//                       style: GoogleFonts.montserrat(fontWeight: FontWeight.w500)),
//                   Slider(
//                     value: progress,
//                     min: 0,
//                     max: 100,
//                     divisions: 100,
//                     label: "${progress.toStringAsFixed(0)}%",
//                     onChanged: (val) {
//                       setState(() => progress = val);
//                     },
//                   ),
//                   const SizedBox(height: 8),
//                   // Rating
//                   Text("Rating: ${rating.toStringAsFixed(1)} / 5",
//                       style: GoogleFonts.montserrat(fontWeight: FontWeight.w500)),
//                   Slider(
//                     value: rating,
//                     min: 0,
//                     max: 5,
//                     divisions: 5,
//                     label: rating.toStringAsFixed(1),
//                     onChanged: (val) {
//                       setState(() => rating = val);
//                     },
//                   ),
//                   const SizedBox(height: 8),
//                   // Review
//                   TextFormField(
//                     initialValue: review,
//                     maxLines: 3,
//                     decoration: InputDecoration(
//                       labelText: 'Review',
//                       labelStyle: GoogleFonts.montserrat(),
//                     ),
//                     onSaved: (val) => review = val ?? '',
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           actions: [
//             TextButton(
//               child: Text('Cancel', style: GoogleFonts.montserrat(color: Colors.red)),
//               onPressed: () => Navigator.pop(context),
//             ),
//             TextButton(
//               child: Text('Save', style: GoogleFonts.montserrat(color: Colors.blue)),
//               onPressed: () {
//                 _formKey.currentState?.save();
//                 // Update the book
//                 _updateBookStatus(
//                   bookId: bookId,
//                   progress: progress,
//                   rating: rating,
//                   review: review,
//                 );
//                 Navigator.pop(context);
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   // 2.2. Wishlist Tab
//   Widget _wishlistTab() {
//     return Center(
//       child: Text(
//         "Wishlist feature here...",
//         style: GoogleFonts.montserrat(
//           color: Colors.grey,
//           fontSize: 16,
//         ),
//       ),
//     );
//   }

//   // 2.3. Recommendations Tab
//   Widget _recommendationsTab() {
//     return Center(
//       child: Text(
//         "Recommendations feature here...",
//         style: GoogleFonts.montserrat(
//           color: Colors.grey,
//           fontSize: 16,
//         ),
//       ),
//     );
//   }

//   // 2.4. Highlights Tab
//   Widget _highlightsTab() {
//     return Center(
//       child: Text(
//         "Highlights feature here...",
//         style: GoogleFonts.montserrat(
//           color: Colors.grey,
//           fontSize: 16,
//         ),
//       ),
//     );
//   }
// }

// // Simple model to hold rating distribution data
// class _RatingCount {
//   final int rating;
//   final int count;
//   _RatingCount(this.rating, this.count);
// }


import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend1/config.dart';

class BookTrackerPage extends StatefulWidget {
  final String token;
  final String templateId;

  const BookTrackerPage({
    Key? key,
    required this.token,
    required this.templateId,
  }) : super(key: key);

  @override
  _BookTrackerPageState createState() => _BookTrackerPageState();
}

class _BookTrackerPageState extends State<BookTrackerPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Data
  List<dynamic> readingList = [];
  List<dynamic> wishlist = [];
  List<dynamic> recommendations = [];
  List<dynamic> highlights = [];

  bool isLoading = false;

  // For bar chart rating distribution
  List<_RatingCount> ratingData = [];

  // For pie chart: finished vs. not finished
  List<_CompletionCount> completionData = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _fetchAllData();
  }

  Future<void> _fetchAllData() async {
    setState(() => isLoading = true);

    await Future.wait([
      _fetchReadingList(),
      _fetchWishlist(),
      _fetchRecommendations(),
      _fetchHighlights(),
    ]);

    // Build both rating distribution and completion data
    _buildRatingData();
    _buildCompletionData();

    setState(() => isLoading = false);
  }

  // 1.1. Build rating distribution for the bar chart
  void _buildRatingData() {
    // Count how many books have each rating (0..5)
    final Map<int, int> ratingCounts = {0: 0, 1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
    for (var book in readingList) {
      final rating = (book['rating'] ?? 0).toInt();
      if (ratingCounts.containsKey(rating)) {
        ratingCounts[rating] = ratingCounts[rating]! + 1;
      }
    }

    // Convert to a list for the chart
    final newData = ratingCounts.entries
        .map((e) => _RatingCount(e.key, e.value))
        .toList();

    setState(() {
      ratingData = newData;
    });
  }

  // 1.2. Build completion data for the pie chart
  void _buildCompletionData() {
    // For example, let’s define "Finished" if status == "Finished"
    int finishedCount = 0;
    int notFinishedCount = 0;

    for (var book in readingList) {
      final status = (book['status'] ?? 'To Read') as String;
      if (status == "Finished") {
        finishedCount++;
      } else {
        notFinishedCount++;
      }
    }

    setState(() {
      completionData = [
        _CompletionCount("Finished", finishedCount),
        _CompletionCount("Not Finished", notFinishedCount),
      ];
    });
  }

  Future<void> _fetchReadingList() async {
    try {
      final response = await http.get(
        Uri.parse("http://$localhost/api/booktracker/readinglist/${widget.templateId}"),
        headers: {
          'Authorization': 'Bearer ${widget.token}',
        },
      );
      if (response.statusCode == 200) {
        setState(() {
          readingList = jsonDecode(response.body)['readingList'] ?? [];
        });
      }
    } catch (e) {
      debugPrint('Error fetching reading list: $e');
    }
  }

  Future<void> _fetchWishlist() async {
    try {
      final response = await http.get(
        Uri.parse("http://$localhost/api/booktracker/wishlist/${widget.templateId}"),
        headers: {
          'Authorization': 'Bearer ${widget.token}',
        },
      );
      if (response.statusCode == 200) {
        setState(() {
          wishlist = jsonDecode(response.body)['wishlist'] ?? [];
        });
      }
    } catch (e) {
      debugPrint('Error fetching wishlist: $e');
    }
  }

  Future<void> _fetchRecommendations() async {
    try {
      final response = await http.get(
        Uri.parse("http://$localhost/api/booktracker/recommendations/${widget.templateId}"),
        headers: {
          'Authorization': 'Bearer ${widget.token}',
        },
      );
      if (response.statusCode == 200) {
        setState(() {
          recommendations = jsonDecode(response.body)['recommendations'] ?? [];
        });
      }
    } catch (e) {
      debugPrint('Error fetching recommendations: $e');
    }
  }

  Future<void> _fetchHighlights() async {
    try {
      final response = await http.get(
        Uri.parse("http://$localhost/api/booktracker/highlights/${widget.templateId}"),
        headers: {
          'Authorization': 'Bearer ${widget.token}',
        },
      );
      if (response.statusCode == 200) {
        setState(() {
          highlights = jsonDecode(response.body)['highlights'] ?? [];
        });
      }
    } catch (e) {
      debugPrint('Error fetching highlights: $e');
    }
  }

  Future<void> _addBookToReadingList(Map<String, dynamic> book) async {
  try {
    final response = await http.post(
      Uri.parse("http://$localhost/api/booktracker/readinglist"),
      headers: {
        'Authorization': 'Bearer ${widget.token}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "trackerId": widget.templateId,
        "book": {
          "title": book['title'],
          "author": book['author'],
          "genre": book['genre'],
          "status": book['status'],
          "rating": book['rating'],
          "coverUrl": book['coverUrl'],
        },
      }),
    );
    if (response.statusCode == 200) {
      await _fetchReadingList();
      _buildRatingData();
      _buildCompletionData();
    } else {
      debugPrint('Failed to add book: ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add book: ${response.body}')),
      );
    }
  } catch (e) {
    debugPrint('Error adding book: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error adding book: $e')),
    );
  }
}

  /// IMPORTANT: We'll update rating/progress immediately when the user releases the slider
  /// to see changes on the backend in real-time. Alternatively, you could call the update only on "Save".
  Future<void> _updateBookStatus({
    required String bookId,
    String? status,
    double? progress,
    double? rating,
    String? review,
  }) async {
    try {
      final response = await http.put(
        Uri.parse("http://$localhost/api/booktracker/readinglist"),
        headers: {
          'Authorization': 'Bearer ${widget.token}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "trackerId": widget.templateId,
          "bookId": bookId,
          "status": status,
          "progress": progress,
          "rating": rating,
          "review": review,
        }),
      );
      if (response.statusCode == 200) {
        await _fetchReadingList();
        _buildRatingData();
        _buildCompletionData();
      } else {
        debugPrint('Error updating book: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error updating book: $e');
    }
  }

  Future<void> _deleteBookFromReadingList(String bookId) async {
    try {
      final response = await http.delete(
        Uri.parse("http://$localhost/api/booktracker/readinglist"),
        headers: {
          'Authorization': 'Bearer ${widget.token}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({"trackerId": widget.templateId, "bookId": bookId}),
      );
      if (response.statusCode == 200) {
        await _fetchReadingList();
        _buildRatingData();
        _buildCompletionData();
      } else {
        debugPrint('Delete failed: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error deleting book: $e');
    }
  }

  // Additional CRUD for wishlist, recommendations, highlights omitted for brevity...

  Future<void> _showAddBookDialog(Function(Map<String, dynamic>) onSubmit) async {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> bookData = {
    'title': '',
    'author': '',
    'genre': '',
    'status': 'To Read',
    'rating': 0,
    'coverUrl': '', // New field for image URL
  };

  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(
          'Add Book',
          style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
        ),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title Field
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Title',
                    labelStyle: GoogleFonts.montserrat(),
                  ),
                  onSaved: (value) => bookData['title'] = value ?? '',
                  validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                ),
                SizedBox(height: 8),
                // Author Field
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Author',
                    labelStyle: GoogleFonts.montserrat(),
                  ),
                  onSaved: (value) => bookData['author'] = value ?? '',
                  validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                ),
                SizedBox(height: 8),
                // Genre Field
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Genre',
                    labelStyle: GoogleFonts.montserrat(),
                  ),
                  onSaved: (value) => bookData['genre'] = value ?? '',
                  validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                ),
                SizedBox(height: 8),
                // Cover URL Field (Optional)
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Cover Image URL',
                    labelStyle: GoogleFonts.montserrat(),
                    hintText: 'https://example.com/image.jpg',
                  ),
                  onSaved: (value) => bookData['coverUrl'] = value ?? '',
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      final urlPattern = r'(http(s?):)([/|.|\w|\s|-])*\.(?:jpg|gif|png)';
                      final result = RegExp(urlPattern, caseSensitive: false).firstMatch(value);
                      if (result == null) {
                        return 'Enter a valid image URL';
                      }
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            child: Text('Cancel', style: GoogleFonts.montserrat(color: Colors.red)),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text('Add', style: GoogleFonts.montserrat(color: Colors.blue)),
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                _formKey.currentState?.save();
                // If coverUrl is empty, set it to a default placeholder
                if (bookData['coverUrl'].isEmpty) {
                  bookData['coverUrl'] = 'https://via.placeholder.com/150?text=No+Cover';
                }
                onSubmit(bookData);
                Navigator.pop(context);
              }
            },
          ),
        ],
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Style like your DynamicTablePage
      appBar: AppBar(
        title: Text(
          "Book Tracker",
          style: GoogleFonts.montserrat(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.blue,
          tabs: const [
            Tab(text: "Reading List"),
            Tab(text: "Wishlist"),
            Tab(text: "Recommendations"),
            Tab(text: "Highlights"),
          ],
        ),
      ),
      backgroundColor: Colors.grey[50],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // By default, we'll add a new book to reading list
          _showAddBookDialog((bookData) {
            _addBookToReadingList(bookData);
          });
        },
        child: const Icon(Icons.add),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _readingListTab(), 
                _wishlistTab(),
                _recommendationsTab(),
                _highlightsTab(),
              ],
            ),
    );
  }

  // --------------------------------------------
  // 2. READING LIST TAB (with 2 charts + grid)
  // --------------------------------------------
  Widget _readingListTab() {
    // We’ll have a Column with the bar chart (ratings),
    // then the pie chart (finish vs. not finish),
    // then the grid of books
    return Column(
      children: [
        _buildRatingChart(),
        _buildCompletionPieChart(),
        Expanded(
          child: readingList.isEmpty
              ? Center(
                  child: Text(
                    'No books in reading list',
                    style: GoogleFonts.montserrat(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    itemCount: readingList.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemBuilder: (context, index) {
                      final book = readingList[index];
                      return _buildBookCard(book);
                    },
                  ),
                ),
        ),
      ],
    );
  }

  /// 2.1: Bar Chart for rating distribution
  Widget _buildRatingChart() {
    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 8),
      height: 150,
      color: Colors.white,
      child: SfCartesianChart(
        title: ChartTitle(
          text: 'Rating Distribution',
          textStyle: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        primaryXAxis: CategoryAxis(
          labelStyle: GoogleFonts.montserrat(),
        ),
        primaryYAxis: NumericAxis(
          title: AxisTitle(
            text: 'Count',
            textStyle: GoogleFonts.montserrat(),
          ),
        ),
        series: <ChartSeries<_RatingCount, String>>[
          ColumnSeries<_RatingCount, String>(
            dataSource: ratingData,
            xValueMapper: (_RatingCount data, _) => data.rating.toString(),
            yValueMapper: (_RatingCount data, _) => data.count,
            dataLabelSettings: const DataLabelSettings(isVisible: true),
            color: Colors.blue,
            width: 0.4,
          )
        ],
      ),
    );
  }

  /// 2.2: Pie chart for Finished vs Not Finished
  Widget _buildCompletionPieChart() {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      height: 150,
      color: Colors.white,
      child: SfCircularChart(
        title: ChartTitle(
          text: 'Completion Status',
          textStyle: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        legend: Legend(isVisible: true),
        series: <CircularSeries>[
          PieSeries<_CompletionCount, String>(
            dataSource: completionData,
            xValueMapper: (_CompletionCount data, _) => data.label,
            yValueMapper: (_CompletionCount data, _) => data.count,
            dataLabelSettings: const DataLabelSettings(isVisible: true),
          )
        ],
      ),
    );
  }

 Widget _buildBookCard(Map<String, dynamic> book) {
  final title = book['title'] ?? 'No Title';
  final author = book['author'] ?? 'No Author';
  final coverUrl = book['coverUrl'] ??
      'https://via.placeholder.com/150?text=No+Cover'; // Use placeholder
  final status = book['status'] ?? 'To Read';
  final double rating = (book['rating'] ?? 0).toDouble();
  final String bookId = book['_id'] ?? '';

  return Card(
    elevation: 3,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => _showBookDetailDialog(book),
      child: Column(
        children: [
          // Book Cover Image
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                coverUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return Image.network(
                    'https://via.placeholder.com/150?text=No+Cover',
                    fit: BoxFit.cover,
                    width: double.infinity,
                  );
                },
              ),
            ),
          ),
          // Book Details
          ListTile(
            title: Text(
              title,
              style: GoogleFonts.montserrat(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              author,
              style: GoogleFonts.montserrat(fontSize: 12),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                // Delete book
                if (bookId.isNotEmpty) {
                  _deleteBookFromReadingList(bookId);
                }
              },
            ),
          ),
          // Status and Rating
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              "Status: $status | Rating: ${rating.toStringAsFixed(1)}",
              style: GoogleFonts.montserrat(
                fontSize: 12,
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

  // 2.4. Book Detail Dialog
  // We’ll call _updateBookStatus on slider "end" so changes are immediate in backend
  Future<void> _showBookDetailDialog(Map<String, dynamic> book) async {
    double progress = (book['progress'] ?? 0).toDouble();
    double rating = (book['rating'] ?? 0).toDouble();
    String review = book['review'] ?? '';
    String status = book['status'] ?? 'To Read';
    String bookId = book['_id'] ?? '';

    // We'll store them in local variables, then update on slider end
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setModalState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            title: Text(
              book['title'] ?? '',
              style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  if (book['author'] != null)
                    Text("by ${book['author']}",
                        style: GoogleFonts.montserrat(color: Colors.grey)),
                  const SizedBox(height: 12),

                  // Progress
                  Text("Progress: ${progress.toStringAsFixed(0)}%",
                      style: GoogleFonts.montserrat(fontWeight: FontWeight.w500)),
                  Slider(
                    value: progress,
                    min: 0,
                    max: 100,
                    divisions: 100,
                    label: "${progress.toStringAsFixed(0)}%",
                    onChanged: (val) {
                      setModalState(() => progress = val);
                    },
                    onChangeEnd: (val) {
                      // call update
                      _updateBookStatus(
                        bookId: bookId,
                        progress: val,
                        rating: rating,
                        review: review,
                        status: status,
                      );
                    },
                  ),
                  const SizedBox(height: 8),

                  // Rating
                  Text("Rating: ${rating.toStringAsFixed(1)} / 5",
                      style: GoogleFonts.montserrat(fontWeight: FontWeight.w500)),
                  Slider(
                    value: rating,
                    min: 0,
                    max: 5,
                    divisions: 5,
                    label: rating.toStringAsFixed(1),
                    onChanged: (val) {
                      setModalState(() => rating = val);
                    },
                    onChangeEnd: (val) {
                      _updateBookStatus(
                        bookId: bookId,
                        progress: progress,
                        rating: val,
                        review: review,
                        status: status,
                      );
                    },
                  ),
                  const SizedBox(height: 8),

                  // Status (To Read, Currently Reading, Finished)
                  // Could be a dropdown if you want
                  Row(
                    children: [
                      Text("Status: ", style: GoogleFonts.montserrat()),
                      DropdownButton<String>(
                        value: status,
                        onChanged: (newValue) {
                          setModalState(() => status = newValue ?? status);
                          // Update immediately
                          _updateBookStatus(
                            bookId: bookId,
                            progress: progress,
                            rating: rating,
                            review: review,
                            status: newValue,
                          );
                        },
                        items: <String>['To Read', 'Currently Reading', 'Finished']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value, style: GoogleFonts.montserrat()),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Review
                  TextFormField(
                    initialValue: review,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Review',
                      labelStyle: GoogleFonts.montserrat(),
                    ),
                    onChanged: (val) {
                      review = val;
                    },
                    onEditingComplete: () {
                      // Update when user finishes editing
                      _updateBookStatus(
                        bookId: bookId,
                        progress: progress,
                        rating: rating,
                        review: review,
                        status: status,
                      );
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: Text('Close', style: GoogleFonts.montserrat(color: Colors.blue)),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
      },
    );
  }

  // 3. WISHLIST TAB
  Widget _wishlistTab() {
    return Center(
      child: Text(
        "Wishlist feature here...",
        style: GoogleFonts.montserrat(
          color: Colors.grey,
          fontSize: 16,
        ),
      ),
    );
  }

  // 4. RECOMMENDATIONS TAB
  Widget _recommendationsTab() {
    return Center(
      child: Text(
        "Recommendations feature here...",
        style: GoogleFonts.montserrat(
          color: Colors.grey,
          fontSize: 16,
        ),
      ),
    );
  }

  // 5. HIGHLIGHTS TAB
  Widget _highlightsTab() {
    return Center(
      child: Text(
        "Highlights feature here...",
        style: GoogleFonts.montserrat(
          color: Colors.grey,
          fontSize: 16,
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------
// MODELS FOR CHARTS
// -----------------------------------------------------------------------

// For rating distribution bar chart
class _RatingCount {
  final int rating;
  final int count;
  _RatingCount(this.rating, this.count);
}

// For completion pie chart
class _CompletionCount {
  final String label;
  final int count;
  _CompletionCount(this.label, this.count);
}
