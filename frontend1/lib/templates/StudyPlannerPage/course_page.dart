import 'package:flutter/material.dart';

class CoursesPage extends StatelessWidget {
  const CoursesPage({super.key});

  void openCoursePage(BuildContext context, String courseName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CourseDetailPage(courseName: courseName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Courses'),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.all(8.0),
        childAspectRatio: 3 / 2,
        children: [
          CourseCard(
            courseName: 'Maths',
            imageUrl: 'https://example.com/math_image.jpg',
            progress: 42,
            goalGrade: 90,
            onTap: () => openCoursePage(context, 'Maths'),
          ),
          CourseCard(
            courseName: 'Chemistry',
            imageUrl: 'https://example.com/chemistry_image.jpg',
            progress: 13,
            goalGrade: 90,
            onTap: () => openCoursePage(context, 'Chemistry'),
          ),
          CourseCard(
            courseName: 'Economics',
            imageUrl: 'https://example.com/economics_image.jpg',
            progress: 40,
            goalGrade: 80,
            onTap: () => openCoursePage(context, 'Economics'),
          ),
          CourseCard(
            courseName: 'Statistics',
            imageUrl: 'https://example.com/statistics_image.jpg',
            progress: 67,
            goalGrade: 80,
            onTap: () => openCoursePage(context, 'Statistics'),
          ),
        ],
      ),
    );
  }
}

class CourseCard extends StatelessWidget {
  final String courseName;
  final String imageUrl;
  final int progress;
  final int goalGrade;
  final VoidCallback onTap;

  const CourseCard({super.key, 
    required this.courseName,
    required this.imageUrl,
    required this.progress,
    required this.goalGrade,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12.0)),
              child: Image.network(
                imageUrl,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    courseName,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text('$progress%'),
                  LinearProgressIndicator(
                    value: progress / 100,
                    minHeight: 6,
                  ),
                  SizedBox(height: 8),
                  Text('Goal Grade: $goalGrade%'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CourseDetailPage extends StatelessWidget {
  final String courseName;

  const CourseDetailPage({super.key, required this.courseName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(courseName),
      ),
      body: Center(
        child: Text('Welcome to $courseName page'),
      ),
    );
  }
}
