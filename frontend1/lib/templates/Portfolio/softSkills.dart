
/*import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


class MyPortfolioApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SkillsPage(),
    );
  }
}

class SkillsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Skills Section'),
        backgroundColor: Color(0xFFbb877a),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Soft Skills Section
            SkillCategorySection(
              categoryName: 'Communication',
              skills: [
                SoftSkillCard(
                  skillName: 'Public Speaking',
                  proficiency: 90,
                  description: 'Ability to speak clearly and confidently in front of an audience.',
                ),
                SoftSkillCard(
                  skillName: 'Active Listening',
                  proficiency: 85,
                  description: 'Listening attentively and responding appropriately to others.',
                ),
              ],
            ),
            SkillCategorySection(
              categoryName: 'Leadership',
              skills: [
                SoftSkillCard(
                  skillName: 'Team Management',
                  proficiency: 80,
                  description: 'Ability to manage and motivate a team to achieve goals.',
                ),
                SoftSkillCard(
                  skillName: 'Decision Making',
                  proficiency: 75,
                  description: 'Ability to make informed decisions under pressure.',
                ),
              ],
            ),
            SkillCategorySection(
              categoryName: 'Problem Solving',
              skills: [
                SoftSkillCard(
                  skillName: 'Creative Thinking',
                  proficiency: 90,
                  description: 'Ability to think outside the box and come up with innovative solutions.',
                ),
                SoftSkillCard(
                  skillName: 'Analytical Thinking',
                  proficiency: 85,
                  description: 'Breaking down complex issues and finding logical solutions.',
                ),
              ],
            ),
            SkillCategorySection(
              categoryName: 'Teamwork',
              skills: [
                SoftSkillCard(
                  skillName: 'Collaboration',
                  proficiency: 95,
                  description: 'Working effectively with others to achieve common goals.',
                ),
                SoftSkillCard(
                  skillName: 'Conflict Resolution',
                  proficiency: 80,
                  description: 'Ability to manage and resolve conflicts within a team.',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SkillCategorySection extends StatelessWidget {
  final String categoryName;
  final List<SoftSkillCard> skills;

  SkillCategorySection({
    required this.categoryName,
    required this.skills,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            categoryName,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        Column(
          children: skills,
        ),
      ],
    );
  }
}

class SoftSkillCard extends StatelessWidget {
  final String skillName;
  final int proficiency; // Percentage of proficiency
  final String description;

  SoftSkillCard({
    required this.skillName,
    required this.proficiency,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(15),
        title: Text(
          skillName,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Circular Progress Indicator for proficiency
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: CircularProgressIndicator(
                value: proficiency / 100,
                strokeWidth: 8,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF76c7c0)),
              ),
            ),
            // Description Text
            Text(
              description,
              style: TextStyle(
                color: Colors.black.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
*/