const express = require('express');
const mongoose = require('mongoose');
const Courses = require('../models/Courses.js');
const TemplateModel = require('../models/TemplateModel.js');
const Assignment = require('../models/Assignment.js');
// exports.create_empty_courses = async (req, res) => {
//   const { templateId } = req.params;
//   const isoDate = new Date().toISOString(); // Use the current date for realistic timestamps

//   try {
//     // Step 1: Create new assignments for each course
//     const courseData = [
//       {
//         name: "Introduction to Programming",
//         icon: "programming-icon",
//         assignments: [
//           { assignmentName: "Variables and Data Types Quiz", values: [isoDate, "Introduction to variables and data types.", 10, 15, "easy"] },
//           { assignmentName: "Control Structures Homework", values: [isoDate, "Practice on if-else and loops.", 20, 25, "medium"] },
//           { assignmentName: "Functions Project", values: [isoDate, "Create a simple program using functions.", 30, 35, "medium"] },
//           { assignmentName: "Debugging Exercise", values: [isoDate, "Fix errors in a given code snippet.", 10, 15, "hard"] },
//           { assignmentName: "Midterm Exam", values: [isoDate, "Comprehensive exam on programming basics.", 50, 60, "hard"] },
//         ],
//       },
//       {
//         name: "Data Structures",
//         icon: "data-structures-icon",
//         assignments: [
//           { assignmentName: "Array and Linked List Practice", values: [isoDate, "Basic operations with arrays and linked lists.", 10, 20, "easy"] },
//           { assignmentName: "Stack and Queue Implementation", values: [isoDate, "Implement stack and queue from scratch.", 30, 40, "medium"] },
//           { assignmentName: "Sorting Algorithms Analysis", values: [isoDate, "Analyze the performance of sorting algorithms.", 20, 30, "medium"] },
//           { assignmentName: "Binary Search Tree Project", values: [isoDate, "Create a binary search tree and perform operations.", 40, 50, "hard"] },
//           { assignmentName: "Final Project", values: [isoDate, "Build a data structure-based application.", 50, 60, "hard"] },
//         ],
//       },
//       {
//         name: "Web Development",
//         icon: "web-development-icon",
//         assignments: [
//           { assignmentName: "HTML & CSS Basics Quiz", values: [isoDate, "Test knowledge on HTML and CSS basics.", 10, 15, "easy"] },
//           { assignmentName: "Responsive Web Design", values: [isoDate, "Create a responsive webpage using CSS.", 20, 25, "medium"] },
//           { assignmentName: "JavaScript Form Validation", values: [isoDate, "Add validation to a form using JavaScript.", 30, 35, "medium"] },
//           { assignmentName: "API Integration", values: [isoDate, "Fetch and display data from a public API.", 40, 50, "hard"] },
//           { assignmentName: "Portfolio Website", values: [isoDate, "Build a personal portfolio website.", 50, 60, "hard"] },
//         ],
//       },
//       {
//         name: "Database Management Systems",
//         icon: "database-icon",
//         assignments: [
//           { assignmentName: "ER Diagram Quiz", values: [isoDate, "Test knowledge on entity-relationship diagrams.", 10, 15, "easy"] },
//           { assignmentName: "SQL Queries Practice", values: [isoDate, "Write basic SQL queries.", 20, 25, "medium"] },
//           { assignmentName: "Normalization Techniques", values: [isoDate, "Apply normalization techniques to a database schema.", 30, 35, "medium"] },
//           { assignmentName: "Stored Procedures Implementation", values: [isoDate, "Create and execute stored procedures.", 40, 50, "hard"] },
//           { assignmentName: "Final Database Project", values: [isoDate, "Design and implement a database for a business case.", 50, 60, "hard"] },
//         ],
//       },
//       {
//         name: "Operating Systems",
//         icon: "os-icon",
//         assignments: [
//           { assignmentName: "Processes and Threads Quiz", values: [isoDate, "Introduction to processes and threads.", 10, 15, "easy"] },
//           { assignmentName: "Scheduling Algorithms Practice", values: [isoDate, "Simulate scheduling algorithms.", 20, 25, "medium"] },
//           { assignmentName: "Memory Management Analysis", values: [isoDate, "Analyze memory allocation techniques.", 30, 35, "medium"] },
//           { assignmentName: "Concurrency Project", values: [isoDate, "Implement a multithreaded program.", 40, 50, "hard"] },
//           { assignmentName: "Final Exam", values: [isoDate, "Comprehensive exam on operating system concepts.", 50, 60, "hard"] },
//         ],
//       },
//     ];

//     // Step 2: Save all assignments and create courses
//     const courses = await Promise.all(
//       courseData.map(async (course) => {
//         const savedAssignments = await Promise.all(
//           course.assignments.map((assignment) => new Assignment(assignment).save())
//         );

//         return {
//           name: course.name,
//           mark: 0, // Placeholder mark, can be updated later
//           icon: course.icon,
//           assignments: savedAssignments.map((a) => a._id),
//         };
//       })
//     );

//     // Step 3: Create a new Courses document
//     const emptyCourses = new Courses({ courses });

//     // Save the Courses document to the database
//     await emptyCourses.save();

//     // Step 4: Respond with success
//     res.status(200).json({ success: true, data: emptyCourses._id });
//   } catch (error) {
//     console.error("Error creating courses:", error);
//     res.status(500).json({ success: false, error: error.message });
//   }
// };


exports.create_empty_courses = async (req, res) => {
  const { templateId } = req.params;
  const isoDate = new Date().toISOString();

  try {
    const courseData = [
      {
        name: "Web Development",
        icon: "web-development-icon",
        assignments: [
          { assignmentName: "HTML & CSS Basics Quiz", values: [isoDate, "Test knowledge on HTML and CSS basics.", 10, 15, "easy"] },
          { assignmentName: "Responsive Web Design", values: [isoDate, "Create a responsive webpage using CSS.", 20, 25, "medium"] },
          { assignmentName: "JavaScript Form Validation", values: [isoDate, "Add validation to a form using JavaScript.", 30, 35, "medium"] },
          { assignmentName: "API Integration", values: [isoDate, "Fetch and display data from a public API.", 20, 25, "hard"] },
        ],
      },
      {
        name: "Data Structures",
        icon: "data-structures-icon",
        assignments: [
          { assignmentName: "Array and Linked List Practice", values: [isoDate, "Basic operations with arrays and linked lists.", 10, 20, "easy"] },
          { assignmentName: "Stack and Queue Implementation", values: [isoDate, "Implement stack and queue from scratch.", 30, 40, "medium"] },
          { assignmentName: "Sorting Algorithms Analysis", values: [isoDate, "Analyze the performance of sorting algorithms.", 20, 30, "medium"] },
          { assignmentName: "Binary Search Tree Project", values: [isoDate, "Create a binary search tree and perform operations.", 10, 10, "hard"] },
         
        ],
      },

      {
        name: "Database Management Systems",
        icon: "database-icon",
        assignments: [
          { assignmentName: "ER Diagram Quiz", values: [isoDate, "Test knowledge on entity-relationship diagrams.", 10, 15, "easy"] },
          { assignmentName: "SQL Queries Practice", values: [isoDate, "Write basic SQL queries.", 20, 25, "medium"] },
          { assignmentName: "Normalization Techniques", values: [isoDate, "Apply normalization techniques to a database schema.", 30, 35, "medium"] },
          { assignmentName: "Stored Procedures Implementation", values: [isoDate, "Create and execute stored procedures.", 12, 25, "hard"] },
        ],
      },
    
    ];

    const courses = await Promise.all(
      courseData.map(async (course) => {
        const savedAssignments = await Promise.all(
          course.assignments.map((assignment) => new Assignment(assignment).save())
        );

        // Calculate total and average marks
        const totalMarks = savedAssignments.reduce((sum, assignment) => sum + assignment.values[2], 0);
      //  const averageMarks = totalMarks / savedAssignments.length;

        return {
          name: course.name,
          mark: totalMarks, // Set calculated average mark
          icon: course.icon,
          assignments: savedAssignments.map((a) => a._id),
        };
      })
    );

    const emptyCourses = new Courses({ courses });
    await emptyCourses.save();

    res.status(200).json({ success: true, data: emptyCourses._id });
  } catch (error) {
    console.error("Error creating courses:", error);
    res.status(500).json({ success: false, error: error.message });
  }
};




/*
exports.create_empty_courses= async (req, res) => {
    const { templateId } = req.params;
    console.log(templateId)
    try {
        // Create a new Courses document with an empty courses array
        const emptyCourses = new Courses({ courses: [] }); 
        // Save the document to the database
        await emptyCourses.save();
            // Update the template's data field to include the coursesId
            const updatedTemplate = await TemplateModel.findByIdAndUpdate(
                templateId,
                { $set: { 'data': emptyCourses._id } }, 
                { new: true } // Return the updated document
            );
    
            if (!updatedTemplate) {
                return res.status(404).json({ success: false, message: 'Template not found' });
            }
    
            res.status(200).json({ success: true, data: updatedTemplate.data });
        // Send the ID of the newly created document as the response
     
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
};

*/

exports.add_course=async (req, res) =>{
    console.log("inside add_course")
    const { id } = req.params;
    const { name, mark, icon, assignments } = req.body;

    try {
        // Find the AllCourses document by ID
        const allCourses = await Courses.findById(id);

        if (!allCourses) {
            return res.status(404).json({ success: false, message: 'AllCourses document not found' });
        }

        // Create a new course object
        const newCourse = {
            name,
           mark: mark||0,
            icon :icon || "edit_note",
            assignments: assignments || [], // Optionally include assignments
        };

        // Add the new course to the courses array
        allCourses.courses.push(newCourse);

        // Save the updated document to the database
        await allCourses.save();

        res.status(201).json({ success: true, data: newCourse, message: 'New course added successfully' });
    } catch (error) {
        console.error('Error creating new course:', error);
        res.status(500).json({ success: false, message: 'Error creating new course', error: error.message });
    }
};




exports.fetchCourses= async (req, res) => {
    const { coursesArrayId } = req.params;
console.log(coursesArrayId)
    try {
        // Find the user and populate their courses and assignments
        const user = await Courses.findById(coursesArrayId)
        .populate(
            'courses',
        );

        if (!user) {
            return res.status(404).json({ message: 'User not found' });
        }

        res.json(user.courses);
    } catch (error) {
        console.error("Error retrieving courses and assignments:", error);
        res.status(500).json({ error: 'Failed to retrieve courses and assignments.' });
    }
};
exports.Fetchassignments= async (req, res) => {
    try {
        const assignments = await Assignment.find(); // Fetch all assignments
        res.status(200).json(assignments); // Send assignments as JSON response
    } catch (error) {
        res.status(500).json({ message: 'Error fetching assignments', error });
    }
};

exports.addDataToTemplate=async (req, res) => {
    const { id } = req.params;
    const { data } = req.body;
  
    try {
      // Find the template by ID and update its data field
      const updatedTemplate = await Template.findByIdAndUpdate(
        id,
        { data: data },
        { new: true } // Return the updated document
      );
  
      if (!updatedTemplate) {
        return res.status(404).json({ success: false, message: 'Template not found' });
      }
  
      res.status(200).json({ success: true, data: updatedTemplate });
    } catch (error) {
      console.error(error);
      res.status(500).json({ success: false, error: 'Failed to update the template data' });
    }
  };

  exports.newAssignment= async (req, res) => {
    const { allCoursesId, courseName, assignmentName, values } = req.body;

    // Validate request body
    if (!allCoursesId || !courseName || !assignmentName || !values) {
        return res.status(400).json({ message: 'All fields (allCoursesId, courseName, assignmentName, values) are required.' });
    }

    try {
        // Create a new assignment
        const newAssignment1 = new Assignment({
            assignmentName,
            values,
        });

        // Save the new assignment to the database
        await newAssignment1.save();

        // Find the AllCourses document by its ID
        const allCourses = await Courses.findById(allCoursesId);

        // Check if the AllCourses document exists
        if (!allCourses) {
            return res.status(404).json({ message: 'AllCourses document not found.' });
        }

        // Find the specific course by name within the AllCourses document
        const course = allCourses.courses.find((c) => c.name === courseName);

        // If the course is not found, return an error
        if (!course) {
            return res.status(404).json({ message: 'Course not found.' });
        }

        // Push the new assignment ID to the course's assignments array
        if (!course.assignments) {
            course.assignments = []; // Initialize if not present
        }
        course.assignments.push(newAssignment1._id);

        // Save the updated AllCourses document
        await allCourses.save();

        // Respond with the created assignment and the updated course
        res.status(201).json({
            message: 'Assignment created and assigned successfully.',
            assignment: newAssignment1._id,
            course: {
                name: course.name,
                mark: course.mark,
                icon: course.icon,
                assignments: course.assignments,
            },
        });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Internal server error.' });
    }
};
exports.getOneAssignment=async (req, res) => {
    try {
        const assignmentId = req.params.id;
        const assignment = await Assignment.findById(assignmentId);

        if (!assignment) {
            return res.status(404).json({ message: 'Assignment not found' });
        }

        res.status(200).json(assignment);
    } catch (error) {
        console.error('Error fetching assignment:', error);
        res.status(500).json({ message: 'Server error', error: error.message });
    }
};

exports.updatedAssignmentValues = async (req, res) => {
    const { id } = req.params; // Assignment ID
    const { values } = req.body; // New values for the assignment
  
    if (!values || !Array.isArray(values)) {
      return res.status(400).json({ message: 'Invalid values array.' });
    }
  
    try {
      // Update the assignment
      const updatedAssignment = await Assignment.findOneAndUpdate(
        { _id: id },
        { values: values },
        { new: true }
      );
  
      if (!updatedAssignment) {
        return res.status(404).json({ message: 'Assignment not found.' });
      }
  
      // Find the course containing this assignment
      const course = await Courses.findOne({ "courses.assignments": id });
  
      if (!course) {
        return res.status(404).json({ message: 'Course not found for the assignment.' });
      }
  
    // Locate the specific course inside the `courses` array
    const targetCourse = course.courses.find((c) =>
        c.assignments.some((assignmentId) => assignmentId.toString() === id)
      );
  
      if (!targetCourse) {
        return res.status(404).json({ message: 'Course not found for the assignment.' });
      }
  
      // Fetch all assignments for this course
      const assignments = await Assignment.find({ _id: { $in: targetCourse.assignments } });
  
      // Recalculate the course mark
      const totalMark = assignments.reduce((sum, assignment) => {
        const markIndex = 2; // Index in `values` where the mark is stored
        const mark = parseFloat(assignment.values[markIndex]) || 0; // Parse mark safely
        return sum + mark;
      }, 0);
  
      const averageMark = assignments.length > 0 ? totalMark / 1 : 0;
      targetCourse.mark = averageMark;
  
      // Save the updated course
      await course.save();
  
      return res.status(200).json({ updatedAssignment, updatedCourse: targetCourse });
    } catch (error) {
      console.error('Error updating assignment values and recalculating course mark:', error);
      return res.status(500).json({ message: 'Server error.' });
    }
  };
/*
exports.updatedAssignmentValues=async (req, res) => {
    const { id } = req.params; // Get the assignment ID from the URL
    const { values } = req.body; // Get the values array from the request body
  
    if (!values || !Array.isArray(values)) {
      return res.status(400).json({ message: 'Invalid values array.' }); 
    }
  
    try {
      const updatedAssignment = await Assignment.findOneAndUpdate(
        { _id: id }, // Correctly query by ID
        { values: values }, // Update the values
        { new: true } // Return the updated document
      );
  
      if (!updatedAssignment) {
        return res.status(404).json({ message: 'Assignment not found.' });
      }
  
      return res.status(200).json(updatedAssignment);
    } catch (error) {
      console.error(error);
      return res.status(500).json({ message: 'Server error.' });
    }
  };
  */
exports.editAssignmentName= async (req, res) => {
    const assignmentId = req.params.id;
    const { assignmentName } = req.body;
  
    try {
      // Find the assignment by ID
      const assignment = await Assignment.findById(assignmentId);
  
      if (!assignment) {
        return res.status(404).json({ message: 'Assignment not found' });
      }
  
      // Update the assignment name
      assignment.assignmentName = assignmentName;
  
      // Save the changes
      await assignment.save();
  
      // Send the updated assignment back as the response
      res.status(200).json(assignment);
    } catch (error) {
      console.error('Error updating assignment name:', error);
      res.status(500).json({ message: 'Internal server error' });
    }
  };
  
/*const mongoose=require('mongoose');
const AllCourses=require('../models/Courses.js');
const { param } = require('../routes/templateRoutes.js');
const template=require('../models/TemplateModel.js');
exports.makeCoursesArray= async (req,res)=>{
try{
    const {templateid}=req.params;
    const coursesArray=new AllCourses([]);
    await coursesArray.sava();

   await template.findByIdAndUpdate(templateid,{
        $push:{data:coursesArray}
    }
    )
    res.status(200).json(coursesArray);
}
catch(err)
{
res.status(401).json(`failed to create courses array ${err.message}`);
}
}

exports.AddnewCourse=async (req,res)=>{

}
*/
exports.deleteCourse=async (req, res) => {
  const { allCoursesId, index } = req.params;

  try {
    const allCourses = await Courses.findById(allCoursesId);
    if (!allCourses) {
      return res.status(404).json({ message: 'Courses not found' });
    }

    // Remove the course at the specified index
    allCourses.courses.splice(index, 1);
    await allCourses.save();

    res.status(200).json({ message: 'Course deleted successfully' });
  } catch (error) {
    res.status(500).json({ message: 'An error occurred', error });
  }
};