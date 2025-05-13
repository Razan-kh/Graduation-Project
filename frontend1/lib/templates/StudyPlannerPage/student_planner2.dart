import 'package:flutter/material.dart';
import 'package:frontend1/templates/StudyPlannerPage/CalenderPage.dart';
import 'package:frontend1/templates/StudyPlannerPage/clock_page.dart';
import 'package:frontend1/templates/StudyPlannerPage/study_scheduale.dart';
import 'package:frontend1/templates/StudyPlannerPage/reminders.dart';
import 'package:google_fonts/google_fonts.dart';

class StudentPlanner2App extends StatefulWidget {
  final String token;
  final String templateId;

  const StudentPlanner2App({super.key, required this.token, required this.templateId});
  @override
  _StudentPlanner2AppState createState() => _StudentPlanner2AppState();
}

class _StudentPlanner2AppState extends State<StudentPlanner2App> {
  final List<Course> _courses = [
    Course(
      name: 'Maths',
      imageUrl: 'https://i.pinimg.com/564x/25/4a/f7/254af7092746681f3c4f9784d2ca2641.jpg',
      progress: 42,
      goalGrade: 90,
    ),
    Course(
      name: 'Chemistry',
      imageUrl: 'https://i.pinimg.com/564x/8c/d2/18/8cd2181726e22347d0ce1dac59abbe97.jpg',
      progress: 13,
      goalGrade: 90,
    ),
    Course(
      name: 'Economics',
      imageUrl: 'https://i.pinimg.com/564x/84/aa/9a/84aa9aced14ef2623b5646d8e203e593.jpg',
      progress: 40,
      goalGrade: 80,
    ),
    Course(
      name: 'Statistics',
      imageUrl: 'https://i.pinimg.com/736x/67/cd/4f/67cd4f22428ca5b877c75a494599ac22.jpg',
      progress: 67,
      goalGrade: 80,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🐬 My Study Planner'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                'https://i.pinimg.com/564x/10/00/2a/10002a789d444975947998b337ceb985.jpg',
                fit: BoxFit.cover,
                height: 200,
                width: double.infinity,
              ),
            ),
            SizedBox(height: 16.0),
            FlipClockWidget(),
            SizedBox(height: 16.0),
            // TodoListTable(),
            SizedBox(height: 20.0),
            Container(
              color: Color.fromARGB(255, 235, 244, 247),
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              child: Text(
                "Study Schedule",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Georgia',
                  color: Colors.black87,
                ),
              ),
            ),
            SizedBox(height: 4.0),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: 1000,
                child: StudyScheduleApp(token: widget.token, templateId: widget.templateId),
              ),
            ),
            SizedBox(height: 16.0),
            Divider(color: Colors.grey[300], thickness: 1),
            TodoList(token: widget.token, templateId: widget.templateId),
            Divider(color: Colors.grey[300], thickness: 1),
            SizedBox(height: 16),

            // Courses Section
            Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              alignment: Alignment.centerLeft,
              child: Text(
                "Courses",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Georgia',
                  color: Colors.black87,
                ),
              ),
            ),
            SizedBox(height: 8.0),
            GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3 / 2,
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
              ),
              itemCount: _courses.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(), // Disable scrolling for GridView
              itemBuilder: (context, index) {
                return CourseCard(
                  courseName: _courses[index].name,
                  imageUrl: _courses[index].imageUrl,
                  progress: _courses[index].progress,
                  goalGrade: _courses[index].goalGrade,
                  onTap: () => _openCoursePage(context, _courses[index]),
                );
              },
            ),
            
            // Add New Course Button
            SizedBox(height: 16),
          Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: _showAddCourseDialog,
                  icon: Icon(Icons.add),
                  label: Text(""),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    'https://i.pinimg.com/564x/c4/e9/6c/c4e96c92dd85a33dc5ad84200dfb7f00.jpg',
                    fit: BoxFit.cover,
                    height: 180,
                    width: 180,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    '"Keep your face always toward the sunshine, and shadows will fall behind you." - Walt Whitman',
                    style: GoogleFonts.handlee(
                      fontSize: 28,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
           SizedBox(height: 16),
           SizedBox(
            height: 500,
            child: CalendarPage1()),
          ],
        
        ),
      ),
    );
  }

  void _showAddCourseDialog() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController imageUrlController = TextEditingController();
    final TextEditingController progressController = TextEditingController();
    final TextEditingController goalGradeController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add New Course'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Course Name'),
              ),
              TextField(
                controller: imageUrlController,
                decoration: InputDecoration(labelText: 'Image URL'),
              ),
              TextField(
                controller: progressController,
                decoration: InputDecoration(labelText: 'Progress (%)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: goalGradeController,
                decoration: InputDecoration(labelText: 'Goal Grade (%)'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Add the course
                setState(() {
                  _courses.add(Course(
                    name: nameController.text,
                    imageUrl: imageUrlController.text,
                    progress: int.tryParse(progressController.text) ?? 0,
                    goalGrade: int.tryParse(goalGradeController.text) ?? 0,
                  ));
                });
                Navigator.of(context).pop();
              },
              child: Text('Add Course'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _openCoursePage(BuildContext context, Course course) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CourseDetailPage(course: course),
      ),
    );
  }
}

// CourseCard widget to display each course
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
                height: 100,
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
                      fontSize: 16,
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
  final Course course;

  const CourseDetailPage({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(course.name),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                course.imageUrl,
                fit: BoxFit.cover,
                height: 200,
                width: double.infinity,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Course Name: ${course.name}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text('Progress: ${course.progress}%'),
            Text('Goal Grade: ${course.goalGrade}%'),
          ],
        ),
      ),
    );
  }
}

// Course class
class Course {
  final String name;
  final String imageUrl;
  final int progress;
  final int goalGrade;

  Course({
    required this.name,
    required this.imageUrl,
    required this.progress,
    required this.goalGrade,
  });
}