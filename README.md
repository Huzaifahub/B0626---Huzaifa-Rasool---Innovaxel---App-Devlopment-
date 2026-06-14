## Expense Tracker App

Flutter Mobile Application — Internship Task Submission

Submitted by: Huzaifa Rasool
Company: Innovaxel
Batch: B0626
## App Screenshots
<img width="1537" height="852" alt="image" src="https://github.com/user-attachments/assets/d867b047-1db2-4b1d-a444-aa4cfb5ab4c0" />


<img width="1558" height="862" alt="image" src="https://github.com/user-attachments/assets/febab747-3147-4e3b-85fe-3d010c8f947b" />


<img width="1534" height="791" alt="image" src="https://github.com/user-attachments/assets/3c8fc1f4-f7ac-4423-bb4b-1d0d579a1b7b" />


<img width="1554" height="856" alt="image" src="https://github.com/user-attachments/assets/3af92524-c824-4ab7-9c37-1c63065a0e76" />


<img width="1550" height="856" alt="image" src="https://github.com/user-attachments/assets/1913394a-26e8-4ad8-ad94-cb7c74e87bd5" />


<img width="1556" height="856" alt="image" src="https://github.com/user-attachments/assets/f7db2039-8cf8-4c45-85fb-29c500f8476c" />

## Overview

A fully functional Personal Expense Tracker mobile application built with Flutter. The app allows users to add, view, edit, and delete their personal expenses, filter them by category, view a visual spending summary, and even send payments via JazzCash, Easypaisa, or Bank Transfer — all from a clean, professional UI.


## Features Implemented

 # Add New Expense
Title input (e.g. Dinner with friends)
Amount input in Rs (e.g. 2200)
Category selection with 6 options — Food, Transport, Utilities, Shopping, Health, Other
Smart category items — tap a category and get pre-filled suggestions (e.g. tap Food → see Breakfast, Lunch, Dinner, Restaurant etc.)
Date picker
Optional notes field
Full input validation — no negative values, no empty fields allowed

 # View All Expenses
Clean card-based list UI
Sorted by date — most recent first
Each card shows: title, category badge, notes, amount, date
Filter by category — horizontal scrollable filter chips (All, Food, Transport, Utilities, Shopping, Health, Other)
Empty state screen when no expenses added

 #  Edit & Delete
Edit button on every expense card — opens full edit form
Delete button with confirmation dialog — prevents accidental deletion
All changes reflect instantly

 #  View Summary
Total amount spent
Total number of expenses
Average per expense
Category-wise breakdown with color-coded progress bars and percentage
Highest expense highlighted in a Navy gradient card
 Payment Screen (Bonus)

# Send payments via:

🔴 JazzCash — mobile number
🟢 Easypaisa — mobile number
🏦 Bank Transfer — IBAN number

Recipient name + amount fields
Live payment summary preview
2-second processing animation
Success confirmation popup
"Secured & Encrypted" badge
# Architecture

lib/
└── main.dart         
    ├── Expense        
    ├── MainScreen     
    ├── HomeScreen    
    ├── AddScreen     
    ├── EditScreen    
    ├── SummaryScreen  
    └── PayScreen      
  State Management: Flutter built-in setState — clean and lightweight
Data Storage: In-memory (can be extended with SharedPreferences or Hive)
# Future Improvements

SharedPreferences / Hive for persistent local storage
Real JazzCash & Easypaisa API integration
Monthly budget limits with alerts
Export expenses to PDF/CSV
Dark mode support
Multi-currency support
# Developer
Huzaifa Rasool
Internship Applicant — App Development
Innovaxel — Batch B0626
