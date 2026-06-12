// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// ─── MODEL ───────────────────────────────────────────────
class Expense {
  String id;
  String title;
  double amount;
  String category;
  DateTime date;
  String notes;

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    this.notes = '',
  });
}

// ─── CONSTANTS ────────────────────────────────────────────
const kGreen = Color(0xFF1a6b45);
const kGreenLight = Color(0xFFe1f5ee);

const kCategories = ['Food', 'Transport', 'Utilities', 'Shopping', 'Health', 'Other'];

const kEmoji = {
  'Food': '🍔', 'Transport': '🚗', 'Utilities': '⚡',
  'Shopping': '🛍️', 'Health': '💊', 'Other': '📦',
};

const kColors = {
  'Food': Color(0xFFf09550),
  'Transport': Color(0xFF378add),
  'Utilities': Color(0xFFba7517),
  'Shopping': Color(0xFFd4537e),
  'Health': Color(0xFF1d9e75),
  'Other': Color(0xFF7f77dd),
};

// Sample items per category
const kCategoryItems = {
  'Food': ['Breakfast', 'Lunch', 'Dinner', 'Snacks', 'Groceries', 'Coffee', 'Restaurant', 'Fast Food'],
  'Transport': ['Uber/Careem', 'Fuel/Petrol', 'Bus Ticket', 'Rickshaw', 'Parking', 'Car Service', 'Train Ticket'],
  'Utilities': ['Electricity Bill', 'Gas Bill', 'Water Bill', 'Internet Bill', 'Mobile Recharge', 'Cable TV'],
  'Shopping': ['Clothes', 'Shoes', 'Electronics', 'Books', 'Accessories', 'Home Items', 'Online Order'],
  'Health': ['Medicine', 'Doctor Fee', 'Lab Test', 'Gym Fee', 'Vitamins', 'Dental', 'Eye Care'],
  'Other': ['Entertainment', 'Education', 'Gift', 'Salon', 'Charity', 'Miscellaneous'],
};

// ─── APP ─────────────────────────────────────────────────
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: kGreen),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const MainScreen(),
    );
  }
}

// ─── MAIN SCREEN ─────────────────────────────────────────
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _index = 0;
  final List<Expense> _expenses = [];

  void _addExpense(Expense e) => setState(() => _expenses.insert(0, e));
  void _deleteExpense(String id) => setState(() => _expenses.removeWhere((e) => e.id == id));
  void _updateExpense(Expense updated) => setState(() {
    final i = _expenses.indexWhere((e) => e.id == updated.id);
    if (i != -1) _expenses[i] = updated;
  });

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(expenses: _expenses, onDelete: _deleteExpense, onUpdate: _updateExpense),
      AddScreen(onAdd: _addExpense),
      SummaryScreen(expenses: _expenses),
    ];

    return Scaffold(
      body: screens[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        selectedItemColor: kGreen,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        elevation: 8,
        onTap: (i) => setState(() => _index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline), activeIcon: Icon(Icons.add_circle), label: 'Add'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart_outlined), activeIcon: Icon(Icons.bar_chart), label: 'Summary'),
        ],
      ),
    );
  }
}

// ─── HOME SCREEN ──────────────────────────────────────────
class HomeScreen extends StatefulWidget {
  final List<Expense> expenses;
  final Function(String) onDelete;
  final Function(Expense) onUpdate;

  const HomeScreen({super.key, required this.expenses, required this.onDelete, required this.onUpdate});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _filter = 'All';

  @override
  Widget build(BuildContext context) {
    final sorted = [...widget.expenses]..sort((a, b) => b.date.compareTo(a.date));
    final filtered = _filter == 'All' ? sorted : sorted.where((e) => e.category == _filter).toList();
    final total = widget.expenses.fold(0.0, (s, e) => s + e.amount);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: Column(
        children: [
          // Header
          Container(
            color: kGreen,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 14,
              left: 20, right: 20, bottom: 20,
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('My Expenses', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700)),
                  Text('${widget.expenses.length} expense${widget.expenses.length != 1 ? 's' : ''} total',
                      style: const TextStyle(color: Colors.white60, fontSize: 13)),
                ]),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.notifications_outlined, color: Colors.white, size: 22),
                ),
              ]),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('Total Spent', style: TextStyle(color: Colors.white70, fontSize: 12)),
                    const SizedBox(height: 4),
                    Text('Rs ${_fmt(total)}',
                        style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w700)),
                  ]),
                  const Icon(Icons.account_balance_wallet_outlined, color: Colors.white38, size: 40),
                ]),
              ),
            ]),
          ),

          // Filter chips
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: ['All', ...kCategories].map((f) {
                  final active = _filter == f;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => setState(() => _filter = f),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                        decoration: BoxDecoration(
                          color: active ? kGreen : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(99),
                          border: Border.all(color: active ? kGreen : Colors.grey.shade300),
                        ),
                        child: Text(
                          f == 'All' ? 'All' : '${kEmoji[f]} $f',
                          style: TextStyle(
                            color: active ? Colors.white : Colors.grey[700],
                            fontSize: 12, fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // List
          Expanded(
            child: filtered.isEmpty
                ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.receipt_long_outlined, size: 64, color: Colors.grey.shade300),
              const SizedBox(height: 12),
              Text('No expenses yet', style: TextStyle(color: Colors.grey.shade400, fontSize: 16)),
              Text('Tap Add to get started!', style: TextStyle(color: Colors.grey.shade400, fontSize: 13)),
            ]))
                : ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                itemCount: filtered.length,
                itemBuilder: (ctx, i) {
                  final e = filtered[i];
                  final color = kColors[e.category] ?? Colors.grey;
                  final emoji = kEmoji[e.category] ?? '📦';
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(children: [
                        Container(
                          width: 46, height: 46,
                          decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
                          child: Center(child: Text(emoji, style: const TextStyle(fontSize: 22))),
                        ),
                        const SizedBox(width: 12),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(e.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                              maxLines: 1, overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 3),
                          Row(children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: color.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(99),
                              ),
                              child: Text(e.category, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w500)),
                            ),
                            if (e.notes.isNotEmpty) ...[
                              const SizedBox(width: 6),
                              Expanded(child: Text(e.notes, style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
                                  maxLines: 1, overflow: TextOverflow.ellipsis)),
                            ],
                          ]),
                          const SizedBox(height: 6),
                          Row(children: [
                            GestureDetector(
                              onTap: () => Navigator.push(context, MaterialPageRoute(
                                builder: (_) => EditScreen(expense: e, onUpdate: widget.onUpdate),
                              )),
                              child: Row(children: [
                                Icon(Icons.edit_outlined, size: 14, color: Colors.grey.shade500),
                                const SizedBox(width: 3),
                                Text('Edit', style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                              ]),
                            ),
                            const SizedBox(width: 14),
                            GestureDetector(
                              onTap: () => showDialog(context: context, builder: (_) => AlertDialog(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                title: const Text('Delete Expense'),
                                content: Text('Delete "${e.title}"?'),
                                actions: [
                                  TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                                    onPressed: () { widget.onDelete(e.id); Navigator.pop(context); },
                                    child: const Text('Delete'),
                                  ),
                                ],
                              )),
                              child: Row(children: [
                                Icon(Icons.delete_outline, size: 14, color: Colors.red.shade400),
                                const SizedBox(width: 3),
                                Text('Delete', style: TextStyle(color: Colors.red.shade400, fontSize: 12)),
                              ]),
                            ),
                          ]),
                        ])),
                        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                          Text('Rs ${_fmt(e.amount)}',
                              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Color(0xFF1a1a1a))),
                          const SizedBox(height: 4),
                          Text(_date(e.date), style: TextStyle(color: Colors.grey.shade400, fontSize: 11)),
                        ]),
                      ]),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}

// ─── ADD SCREEN ───────────────────────────────────────────
class AddScreen extends StatefulWidget {
  final Function(Expense) onAdd;
  const AddScreen({super.key, required this.onAdd});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  DateTime _date = DateTime.now();
  String? _cat;

  @override
  void dispose() {
    _titleCtrl.dispose(); _amountCtrl.dispose(); _notesCtrl.dispose();
    super.dispose();
  }

  // When category tapped → show bottom sheet with items
  void _selectCategory(String cat) {
    setState(() => _cat = cat);
    final items = kCategoryItems[cat] ?? [];
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Text(kEmoji[cat]!, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 10),
            Text(cat, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const Spacer(),
            IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
          ]),
          const SizedBox(height: 4),
          Text('Select an item or type your own title below', style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8, runSpacing: 8,
            children: items.map((item) => GestureDetector(
              onTap: () {
                _titleCtrl.text = item;
                Navigator.pop(context);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: (kColors[cat] ?? Colors.grey).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(99),
                  border: Border.all(color: (kColors[cat] ?? Colors.grey).withValues(alpha: 0.3)),
                ),
                child: Text(item, style: TextStyle(
                  color: kColors[cat] ?? Colors.grey,
                  fontSize: 13, fontWeight: FontWeight.w500,
                )),
              ),
            )).toList(),
          ),
          const SizedBox(height: 16),
        ]),
      ),
    );
  }

  void _save() {
    if (_cat == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a category'), backgroundColor: Colors.red),
      );
      return;
    }
    if (!_formKey.currentState!.validate()) return;

    widget.onAdd(Expense(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleCtrl.text.trim(),
      amount: double.parse(_amountCtrl.text.trim()),
      category: _cat!,
      date: _date,
      notes: _notesCtrl.text.trim(),
    ));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('✅ Expense saved!'), backgroundColor: kGreen),
    );
    _titleCtrl.clear(); _amountCtrl.clear(); _notesCtrl.clear();
    setState(() { _cat = null; _date = DateTime.now(); });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text('Add Expense', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        backgroundColor: kGreen,
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            // ── Category ──
            _sectionCard(
              title: 'Select Category',
              child: GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.1,
                children: kCategories.map((cat) {
                  final sel = _cat == cat;
                  final color = kColors[cat]!;
                  return GestureDetector(
                    onTap: () => _selectCategory(cat),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      decoration: BoxDecoration(
                        color: sel ? color.withValues(alpha: 0.12) : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: sel ? color : Colors.grey.shade200,
                          width: sel ? 2 : 1,
                        ),
                        boxShadow: sel ? [] : [
                          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 4, offset: const Offset(0, 2)),
                        ],
                      ),
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Text(kEmoji[cat]!, style: const TextStyle(fontSize: 26)),
                        const SizedBox(height: 6),
                        Text(cat, style: TextStyle(
                          fontSize: 12,
                          fontWeight: sel ? FontWeight.w700 : FontWeight.w500,
                          color: sel ? color : Colors.grey[700],
                        )),
                        if (sel) ...[
                          const SizedBox(height: 2),
                          Icon(Icons.check_circle, size: 14, color: color),
                        ]
                      ]),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 14),

            // ── Title ──
            _sectionCard(
              title: 'Title *',
              child: TextFormField(
                controller: _titleCtrl,
                decoration: _deco('e.g. Dinner with friends'),
                validator: (v) => v == null || v.trim().isEmpty ? 'Please enter a title' : null,
              ),
            ),
            const SizedBox(height: 14),

            // ── Amount ──
            _sectionCard(
              title: 'Amount (Rs) *',
              child: TextFormField(
                controller: _amountCtrl,
                keyboardType: TextInputType.number,
                decoration: _deco('e.g. 2200'),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Please enter an amount';
                  final n = double.tryParse(v.trim());
                  if (n == null || n <= 0) return 'Enter a positive number';
                  return null;
                },
              ),
            ),
            const SizedBox(height: 14),

            // ── Date ──
            _sectionCard(
              title: 'Date *',
              child: GestureDetector(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _date,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                    builder: (ctx, child) => Theme(
                      data: Theme.of(ctx).copyWith(colorScheme: const ColorScheme.light(primary: kGreen)),
                      child: child!,
                    ),
                  );
                  if (picked != null) setState(() => _date = picked);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text(_date2(_date), style: const TextStyle(fontSize: 15)),
                    Icon(Icons.calendar_today_outlined, color: Colors.grey.shade500, size: 18),
                  ]),
                ),
              ),
            ),
            const SizedBox(height: 14),

            // ── Notes ──
            _sectionCard(
              title: 'Notes (optional)',
              child: TextFormField(
                controller: _notesCtrl,
                decoration: _deco('Any extra details...'),
                maxLines: 2,
              ),
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kGreen, foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 2,
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                child: const Text('Save Expense'),
              ),
            ),
            const SizedBox(height: 16),
          ]),
        ),
      ),
    );
  }
}

// ─── EDIT SCREEN ──────────────────────────────────────────
class EditScreen extends StatefulWidget {
  final Expense expense;
  final Function(Expense) onUpdate;
  const EditScreen({super.key, required this.expense, required this.onUpdate});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleCtrl;
  late TextEditingController _amountCtrl;
  late TextEditingController _notesCtrl;
  late DateTime _date;
  late String? _cat;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.expense.title);
    _amountCtrl = TextEditingController(text: widget.expense.amount.toString());
    _notesCtrl = TextEditingController(text: widget.expense.notes);
    _date = widget.expense.date;
    _cat = widget.expense.category;
  }

  @override
  void dispose() {
    _titleCtrl.dispose(); _amountCtrl.dispose(); _notesCtrl.dispose();
    super.dispose();
  }

  void _update() {
    if (!_formKey.currentState!.validate()) return;
    widget.onUpdate(Expense(
      id: widget.expense.id,
      title: _titleCtrl.text.trim(),
      amount: double.parse(_amountCtrl.text.trim()),
      category: _cat!,
      date: _date,
      notes: _notesCtrl.text.trim(),
    ));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('✅ Expense updated!'), backgroundColor: kGreen),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text('Edit Expense', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        backgroundColor: kGreen,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            _sectionCard(
              title: 'Category',
              child: GridView.count(
                crossAxisCount: 3, shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 1.1,
                children: kCategories.map((cat) {
                  final sel = _cat == cat;
                  final color = kColors[cat]!;
                  return GestureDetector(
                    onTap: () => setState(() => _cat = cat),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      decoration: BoxDecoration(
                        color: sel ? color.withValues(alpha: 0.12) : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: sel ? color : Colors.grey.shade200, width: sel ? 2 : 1),
                      ),
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Text(kEmoji[cat]!, style: const TextStyle(fontSize: 26)),
                        const SizedBox(height: 6),
                        Text(cat, style: TextStyle(
                          fontSize: 12,
                          fontWeight: sel ? FontWeight.w700 : FontWeight.w500,
                          color: sel ? color : Colors.grey[700],
                        )),
                      ]),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 14),

            _sectionCard(title: 'Title *', child: TextFormField(
              controller: _titleCtrl,
              decoration: _deco('Title'),
              validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
            )),
            const SizedBox(height: 14),

            _sectionCard(title: 'Amount (Rs) *', child: TextFormField(
              controller: _amountCtrl,
              keyboardType: TextInputType.number,
              decoration: _deco('Amount'),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Required';
                final n = double.tryParse(v.trim());
                if (n == null || n <= 0) return 'Enter a positive number';
                return null;
              },
            )),
            const SizedBox(height: 14),

            _sectionCard(
              title: 'Date',
              child: GestureDetector(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _date,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                    builder: (ctx, child) => Theme(
                      data: Theme.of(ctx).copyWith(colorScheme: const ColorScheme.light(primary: kGreen)),
                      child: child!,
                    ),
                  );
                  if (picked != null) setState(() => _date = picked);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text(_date2(_date), style: const TextStyle(fontSize: 15)),
                    Icon(Icons.calendar_today_outlined, color: Colors.grey.shade500, size: 18),
                  ]),
                ),
              ),
            ),
            const SizedBox(height: 14),

            _sectionCard(title: 'Notes (optional)', child: TextFormField(
              controller: _notesCtrl,
              decoration: _deco('Notes'),
              maxLines: 2,
            )),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _update,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kGreen, foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                child: const Text('Update Expense'),
              ),
            ),
            const SizedBox(height: 16),
          ]),
        ),
      ),
    );
  }
}

// ─── SUMMARY SCREEN ───────────────────────────────────────
class SummaryScreen extends StatelessWidget {
  final List<Expense> expenses;
  const SummaryScreen({super.key, required this.expenses});

  @override
  Widget build(BuildContext context) {
    final total = expenses.fold(0.0, (s, e) => s + e.amount);
    final avg = expenses.isEmpty ? 0.0 : total / expenses.length;

    final Map<String, double> catTotals = {};
    for (final e in expenses) {
      catTotals[e.category] = (catTotals[e.category] ?? 0) + e.amount;
    }
    final sorted = catTotals.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    final maxVal = sorted.isEmpty ? 1.0 : sorted.first.value;

    Expense? topExpense;
    if (expenses.isNotEmpty) {
      topExpense = expenses.reduce((a, b) => a.amount > b.amount ? a : b);
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text('Summary', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        backgroundColor: kGreen,
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: expenses.isEmpty
          ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.bar_chart_outlined, size: 64, color: Colors.grey.shade300),
        const SizedBox(height: 12),
        Text('No data yet', style: TextStyle(color: Colors.grey.shade400, fontSize: 16)),
        Text('Add some expenses first', style: TextStyle(color: Colors.grey.shade400, fontSize: 13)),
      ]))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          // Metric cards
          Row(children: [
            _metricCard('Total Spent', 'Rs ${_fmt(total)}'),
            const SizedBox(width: 10),
            _metricCard('Expenses', '${expenses.length}'),
          ]),
          const SizedBox(height: 10),
          SizedBox(width: double.infinity,
              child: _metricCard('Avg per Expense', 'Rs ${_fmt(avg)}', full: true)),

          // Chart
          const SizedBox(height: 20),
          const Text('Category Breakdown', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)],
            ),
            child: Column(children: sorted.map((entry) {
              final color = kColors[entry.key] ?? Colors.grey;
              final emoji = kEmoji[entry.key] ?? '📦';
              final pct = entry.value / maxVal;
              final pctStr = total > 0 ? '${(entry.value / total * 100).toStringAsFixed(1)}%' : '0%';
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text('$emoji  ${entry.key}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    Text('Rs ${_fmt(entry.value)}  ·  $pctStr',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: color)),
                  ]),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(99),
                    child: LinearProgressIndicator(
                      value: pct,
                      backgroundColor: color.withValues(alpha: 0.1),
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                      minHeight: 10,
                    ),
                  ),
                ]),
              );
            }).toList()),
          ),

          // Top expense
          if (topExpense != null) ...[
            const SizedBox(height: 20),
            const Text('Highest Expense', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: kGreenLight,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: kGreen.withValues(alpha: 0.3)),
              ),
              child: Row(children: [
                Text(kEmoji[topExpense.category] ?? '📦', style: const TextStyle(fontSize: 28)),
                const SizedBox(width: 14),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(topExpense.title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                  const SizedBox(height: 2),
                  Text('${topExpense.category}  ·  ${_date(topExpense.date)}',
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                ])),
                Text('Rs ${_fmt(topExpense.amount)}',
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: kGreen)),
              ]),
            ),
          ],
          const SizedBox(height: 20),
        ]),
      ),
    );
  }

  Widget _metricCard(String label, String value, {bool full = false}) {
    final card = Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
      ]),
    );
    return full ? card : Expanded(child: card);
  }
}

// ─── SHARED WIDGETS ───────────────────────────────────────
Widget _sectionCard({required String title, required Widget child}) {
  return Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))],
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey.shade600)),
      const SizedBox(height: 10),
      child,
    ]),
  );
}

InputDecoration _deco(String hint) => InputDecoration(
  hintText: hint,
  hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
  filled: true,
  fillColor: Colors.grey.shade50,
  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)),
  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)),
  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: kGreen, width: 1.5)),
  errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.red)),
);

// ─── HELPERS ──────────────────────────────────────────────
String _fmt(double v) {
  final n = v.toStringAsFixed(0);
  final buf = StringBuffer();
  int count = 0;
  for (int i = n.length - 1; i >= 0; i--) {
    if (count > 0 && count % 3 == 0) buf.write(',');
    buf.write(n[i]);
    count++;
  }
  return buf.toString().split('').reversed.join();
}

final _months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
String _date(DateTime d) => '${d.day} ${_months[d.month - 1]} ${d.year}';
String _date2(DateTime d) => '${d.day.toString().padLeft(2, '0')} ${_months[d.month - 1]} ${d.year}';