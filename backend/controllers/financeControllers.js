const express = require('express');
const mongoose = require('mongoose');
const {Expense,Subscription,Income,Category,Finance,Bill} = require('../models/finance');
const User=require('../models/userModel')
const cron = require('node-cron');

const app = express();

// Middleware to parse JSON data
app.use(express.json());
/*
Finance.pre('save', async function(next) {
    const finance = this;
  
    // Fetch all the related data for the finance record
    await finance.populate('incomes').populate('bills').populate('subscriptions').populate('categories').execPopulate();
  
    // Calculate the net value
    const totalIncome = finance.incomes.reduce((acc, income) => acc + income.amount, 0);
    const totalExpenses = finance.categories.reduce((acc, category) => {
      return acc + category.expenses.reduce((acc, expense) => acc + expense.amount, 0);
    }, 0);
    const totalBills = finance.bills.reduce((acc, bill) => acc + bill.amount, 0);
    const totalSubscriptions = finance.subscriptions.reduce((acc, sub) => acc + sub.amount, 0);
  
    finance.net = totalIncome - totalExpenses - totalBills - totalSubscriptions;
  
    next();
  });
  

*/
exports.getFinance=async (req, res) => {
    try {
      console.log("inside get finance")
      const finance = await Finance.findById(req.params.id)
        .populate('subscriptions')
        .populate({
          path: 'categories',
          populate: {
            path: 'expenses',  // Assuming 'expenses' is a reference to another collection
            model: 'Expense',   // Replace with the correct model name for expenses
          },
        })

        .populate('bills')
       .populate('incomes')
       
      if (!finance) {
        return res.status(404).json({ message: 'Finance not found' });
      }
      console.log(finance)
      console.log(`Incomes are ${JSON.stringify(finance.incomes)}`);
      res.status(200).json(finance);
    } catch (err) {
      res.status(500).json({ message: 'Error fetching finance', error: err });
    }
  };
  /*
  exports.createDefaultFinance = async (req, res) => {
    try {
      // Fetch the userId and categoryId dynamically (Replace with actual logic)
      const userId = req.user._id // Replace with actual user ID
  
      // Create Expense objects
      const expense1 = new Expense({
        name: 'Lunch at McDonalds',
        amount: 15.0,
        date: new Date('2024-12-01'),
        notes: 'Quick lunch with friends',
      });
  
      const expense2 = new Expense({
        name: 'Movie Tickets',
        amount: 25.00,
        date: new Date('2024-12-02'),
        notes: 'Weekend movie outing',
      });

      const expense3 = new Expense({
        name: 'Lunch at KFC',
        amount: 15.0,
        date: new Date('2024-12-01'),
        notes: 'Quick lunch ',
      });
  
      const expense4 = new Expense({
        name: 'Movie',
        amount: 25.00,
        date: new Date('2024-12-02'),
        notes: 'Weekend movie ',
      });
  
      // Save expenses to the database
      await expense1.save();
      await expense2.save();
      await expense3.save();
      await expense4.save();
  
      // Create Category object
      const category1 = new Category({
        name: 'Entertainment',
        description: 'All expenses related to entertainment',
        icon: '🎬',
        totalAmount: 40.0,
        color: '#FF6347',
        expenses: [expense1._id, expense2._id], // Linking the expenses to the category
      });

       // Create Category object
       const category2 = new Category({
        name: 'Food',
        description: 'All expenses related to Food',
        icon: '🍕',
        totalAmount: 40.0,
        color: '#FF6347',
        expenses: [expense3._id, expense4._id], // Linking the expenses to the category
      });
  
      // Save category to the database
      await category1.save();
      await category2.save();
      // Create Income object
      const income = new Income({
        name: 'Salary',
        amount: 5000,
        date: new Date('2024-12-01'),
        notes: 'Monthly salary from employer',
        type: 'monthly',
        renewalDate: new Date('2025-01-01'), // Renewal date for the next month
      });
  
      await income.save();
  
      // Create Subscription object
      const subscription = new Subscription({
        name: 'Netflix',
        amount: 15.99,
        renewalDate: new Date('2025-01-01'),
        frequency: 'Monthly',
        status: 'Active',
   
        notes: 'Entertainment subscription for movies and series',
      });
  
      await subscription.save();
  
      // Create Bill object
      const bill = new Bill({
        name: 'Electricity Bill',
        amount: 120,
        dueDate: new Date('2024-12-25'),
        paymentMethod: 'Card',
        status: 'Due',
        frequency: 'Monthly',
        category: 'Utilities',
        userId: userId, // Replace with actual userId
      });
  
      await bill.save();
  
      // Create Finance object
      const finance = new Finance({
        userId: userId, // Replace with actual userId
        title: 'Personal Finance',
        type: 'finance',
       
        subscriptions: [subscription._id], // Add actual subscription references
        categories: [category1._id,category2._id], // Linking the category to finance
        bills: [bill._id], // Add bill references if needed
        incomes: [income._id], // Add income references if needed
        net: 1000, // Example net amount
      });
  
      // Save finance to the database
      await finance.save();

      await User.findByIdAndUpdate(userId, {
        $push: { templates: { templateId: finance._id, title: "Finance" ,
          icon: "💲",
          image: "https://i.pinimg.com/564x/91/65/40/916540a9c1883b4897e259831c4b08a9.jpg",
         } },
      });

      console.log('Finance document with categories and expenses saved successfully!');
      res.status(200).json({ message: 'Finance data created successfully' });
    } catch (err) {
      console.error('Error creating finance data:', err);
      res.status(500).json({ message: 'Error creating finance data' });
    }
  };
 */

  exports.createDefaultFinance = async (req, res) => {
    try {
      // Fetch the userId and categoryId dynamically (Replace with actual logic)
      const userId = req.user._id // Replace with actual user ID
  
      // Create Expense objects
      const expense1 = new Expense({
        name: 'Skating',
        amount: 150.0,
        date: new Date('2025-01-05'),
        notes: 'Quick lunch with friends',
      });
  
      const expense2 = new Expense({
        name: 'Movie Tickets',
        amount: 250.00,
        date: new Date('2025-01-7'),
        notes: 'Weekend movie outing',
      });

      const expense3 = new Expense({
        name: 'Lunch at resturaunt',
        amount: 150.0,
        date: new Date('2025-01-10'),
        notes: 'Quick lunch ',
      });
  
      const expense4 = new Expense({
        name: 'Breakfast',
        amount: 250.00,
        date: new Date('2025-04-20'),
        notes: 'Weekend movie ',
      });
  
      // Save expenses to the database
      await expense1.save();
      await expense2.save();
      await expense3.save();
      await expense4.save();
  
      // Create Category object
      const category1 = new Category({
        name: 'Entertainment',
        description: 'All expenses related to entertainment',
        icon: '🎬',
        totalAmount: 40.0,
        color: '#FF6347',
        expenses: [expense1._id, expense2._id], // Linking the expenses to the category
      });

       // Create Category object
       const category2 = new Category({
        name: 'Food',
        description: 'All expenses related to Food',
        icon: '🍕',
        totalAmount: 40.0,
        color: '#FF6347',
        expenses: [expense3._id, expense4._id], // Linking the expenses to the category
      });
  
      // Save category to the database
      await category1.save();
      await category2.save();
      // Create Income object
      const income = new Income({
        name: 'Salary',
        amount: 100,
        date: new Date('2025-01-01'),
        notes: 'Monthly salary from the company',
        type: 'monthly',
        renewalDate: new Date('2025-01-01'), // Renewal date for the next month
      });
  
      await income.save();

      const income1 = new Income({
        name: 'Youtube',
        amount: 700,
        date: new Date('2025-01-01'),
        notes: 'Monthly salary from youtube',
        type: 'monthly',
        renewalDate: new Date('2025-05-01'), // Renewal date for the next month
      });
  
      await income1.save();
  
      // Create Subscription object
      const subscription = new Subscription({
        name: 'Grammarly Premium',
        amount: 15.99,
        renewalDate: new Date('2025-01-01'),
        frequency: 'Monthly',
        status: 'Active',
   
        notes: 'Entertainment subscription for movies and series',
      });
  
      await subscription.save();
  
      // Create Bill object
      const bill = new Bill({
        name: 'Electricity Bill',
        amount: 120,
        dueDate: new Date('2024-12-25'),
        paymentMethod: 'Card',
        status: 'Due',
        frequency: 'Monthly',
        category: 'Utilities',
        userId: userId, // Replace with actual userId
      });
  
      await bill.save();
  
      // Create Finance object
      const finance = new Finance({
        userId: userId, // Replace with actual userId
        title: 'Personal Finance',
        type: 'finance',
       
        subscriptions: [subscription._id], // Add actual subscription references
        categories: [category1._id,category2._id], // Linking the category to finance
        bills: [bill._id], // Add bill references if needed
        incomes: [income._id,income1._id], // Add income references if needed
        net: 1000, // Example net amount
      });
  
      // Save finance to the database
      await finance.save();

      await User.findByIdAndUpdate(userId, {
        $push: { templates: { templateId: finance._id, title: "Finance" ,
          icon: "💲",
          image: "https://i.pinimg.com/564x/91/65/40/916540a9c1883b4897e259831c4b08a9.jpg",
         } },
      });

      console.log('Finance document with categories and expenses saved successfully!');
      res.status(200).json({ message: 'Finance data created successfully' });
    } catch (err) {
      console.error('Error creating finance data:', err);
      res.status(500).json({ message: 'Error creating finance data' });
    }
  };

  

  // Controller to create a new category and associate it with a finance object
exports.createCategory = async (req, res) => {
    const { id: financeId } = req.params; // Finance ID from request parameters
    const { name, description, icon } = req.body; // Category details from request body
  
    if (!name) {
      return res.status(400).json({ error: "Category name is required" });
    }
  
    try {
      // Check if the finance object exists
      const finance = await Finance.findById(financeId);
      if (!finance) {
        return res.status(404).json({ error: "Finance object not found" });
      }
  
      // Create a new category
      const category = new Category({
        name,
        description,
        icon,
        totalAmount: 0, // Initialize totalAmount as 0
      });
  
      // Save the new category
      const savedCategory = await category.save();
  
      // Push the category into the finance's categories array
      finance.categories.push(savedCategory._id);
      await finance.save();
  
      res.status(201).json({
        message: "Category created and added to finance successfully",
        category: savedCategory,
      });
    } catch (error) {
      console.error("Error creating category:", error);
      res.status(500).json({ error: "Internal server error" });
    }
  };

// Controller to add an expense to a category
exports.addExpenseToCategory = async (req, res) => {
  const categoryId = req.params.id; // The category ID passed as a parameter
  const {name, amount, notes,category } = req.body; // The expense details passed in the body

  try {
    // Find the category by its ID
    const category = await Category.findById(categoryId);

    if (!category) {
      return res.status(404).json({ message: 'Category not found' });
    }
    const currentDate = new Date().toISOString();
    console.log(currentDate);
    // Create a new expense object
    const newExpense = Expense({
      name:name,
      amount:amount,
      date:currentDate,
      category:category.id,
      notes:notes,
    });
   await newExpense.save();
   console.log(`new expense is ${newExpense._id}`)
    // Push the new expense into the category's expenses array
    category.expenses.push(newExpense._id);
category.totalAmount+=amount;
console.log(`total amount is ${category.totalAmount}`)
    // Save the updated category
    await category.save();
    await category.populate('expenses');
    // Return the updated category
    return res.status(200).json(category);
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: 'Server error' });
  }
};


  
// Create Income and Add to Finance
exports.addIncomeToFinance = async (req, res) => {
  try {
    const { financeId } = req.params;
    const { name, amount, date, notes, type, renewalDate } = req.body;

    // Validate finance existence
    const finance = await Finance.findById(financeId);
    if (!finance) {
      return res.status(404).json({ message: 'Finance not found' });
    }
    const currentDate = new Date().toISOString();
    // Create new Income
    const income = new Income({
      name,
      amount,
      currentDate,
      notes,
      type,
      renewalDate,
    });

    // Save Income
    await income.save();
    if (type === 'one-time') {
   
      finance.net += parseFloat(amount); // Add income amount to the net immediately
    }
    // Add Income to Finance
    finance.incomes.push(income._id);
    await finance.save();

    res.status(201).json({
      message: 'Income created and added to Finance successfully',
      income,
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error' });
  }
};

// Daily cron job
cron.schedule('0 0 * * *', async () => {
  try {
    const today = new Date();

    // Find incomes where the renewalDate is today or earlier
    const incomes = await Income.find({
      renewalDate: { $lte: today },
    });

    for (const income of incomes) {
      // Find the related Finance document and update the net
      const finance = await Finance.findOne({ incomes: income._id });

      if (finance) {
        finance.net += income.amount;
        await finance.save();

        console.log(`Updated net for finance ${finance.title}: ${finance.net}`);
      }

      // Update renewalDate based on type
      switch (income.type) {
        case 'weekly':
          income.renewalDate.setDate(income.renewalDate.getDate() + 7);
          break;
        case 'monthly':
          income.renewalDate.setMonth(income.renewalDate.getMonth() + 1);
          break;
        case 'yearly':
          income.renewalDate.setFullYear(income.renewalDate.getFullYear() + 1);
          break;
        default:
          break;
      }

      // Save the updated renewal date for the income
      await income.save();
    }

    console.log('Income renewals processed successfully and net updated!');
  } catch (error) {
    console.error('Error processing income renewals:', error);
  }
});

// Daily cron job for subscriptions
cron.schedule('0 0 * * *', async () => {
  try {
    const today = new Date();

    // Find subscriptions where the renewalDate is today or earlier
    const subscriptions = await Subscription.find({
      renewalDate: { $lte: today },
    });

    for (const subscription of subscriptions) {
      // Find the related Finance document and update the net
      const finance = await Finance.findOne({ subscriptions: subscription._id });

      if (finance) {
        finance.net -= subscription.amount;
        await finance.save();

        console.log(`Updated net for finance ${finance.title}: ${finance.net}`);
      }

      // Update renewalDate based on frequency
      switch (subscription.frequency) {
        case 'weekly':
          subscription.renewalDate.setDate(subscription.renewalDate.getDate() + 7);
          break;
        case 'monthly':
          subscription.renewalDate.setMonth(subscription.renewalDate.getMonth() + 1);
          break;
        case 'yearly':
          subscription.renewalDate.setFullYear(subscription.renewalDate.getFullYear() + 1);
          break;
        default:
          break;
      }

      // Save the updated renewal date for the subscription
      await subscription.save();
    }

    console.log('Subscription renewals processed successfully and net updated!');
  } catch (error) {
    console.error('Error processing subscription renewals:', error);
  }
});


// Controller to search for finance by ID, create a subscription, and add it to finance
exports.addSubscriptionToFinance = async (req, res) => {
  try {
    const { financeId } = req.params; // Extract finance ID from route parameters
    const { name, amount, renewalDate, frequency, status, category, notes } = req.body; // Extract subscription details

    // Validate finance existence
    const finance = await Finance.findById(financeId);
    if (!finance) {
      return res.status(404).json({ message: 'Finance not found' });
    }

    // Create new subscription
    const subscription = new Subscription({
      name,
      amount,
      renewalDate,
      frequency,
      status,
      category,
      notes,
    });

    // Save subscription to database
    const savedSubscription = await subscription.save();

    // Add subscription to finance object
    finance.subscriptions.push(savedSubscription._id);

    // Save updated finance object
    await finance.save();

    res.status(201).json({
      message: 'Subscription added to Finance successfully',
      subscription: savedSubscription,
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error' });
  }
};



// Route to calculate daily net for a given month and year
exports.getMonthData= async (req, res) => {
  try {
    const { financeId, year, month } = req.query;
console.log(typeof(year))
console.log(typeof(month))

    // Validate input
    if (!financeId || !year || !month) {
      return res.status(400).json({ error: 'userId, year, and month are required' });
    }

    const finance = await Finance.findById(financeId)
  .populate('incomes')
  .populate({
    path: 'categories',
    populate: { path: 'expenses' }, // Fetch all expenses under categories
  })
  .populate('subscriptions');

  
    if (!finance) {
      return res.status(404).json({ error: 'Finance data not found for the user' });
    }

    const daysInMonth = new Date(year, parseInt(month) + 1, 0).getDate();
    const startDate = new Date(parseInt(year), parseInt(month), 1);
    const endDate = new Date(parseInt(year), parseInt(month), daysInMonth);
    const dailyNet = Array(daysInMonth).fill(0);

    // Calculate daily net from expenses
    finance.categories.forEach(category => {
      category.expenses.forEach(expense => {
        const expenseDate = new Date(expense.date);
        console.log(expenseDate)
        console.log(startDate)
        console.log(endDate)
        if (expenseDate >= startDate && expenseDate <= endDate) {
          console.log(`expense amount is${expense.amount}`)

          const day = expenseDate.getDate() - 1;
          dailyNet[day] -= expense.amount;
        }
      });
    });

    // Add incomes
    finance.incomes.forEach(income => {
      const incomeDate = new Date(income.date);
      for (let day = 0; day < daysInMonth; day++) {
        const currentDate = new Date(year, month, day + 1);
        if (
          (income.type === 'one-time' && incomeDate.getTime() === currentDate.getTime()) ||
          (income.type === 'monthly' && incomeDate.getDate() === currentDate.getDate()) ||
          (income.type === 'yearly' &&
            incomeDate.getDate() === currentDate.getDate() &&
            incomeDate.getMonth() === currentDate.getMonth()) ||
          (income.type === 'weekly' &&
            Math.floor((currentDate - incomeDate) / (1000 * 60 * 60 * 24)) % 7 === 0)
        ) {
          dailyNet[day] += income.amount;
        }
      }
    });

    // Subtract subscriptions
    finance.subscriptions.forEach(subscription => {
      const renewalDate = new Date(subscription.renewalDate);
      for (let day = 0; day < daysInMonth; day++) {
        const currentDate = new Date(parseInt(year), parseInt(month), day + 1);
        if (
          (subscription.frequency === 'Monthly' &&
            renewalDate.getDate() === currentDate.getDate()) ||
          (subscription.frequency === 'Yearly' &&
            renewalDate.getDate() === currentDate.getDate() &&
            renewalDate.getMonth() === currentDate.getMonth()) ||
          (subscription.frequency === 'Weekly' &&
            Math.floor((currentDate - renewalDate) / (1000 * 60 * 60 * 24)) % 7 === 0)
        ) {
          dailyNet[day] -= subscription.amount;
        }
      }
    });

    let cumulativeNet = 0;
    const chartData = dailyNet.map((net, index) => {
      cumulativeNet += net;
      return {
        day: index + 1,
        net: cumulativeNet,
      };
    });

    res.status(200).json({ chartData });
  } catch (error) {
    console.error('Error fetching daily net:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};

exports.getYearData = async (req, res) => {
  try {
    const { financeId, year } = req.query;

    // Validate input
    if (!financeId || !year) {
      return res.status(400).json({ error: 'financeId and year are required' });
    }

    const finance = await Finance.findById(financeId)
      .populate('incomes')
      .populate({
        path: 'categories',
        populate: { path: 'expenses' }, // Fetch all expenses under categories
      })
      .populate('subscriptions');

    if (!finance) {
      return res.status(404).json({ error: 'Finance data not found for the user' });
    }

    const monthlyNet = Array(12).fill(0); // Initialize monthly net array for 12 months

    // Calculate net income from expenses, incomes, and subscriptions
    finance.categories.forEach((category) => {
      category.expenses.forEach((expense) => {
        const expenseDate = new Date(expense.date);
        const startOfYear = new Date(year, 0, 1);
        const endOfYear = new Date(year, 11, 31);

        if (expenseDate >= startOfYear && expenseDate <= endOfYear) {
          const monthOfYear = expenseDate.getMonth(); // Get the month index (0 - 11)
          monthlyNet[monthOfYear] -= expense.amount;
        }
      });
    });

    // Add incomes
    finance.incomes.forEach((income) => {
      const incomeDate = new Date(income.date);
      if (incomeDate.getFullYear() === parseInt(year)) {
        const monthOfYear = incomeDate.getMonth();
        if (income.type === 'one-time' && incomeDate.getDate() === 1) {
          monthlyNet[monthOfYear] += income.amount;
        } else if (income.type === 'monthly') {
          // Add monthly income to every month
          monthlyNet.forEach((_, idx) => monthlyNet[idx] += income.amount);
        } else if (income.type === 'yearly') {
          // Add to all months
          monthlyNet.forEach((_, idx) => monthlyNet[idx] += income.amount);
        } else if (income.type === 'weekly') {
          // Weekly income: add to relevant months
          for (let i = 0; i < 12; i++) {
            monthlyNet[i] += income.amount;
          }
        }
      }
    });

    // Subtract subscriptions
    finance.subscriptions.forEach((subscription) => {
      const renewalDate = new Date(subscription.renewalDate);
      if (renewalDate.getFullYear() === parseInt(year)) {
        const monthOfYear = renewalDate.getMonth();
        if (subscription.frequency === 'Monthly') {
          // Subtract monthly subscription from every month
          monthlyNet.forEach((_, idx) => monthlyNet[idx] -= subscription.amount);
        } else if (subscription.frequency === 'Yearly') {
          // Subtract yearly subscription from all months
          monthlyNet.forEach((_, idx) => monthlyNet[idx] -= subscription.amount);
        } else if (subscription.frequency === 'Weekly') {
          // Weekly subscription: subtract from relevant months
          for (let i = 0; i < 12; i++) {
            monthlyNet[i] -= subscription.amount;
          }
        }
      }
    });

    // Prepare chart data with cumulative values
    let cumulativeNet = 0;
    const chartData = monthlyNet.map((net, index) => {
      cumulativeNet += net;
      return {
        month: index + 1, // Month (1 to 12)
        net: cumulativeNet,
      };
    });

    res.status(200).json({ chartData });
  } catch (error) {
    console.error('Error fetching yearly net:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};

exports.deleteFinance= async (req, res) => {
  const userId=req.user._id
    try {
        const { id } = req.params; // Get the ID from route parameters
console.log(id)
        // Find the finance document by ID
        const finance = await Finance.findById(id);
console.log(finance)
        if (!finance) {
          console.log("finance not found")
            return res.status(404).json({ message: 'Finance document not found.' });
        }
        const financeID = finance._id;

        // Delete the custom page reference from the user
        await User.findByIdAndUpdate(userId, {
          $pull: { templates:{templateId: financeID} },
        });
      
        // Delete the finance document
        await Finance.findByIdAndDelete(id);
console.log(`finance founded ${Finance}`)
        res.status(200).json({ message: 'Finance document deleted successfully.' });
    } catch (error) {
        console.error('Error deleting finance document:', error);
        res.status(500).json({ message: 'Internal server error.', error: error.message });
    }
};



// Controller to update the 'net' field of a finance document
exports.updateNet = async (req, res) => {
  try {
    const { id } = req.params; // ID of the finance document
    const { net } = req.body; // New net value

    // Check if the new net value is provided
    if (net === undefined || typeof net !== 'number') {
      return res.status(400).json({ message: 'Invalid or missing net value.' });
    }

    // Find the finance document and update its 'net' field
    const updatedFinance = await Finance.findByIdAndUpdate(
      id,
      { net },
      { new: true, runValidators: true } // Return the updated document and validate changes
    );

    // If finance document not found
    if (!updatedFinance) {
      return res.status(404).json({ message: 'Finance document not found.' });
    }

    // Success response
    res.status(200).json({ message: 'Net updated successfully.', data: updatedFinance });
  } catch (error) {
    // Error handling
    console.error(error);
    res.status(500).json({ message: 'Server error. Please try again later.' });
  }
};


// Delete a category by its ID
exports.deleteCategory = async (req, res) => {
  const categoryId = req.params.id;

  try {
    // Delete all expenses related to the category
    await Expense.deleteMany({ category: categoryId });

    // Now delete the category
    const category = await Category.findByIdAndDelete(categoryId);

    if (!category) {
      return res.status(404).json({ message: 'Category not found' });
    }

    return res.status(200).json({ message: 'Category and related expenses deleted successfully' });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: 'Server error' });
  }
};


// Delete an income by its ID
exports.deleteIncome = async (req, res) => {
  const incomeId = req.params.id;

  try {
    // Delete the income by its ID
    const income = await Income.findByIdAndDelete(incomeId);

    if (!income) {
      return res.status(404).json({ message: 'Income not found' });
    }

    return res.status(200).json({ message: 'Income deleted successfully' });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: 'Server error' });
  }
};


exports.EncomesExpenses= async (req, res) => {
  try {
      const expenses = await Expense.find({}, 'amount date').sort({ date: 1 });
      const incomes = await Income.find({}, 'amount date').sort({ date: 1 });

      res.json({ expenses, incomes });
  } catch (error) {
      res.status(500).json({ error: error.message });
  }
};



exports.calculateMonthlyExpenses = async (req, res) => {
  try {
      const { financeId, month, year } = req.params;
      
      // Find the finance document by ID
      const finance = await Finance.findById(financeId).populate('categories');
      if (!finance) {
          return res.status(404).json({ message: 'Finance document not found' });
      }
      
      let dailyNet = new Array(31).fill(0); // Array to store daily net expenses

      // Retrieve all expenses related to the categories in the finance document
      for (const category of finance.categories) {
          const expenses = await Expense.find({ 
              _id: { $in: category.expenses },
              date: {
                  $gte: new Date(year, month - 1, 1),
                  $lt: new Date(year, month, 1)
              }
          });
          
          expenses.forEach(expense => {
              const day = new Date(expense.date).getDate();
              dailyNet[day - 1] += expense.amount; // Accumulate expenses per day
          });
      }
      
      let cumulativeNet = 0;
      const chartData = dailyNet.map((net, index) => {
          cumulativeNet += net;
          return {
              day: index + 1,
              net: cumulativeNet,
          };
      });

      res.json({ financeId, chartData });
  } catch (error) {
      console.error(error);
      res.status(500).json({ message: 'Internal Server Error' });
  }
};


exports.calculateMonthlyIncomes = async (req, res) => {
  try {
      const { financeId, month, year } = req.params;
      
      // Find the finance document by ID
      const finance = await Finance.findById(financeId).populate('incomes');
      if (!finance) {
          return res.status(404).json({ message: 'Finance document not found' });
      }
      
      let dailyNet = new Array(31).fill(0); // Array to store daily net incomes

      // Retrieve all incomes related to the finance document
      const incomes = await Income.find({ 
          _id: { $in: finance.incomes },
          date: {
              $gte: new Date(year, month - 1, 1),
              $lt: new Date(year, month, 1)
          }
      });
      
      incomes.forEach(income => {
          const day = new Date(income.date).getDate();
          dailyNet[day - 1] += income.amount; // Accumulate incomes per day
      });
      
      let cumulativeNet = 0;
      const chartData = dailyNet.map((net, index) => {
          cumulativeNet += net;
          return {
              day: index + 1,
              net: cumulativeNet,
          };
      });

      res.json({ financeId, chartData });
  } catch (error) {
      console.error(error);
      res.status(500).json({ message: 'Internal Server Error' });
  }
};

  /*
  exports.createDefaultFinance = async (req, res) => {
    try {
      // Fetch the userId and categoryId dynamically (Replace with actual logic)
      const userId = req.user._id // Replace with actual user ID
  
      // Create Expense objects
      const expense1 = new Expense({
        name: 'Lunch at McDonalds',
        amount: 15.99,
        date: new Date('2024-12-01'),
        notes: 'Quick lunch with friends',
      });
  
      const expense2 = new Expense({
        name: 'Movie Tickets',
        amount: 25.00,
        date: new Date('2024-12-02'),
        notes: 'Weekend movie outing',
      });
  
      // Save expenses to the database
      await expense1.save();
      await expense2.save();
  
      // Create Category object
      const category = new Category({
        name: 'Entertainment',
        description: 'All expenses related to entertainment',
        icon: '🎬',
        color: '#FF6347',
        expenses: [expense1._id, expense2._id], // Linking the expenses to the category
      });
  
      // Save category to the database
      await category.save();
  
      // Create Income object
      const income = new Income({
        name: 'Salary',
        amount: 5000,
        date: new Date('2024-12-01'),
        notes: 'Monthly salary from employer',
        type: 'monthly',
        renewalDate: new Date('2025-01-01'), // Renewal date for the next month
      });
  
      await income.save();
  
      // Create Subscription object
      const subscription = new Subscription({
        name: 'Netflix',
        amount: 15.99,
        renewalDate: new Date('2025-01-01'),
        frequency: 'Monthly',
        status: 'Active',
   
        notes: 'Entertainment subscription for movies and series',
      });
  
      await subscription.save();
  
      // Create Bill object
      const bill = new Bill({
        name: 'Electricity Bill',
        amount: 120,
        dueDate: new Date('2024-12-25'),
        paymentMethod: 'Card',
        status: 'Due',
        frequency: 'Monthly',
        category: 'Utilities',
        userId: userId, // Replace with actual userId
      });
  
      await bill.save();
  
      // Create Finance object
      const finance = new Finance({
        userId: userId, // Replace with actual userId
        title: 'Personal Finance',
        type: 'finance',
        subscriptions: [subscription._id], // Add actual subscription references
        categories: [category._id], // Linking the category to finance
        bills: [bill._id], // Add bill references if needed
        incomes: [income._id], // Add income references if needed
        net: 1000, // Example net amount
      });
  
      // Save finance to the database
      await finance.save();

      await User.findByIdAndUpdate(userId, {
        $push: { templates: { templateId: finance._id, title: title || type ,
          icon: "🎓",
          image: "https://i.pinimg.com/564x/91/65/40/916540a9c1883b4897e259831c4b08a9.jpg",
         } },
      });

      console.log('Finance document with categories and expenses saved successfully!');
      res.status(200).json({ message: 'Finance data created successfully' });
    } catch (err) {
      console.error('Error creating finance data:', err);
      res.status(500).json({ message: 'Error creating finance data' });
    }
  };
  */
  
  // Call the function to create and save the finance data
 
  
/*
// Fetch all categories
app.get('/api/categories', async (req, res) => {
  try {
    const categories = await Category.find().populate('expenses').exec();
    res.json(categories);
  } catch (err) {
    res.status(500).json({ message: 'Error fetching categories', error: err });
  }
});

// Fetch all incomes
app.get('/api/incomes', async (req, res) => {
  try {
    const incomes = await Income.find().exec();
    res.json(incomes);
  } catch (err) {
    res.status(500).json({ message: 'Error fetching incomes', error: err });
  }
});

// Fetch all subscriptions
app.get('/api/subscriptions', async (req, res) => {
  try {
    const subscriptions = await Subscription.find().exec();
    res.json(subscriptions);
  } catch (err) {
    res.status(500).json({ message: 'Error fetching subscriptions', error: err });
  }
});

// Fetch all expenses
app.get('/api/expenses', async (req, res) => {
  try {
    const expenses = await Expense.find().exec();
    res.json(expenses);
  } catch (err) {
    res.status(500).json({ message: 'Error fetching expenses', error: err });
  }
});

*/