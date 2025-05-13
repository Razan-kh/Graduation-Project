const mongoose = require('mongoose');
const db = require("../config/database");
const { Schema } = mongoose;

const financeSchema = new Schema({
  userId: { type: Schema.Types.ObjectId, ref: 'User', required: true }, // Reference to User
  title: { type: String, required: true }, // Title of the finance document
  type: { type: String, required: true }, // e.g., 'custom'
  subscriptions: [{ type: Schema.Types.ObjectId, ref: 'Subscription' }], // Reference to Subscription documents
  categories: [{ type: Schema.Types.ObjectId, ref: 'Category' }], // Reference to Category documents
  bills: [{ type: Schema.Types.ObjectId, ref: 'Bill' }], // Reference to Bill documents
  net: { type: Number, default: 0 }, // Net amount (calculated)
  incomes: [{ type: Schema.Types.ObjectId, ref: 'Income' }], // Reference to Income documents
  createdAt: { type: Date, default: Date.now }, // Timestamp
});



const categorySchema = new mongoose.Schema({
  name: { type: String, required: true }, // Category name, e.g., "Food", "Utilities"
  description: { type: String }, // Optional description
  icon: { type: String }, // Optional icon or emoji representation
  color: { type: String }, // Optional color for UI
  totalAmount: {type: Number},
  expenses: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Expense' }], // Array of expense IDs
}, { timestamps: true });

const expenseSchema = new mongoose.Schema({
  name: { type: String, required: true }, // Expense name, e.g., "Lunch at McDonald's"
  amount: { type: Number, required: true }, // Expense amount
  date: { type: Date, default: Date.now }, // Expense date
  category: { type: mongoose.Schema.Types.ObjectId, ref: 'Category' }, // Associated category
  notes: { type: String }, // Optional notes
}, { timestamps: true });



const incomeSchema = new Schema({
  name: { type: String, required: true }, // Income source, e.g., "Salary", "Freelance Project"
  amount: { type: Number, required: true }, // Income amount
  date: { type: Date, default: Date.now }, // Date of income (for one-time income)
  notes: { type: String }, // Optional notes
  type: { 
    type: String, 
    required: true, 
    enum: ['one-time', 'monthly', 'yearly','weekly'], // Specify whether it's one-time or recurring
    default: 'one-time' // Default type if not specified
  },
  renewalDate: { type: Date }, // Next renewal date
}, { timestamps: true });


const subscriptionSchema = new mongoose.Schema({
  name: { type: String, required: true }, // Subscription name, e.g., "Netflix"
  amount: { type: Number, required: true }, // Subscription amount
  renewalDate: { type: Date, required: true }, // Next renewal date
  frequency: { type: String, enum: ['Monthly', 'Yearly','Weekly'], required: true }, // Frequency of renewal
  status: { type: String, enum: ['Active', 'Paused'], default: 'Active' }, // Subscription status
  category: { type: mongoose.Schema.Types.ObjectId, ref: 'Category' }, // Associated category
  notes: { type: String }, // Optional notes
}, { timestamps: true });

const billSchema = new mongoose.Schema({
  name: { type: String, required: true }, // Name of the bill (e.g., 'Electricity', 'Rent')
  amount: { type: Number, required: true }, // Amount to be paid for the bill
  dueDate: { type: Date, required: true }, // Due date for the bill
  paidDate: { type: Date }, // Date when the bill was paid (optional, null if not paid)
  paymentMethod: { type: String, enum: ['Cash', 'Card', 'Bank Transfer', 'Online'], required: true }, // Payment method
  status: { type: String, enum: ['Paid', 'Due', 'Overdue'], default: 'Due' }, // Status of the bill (Paid, Due, Overdue)
  frequency: { type: String, enum: ['One-time', 'Monthly', 'Yearly'], default: 'Monthly' }, // Frequency of the bill
  category: { type: String, enum: ['Utilities', 'Rent', 'Subscription', 'Insurance', 'Loan', 'Others'] }, // Category of the bill
  userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true }, // Link to the user this bill belongs to
  createdAt: { type: Date, default: Date.now }, // When the bill was created
  updatedAt: { type: Date, default: Date.now }, // Last updated time
});

const Subscription = db.model('Subscription', subscriptionSchema);
const Income = db.model('Income', incomeSchema);
const Expense = db.model('Expense', expenseSchema);
const Category = db.model('Category', categorySchema);
const Finance = db.model('Finance', financeSchema);
const Bill = db.model('Bill', billSchema);

module.exports = { Bill, Subscription, Income, Expense, Category, Finance };