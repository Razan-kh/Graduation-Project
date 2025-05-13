
/*import 'package:flutter/material.dart';

class SkillsHighlightSection extends StatefulWidget {
  @override
  _SkillsHighlightSectionState createState() => _SkillsHighlightSectionState();
}

class _SkillsHighlightSectionState extends State<SkillsHighlightSection> {
  List<Skill> skills = [
    Skill(name: "Flutter", category: "Frontend", proficiencyLevel: 80),
    Skill(name: "Django", category: "Backend", proficiencyLevel: 70),
    Skill(name: "Docker", category: "DevOps", proficiencyLevel: 60),
    Skill(name: "TensorFlow", category: "AI/ML", proficiencyLevel: 90),
  ];

  bool isEditing = false;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController proficiencyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Skills Highlight'),
        actions: [
          IconButton(
            icon: Icon(isEditing ? Icons.preview : Icons.edit),
            onPressed: () {
              setState(() {
                isEditing = !isEditing;
              });
            },
          ),
        ],
      ),
      body: isEditing ? _buildEditMode() : _buildPreviewMode(),
    );
  }

  // Build Preview Mode
  Widget _buildPreviewMode() {
    Map<String, List<Skill>> categorizedSkills = {};

    // Categorize skills by their category
    for (var skill in skills) {
      if (!categorizedSkills.containsKey(skill.category)) {
        categorizedSkills[skill.category] = [];
      }
      categorizedSkills[skill.category]?.add(skill);
    }

    return ListView.builder(
      itemCount: categorizedSkills.keys.length,
      itemBuilder: (context, index) {
        String category = categorizedSkills.keys.elementAt(index);
        List<Skill> skillsInCategory = categorizedSkills[category]!;
        return Card(
          margin: EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: skillsInCategory
                      .map((skill) => _buildSkillRow(skill))
                      .toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Build Skill Row
  Widget _buildSkillRow(Skill skill) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(skill.name, style: TextStyle(fontSize: 16)),
        SizedBox(width: 10),
        Container(
          width: 100,
          child: LinearProgressIndicator(
            value: skill.proficiencyLevel / 100,
            backgroundColor: Colors.grey[300],
            color: Colors.blue,
            minHeight: 10,
          ),
        ),
        SizedBox(width: 10),
        Text('${skill.proficiencyLevel}%', style: TextStyle(fontSize: 16)),
      ],
    );
  }

  // Build Edit Mode
  Widget _buildEditMode() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(labelText: 'Skill Name'),
          ),
          SizedBox(height: 8),
          TextField(
            controller: categoryController,
            decoration: InputDecoration(labelText: 'Category (e.g., Frontend)'),
          ),
          SizedBox(height: 8),
          TextField(
            controller: proficiencyController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Proficiency (0-100)'),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              setState(() {
                skills.add(Skill(
                  name: nameController.text,
                  category: categoryController.text,
                  proficiencyLevel: int.tryParse(proficiencyController.text) ?? 0,
                ));

                // Clear the fields
                nameController.clear();
                categoryController.clear();
                proficiencyController.clear();
              });
            },
            child: Text('Add Skill'),
          ),
        ],
      ),
    );
  }
}

class Skill {
  String name;
  String category;
  int proficiencyLevel; // 0 to 100 (percentage)

  Skill({
    required this.name,
    required this.category,
    required this.proficiencyLevel,
  });
}
*/