// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}
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

const kPrimary    = Color(0xFF1C3557); // Deep Navy
const kAccent     = Color(0xFFF5A623); // Gold
const kBg         = Color(0xFFF0F4F8); // Light blue-grey bg
const kCard       = Colors.white;

const kCategories = ['Food', 'Transport', 'Utilities', 'Shopping', 'Health', 'Other'];

const kEmoji = {
  'Food': '🍔', 'Transport': '🚗', 'Utilities': '⚡',
  'Shopping': '🛍️', 'Health': '💊', 'Other': '📦',
};

const kCatColors = {
  'Food':      Color(0xFFE8624A),
  'Transport': Color(0xFF3A86FF),
  'Utilities': Color(0xFFF5A623),
  'Shopping':  Color(0xFFBE4BDB),
  'Health':    Color(0xFF12B886),
  'Other':     Color(0xFF868E96),
};

const kCategoryItems = {
  'Food':      ['Breakfast', 'Lunch', 'Dinner', 'Snacks', 'Groceries', 'Coffee', 'Restaurant', 'Fast Food'],
  'Transport': ['Uber / Careem', 'Fuel / Petrol', 'Bus Ticket', 'Rickshaw', 'Parking', 'Car Service', 'Train Ticket'],
  'Utilities': ['Electricity Bill', 'Gas Bill', 'Water Bill', 'Internet Bill', 'Mobile Recharge', 'Cable TV'],
  'Shopping':  ['Clothes', 'Shoes', 'Electronics', 'Books', 'Accessories', 'Home Items', 'Online Order'],
  'Health':    ['Medicine', 'Doctor Fee', 'Lab Test', 'Gym Fee', 'Vitamins', 'Dental', 'Eye Care'],
  'Other':     ['Entertainment', 'Education', 'Gift', 'Salon', 'Charity', 'Miscellaneous'],
};

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: kPrimary),
        useMaterial3: true,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: kBg,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _index = 0;
  final List<Expense> _expenses = [];

  void _add(Expense e)         => setState(() => _expenses.insert(0, e));
  void _delete(String id)      => setState(() => _expenses.removeWhere((e) => e.id == id));
  void _update(Expense updated) => setState(() {
    final i = _expenses.indexWhere((e) => e.id == updated.id);
    if (i != -1) _expenses[i] = updated;
  });

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(expenses: _expenses, onDelete: _delete, onUpdate: _update),
      AddScreen(onAdd: _add),
      SummaryScreen(expenses: _expenses),
      const PayScreen(),
    ];

    return Scaffold(
      body: screens[_index],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Color(0x1A000000), blurRadius: 12, offset: Offset(0, -2))],
        ),
        child: BottomNavigationBar(
          currentIndex: _index,
          selectedItemColor: kPrimary,
          unselectedItemColor: const Color(0xFFADB5BD),
          backgroundColor: Colors.white,
          elevation: 0,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
          onTap: (i) => setState(() => _index = i),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined),        activeIcon: Icon(Icons.home),         label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline),   activeIcon: Icon(Icons.add_circle),   label: 'Add'),
            BottomNavigationBarItem(icon: Icon(Icons.bar_chart_outlined),   activeIcon: Icon(Icons.bar_chart),    label: 'Summary'),
            BottomNavigationBarItem(icon: Icon(Icons.payment_outlined),     activeIcon: Icon(Icons.payment),      label: 'Pay'),
          ],
        ),
      ),
    );
  }
}

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

  void _showNotifications(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      backgroundColor: Colors.white,
      builder: (_) {
        final recent = [...widget.expenses]
          ..sort((a, b) => b.date.compareTo(a.date));
        final last5 = recent.take(5).toList();

        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text('Notifications', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: kPrimary)),
              IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
            ]),
            const Divider(),
            if (last5.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(child: Text('No recent activity', style: TextStyle(color: Colors.grey))),
              )
            else
              ...last5.map((e) {
                final color = kCatColors[e.category] ?? Colors.grey;
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
                    child: Center(child: Text(kEmoji[e.category] ?? '📦', style: const TextStyle(fontSize: 18))),
                  ),
                  title: Text(e.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  subtitle: Text('${e.category}  ·  ${_date(e.date)}', style: const TextStyle(fontSize: 12)),
                  trailing: Text('Rs ${_fmt(e.amount)}',
                      style: const TextStyle(fontWeight: FontWeight.w700, color: kPrimary, fontSize: 14)),
                );
              }),
            const SizedBox(height: 8),
          ]),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final sorted   = [...widget.expenses]..sort((a, b) => b.date.compareTo(a.date));
    final filtered = _filter == 'All' ? sorted : sorted.where((e) => e.category == _filter).toList();
    final total    = widget.expenses.fold(0.0, (s, e) => s + e.amount);
    final thisMonth = widget.expenses.where((e) =>
    e.date.month == DateTime.now().month && e.date.year == DateTime.now().year
    ).fold(0.0, (s, e) => s + e.amount);

    return Scaffold(
      backgroundColor: kBg,
      body: Column(children: [
        // ── Header ──
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1C3557), Color(0xFF2A4F7C)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 14,
            left: 20, right: 20, bottom: 24,
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Top row
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('My Expenses', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700)),
                Text('${widget.expenses.length} records total',
                    style: const TextStyle(color: Colors.white54, fontSize: 13)),
              ]),
              GestureDetector(
                onTap: () => _showNotifications(context),
                child: Stack(children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.notifications_outlined, color: Colors.white, size: 24),
                  ),
                  if (widget.expenses.isNotEmpty)
                    Positioned(
                      right: 6, top: 6,
                      child: Container(
                        width: 8, height: 8,
                        decoration: const BoxDecoration(color: kAccent, shape: BoxShape.circle),
                      ),
                    ),
                ]),
              ),
            ]),
            const SizedBox(height: 20),

            // Stats row
            Row(children: [
              Expanded(child: _statBox('Total Spent', 'Rs ${_fmt(total)}')),
              const SizedBox(width: 12),
              Expanded(child: _statBox('This Month', 'Rs ${_fmt(thisMonth)}')),
            ]),
          ]),
        ),

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
                        color: active ? kPrimary : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(99),
                        border: Border.all(color: active ? kPrimary : Colors.grey.shade300),
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

        Expanded(
          child: filtered.isEmpty
              ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.receipt_long_outlined, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 12),
            Text('No expenses yet', style: TextStyle(color: Colors.grey.shade400, fontSize: 16, fontWeight: FontWeight.w500)),
            Text('Tap Add to get started!', style: TextStyle(color: Colors.grey.shade400, fontSize: 13)),
          ]))
              : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              itemCount: filtered.length,
              itemBuilder: (ctx, i) {
                final e     = filtered[i];
                final color = kCatColors[e.category] ?? Colors.grey;
                final emoji = kEmoji[e.category] ?? '📦';
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 3))],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(children: [
                      Container(
                        width: 48, height: 48,
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(13),
                        ),
                        child: Center(child: Text(emoji, style: const TextStyle(fontSize: 22))),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(e.title,
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF1A1A2E)),
                            maxLines: 1, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 4),
                        Row(children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(99),
                            ),
                            child: Text(e.category,
                                style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
                          ),
                          if (e.notes.isNotEmpty) ...[
                            const SizedBox(width: 6),
                            Expanded(child: Text(e.notes,
                                style: const TextStyle(color: Color(0xFFADB5BD), fontSize: 11),
                                maxLines: 1, overflow: TextOverflow.ellipsis)),
                          ],
                        ]),
                        const SizedBox(height: 8),
                        Row(children: [
                          _actionBtn(Icons.edit_outlined, 'Edit', const Color(0xFF3A86FF), () =>
                              Navigator.push(context, MaterialPageRoute(
                                builder: (_) => EditScreen(expense: e, onUpdate: widget.onUpdate),
                              ))),
                          const SizedBox(width: 16),
                          _actionBtn(Icons.delete_outline, 'Delete', const Color(0xFFE8624A), () =>
                              showDialog(context: context, builder: (_) => AlertDialog(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                title: const Text('Delete Expense?'),
                                content: Text('Are you sure you want to delete "${e.title}"?'),
                                actions: [
                                  TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE8624A), foregroundColor: Colors.white),
                                    onPressed: () { widget.onDelete(e.id); Navigator.pop(context); },
                                    child: const Text('Delete'),
                                  ),
                                ],
                              ))),
                        ]),
                      ])),
                      Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                        Text('Rs ${_fmt(e.amount)}',
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: kPrimary)),
                        const SizedBox(height: 4),
                        Text(_date(e.date), style: const TextStyle(color: Color(0xFFADB5BD), fontSize: 11)),
                      ]),
                    ]),
                  ),
                );
              }),
        ),
      ]),
    );
  }

  Widget _statBox(String label, String value) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(color: Colors.white60, fontSize: 11, fontWeight: FontWeight.w500)),
      const SizedBox(height: 6),
      Text(value, style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700)),
    ]),
  );

  Widget _actionBtn(IconData icon, String label, Color color, VoidCallback onTap) =>
      GestureDetector(
        onTap: onTap,
        child: Row(children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 3),
          Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w500)),
        ]),
      );
}


class AddScreen extends StatefulWidget {
  final Function(Expense) onAdd;
  const AddScreen({super.key, required this.onAdd});
  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final _formKey   = GlobalKey<FormState>();
  final _titleCtrl  = TextEditingController();
  final _amountCtrl = TextEditingController();
  final _notesCtrl  = TextEditingController();
  DateTime _date    = DateTime.now();
  String?  _cat;

  @override
  void dispose() {
    _titleCtrl.dispose(); _amountCtrl.dispose(); _notesCtrl.dispose();
    super.dispose();
  }

  void _pickCategory(String cat) {
    setState(() => _cat = cat);
    final items = kCategoryItems[cat] ?? [];
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      backgroundColor: Colors.white,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Text(kEmoji[cat]!, style: const TextStyle(fontSize: 26)),
            const SizedBox(width: 10),
            Text(cat, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: kPrimary)),
            const Spacer(),
            IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
          ]),
          const SizedBox(height: 4),
          Text('Tap an item to auto-fill the title', style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8, runSpacing: 8,
            children: items.map((item) {
              final color = kCatColors[cat] ?? Colors.grey;
              return GestureDetector(
                onTap: () { _titleCtrl.text = item; Navigator.pop(context); },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(99),
                    border: Border.all(color: color.withValues(alpha: 0.25)),
                  ),
                  child: Text(item, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w500)),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
        ]),
      ),
    );
  }

  void _save() {
    if (_cat == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a category'), backgroundColor: Color(0xFFE8624A)),
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
      const SnackBar(content: Text('✅ Expense saved!'), backgroundColor: kPrimary),
    );
    _titleCtrl.clear(); _amountCtrl.clear(); _notesCtrl.clear();
    setState(() { _cat = null; _date = DateTime.now(); });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        title: const Text('Add Expense', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
        backgroundColor: kPrimary,
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            _card(label: 'Select Category', child: GridView.count(
              crossAxisCount: 3, shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 1.1,
              children: kCategories.map((cat) {
                final sel   = _cat == cat;
                final color = kCatColors[cat]!;
                return GestureDetector(
                  onTap: () => _pickCategory(cat),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    decoration: BoxDecoration(
                      color: sel ? color.withValues(alpha: 0.1) : Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: sel ? color : Colors.grey.shade200, width: sel ? 2 : 1),
                    ),
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text(kEmoji[cat]!, style: const TextStyle(fontSize: 26)),
                      const SizedBox(height: 6),
                      Text(cat, style: TextStyle(
                        fontSize: 12,
                        fontWeight: sel ? FontWeight.w700 : FontWeight.w500,
                        color: sel ? color : Colors.grey[600],
                      )),
                      if (sel) Icon(Icons.check_circle, size: 13, color: color),
                    ]),
                  ),
                );
              }).toList(),
            )),
            const SizedBox(height: 14),

            _card(label: 'Title *', child: TextFormField(
              controller: _titleCtrl,
              decoration: _deco('e.g. Dinner with friends'),
              validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
            )),
            const SizedBox(height: 14),

            _card(label: 'Amount (Rs) *', child: TextFormField(
              controller: _amountCtrl,
              keyboardType: TextInputType.number,
              decoration: _deco('e.g. 2200'),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Required';
                final n = double.tryParse(v.trim());
                if (n == null || n <= 0) return 'Enter a positive number';
                return null;
              },
            )),
            const SizedBox(height: 14),

            _card(label: 'Date *', child: GestureDetector(
              onTap: () async {
                final p = await showDatePicker(
                  context: context, initialDate: _date,
                  firstDate: DateTime(2020), lastDate: DateTime.now(),
                  builder: (ctx, child) => Theme(
                    data: Theme.of(ctx).copyWith(colorScheme: const ColorScheme.light(primary: kPrimary)),
                    child: child!,
                  ),
                );
                if (p != null) setState(() => _date = p);
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
            )),
            const SizedBox(height: 14),

            _card(label: 'Notes (optional)', child: TextFormField(
              controller: _notesCtrl,
              decoration: _deco('Any extra details...'),
              maxLines: 2,
            )),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimary, foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 2,
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                child: const Text('Save Expense'),
              ),
            ),
            const SizedBox(height: 20),
          ]),
        ),
      ),
    );
  }
}

class EditScreen extends StatefulWidget {
  final Expense expense;
  final Function(Expense) onUpdate;
  const EditScreen({super.key, required this.expense, required this.onUpdate});
  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final _formKey    = GlobalKey<FormState>();
  late TextEditingController _titleCtrl;
  late TextEditingController _amountCtrl;
  late TextEditingController _notesCtrl;
  late DateTime _date;
  late String?  _cat;

  @override
  void initState() {
    super.initState();
    _titleCtrl  = TextEditingController(text: widget.expense.title);
    _amountCtrl = TextEditingController(text: widget.expense.amount.toString());
    _notesCtrl  = TextEditingController(text: widget.expense.notes);
    _date = widget.expense.date;
    _cat  = widget.expense.category;
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
      const SnackBar(content: Text('✅ Updated!'), backgroundColor: kPrimary),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        title: const Text('Edit Expense', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
        backgroundColor: kPrimary,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _card(label: 'Category', child: GridView.count(
              crossAxisCount: 3, shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 1.1,
              children: kCategories.map((cat) {
                final sel   = _cat == cat;
                final color = kCatColors[cat]!;
                return GestureDetector(
                  onTap: () => setState(() => _cat = cat),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    decoration: BoxDecoration(
                      color: sel ? color.withValues(alpha: 0.1) : Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: sel ? color : Colors.grey.shade200, width: sel ? 2 : 1),
                    ),
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text(kEmoji[cat]!, style: const TextStyle(fontSize: 26)),
                      const SizedBox(height: 6),
                      Text(cat, style: TextStyle(
                        fontSize: 12,
                        fontWeight: sel ? FontWeight.w700 : FontWeight.w500,
                        color: sel ? color : Colors.grey[600],
                      )),
                    ]),
                  ),
                );
              }).toList(),
            )),
            const SizedBox(height: 14),

            _card(label: 'Title *', child: TextFormField(
              controller: _titleCtrl,
              decoration: _deco('Title'),
              validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
            )),
            const SizedBox(height: 14),

            _card(label: 'Amount (Rs) *', child: TextFormField(
              controller: _amountCtrl,
              keyboardType: TextInputType.number,
              decoration: _deco('Amount'),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Required';
                final n = double.tryParse(v.trim());
                if (n == null || n <= 0) return 'Positive number only';
                return null;
              },
            )),
            const SizedBox(height: 14),

            _card(label: 'Date', child: GestureDetector(
              onTap: () async {
                final p = await showDatePicker(
                  context: context, initialDate: _date,
                  firstDate: DateTime(2020), lastDate: DateTime.now(),
                  builder: (ctx, child) => Theme(
                    data: Theme.of(ctx).copyWith(colorScheme: const ColorScheme.light(primary: kPrimary)),
                    child: child!,
                  ),
                );
                if (p != null) setState(() => _date = p);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50, borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text(_date2(_date), style: const TextStyle(fontSize: 15)),
                  Icon(Icons.calendar_today_outlined, color: Colors.grey.shade500, size: 18),
                ]),
              ),
            )),
            const SizedBox(height: 14),

            _card(label: 'Notes (optional)', child: TextFormField(
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
                  backgroundColor: kPrimary, foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                child: const Text('Update Expense'),
              ),
            ),
            const SizedBox(height: 20),
          ]),
        ),
      ),
    );
  }
}

class SummaryScreen extends StatelessWidget {
  final List<Expense> expenses;
  const SummaryScreen({super.key, required this.expenses});

  @override
  Widget build(BuildContext context) {
    final total = expenses.fold(0.0, (s, e) => s + e.amount);
    final avg   = expenses.isEmpty ? 0.0 : total / expenses.length;

    final Map<String, double> catTotals = {};
    for (final e in expenses) {
      catTotals[e.category] = (catTotals[e.category] ?? 0) + e.amount;
    }
    final sorted = catTotals.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    final maxVal = sorted.isEmpty ? 1.0 : sorted.first.value;

    Expense? top;
    if (expenses.isNotEmpty) top = expenses.reduce((a, b) => a.amount > b.amount ? a : b);

    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        title: const Text('Summary', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
        backgroundColor: kPrimary,
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: expenses.isEmpty
          ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.bar_chart_outlined, size: 64, color: Colors.grey.shade300),
        const SizedBox(height: 12),
        Text('No data yet', style: TextStyle(color: Colors.grey.shade400, fontSize: 16, fontWeight: FontWeight.w500)),
        Text('Add some expenses first', style: TextStyle(color: Colors.grey.shade400, fontSize: 13)),
      ]))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          Row(children: [
            _metricCard('Total Spent', 'Rs ${_fmt(total)}'),
            const SizedBox(width: 10),
            _metricCard('Expenses', '${expenses.length}'),
          ]),
          const SizedBox(height: 10),
          SizedBox(width: double.infinity,
              child: _metricCard('Avg per Expense', 'Rs ${_fmt(avg)}', full: true)),

          const SizedBox(height: 20),
          const Text('Category Breakdown',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: kPrimary)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
            ),
            child: Column(children: sorted.map((entry) {
              final color  = kCatColors[entry.key] ?? Colors.grey;
              final emoji  = kEmoji[entry.key] ?? '📦';
              final pct    = entry.value / maxVal;
              final pctStr = total > 0 ? '${(entry.value / total * 100).toStringAsFixed(1)}%' : '0%';
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text('$emoji  ${entry.key}',
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1A1A2E))),
                    Text('Rs ${_fmt(entry.value)}  ·  $pctStr',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: color)),
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

          if (top != null) ...[
            const SizedBox(height: 20),
            const Text('Highest Expense',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: kPrimary)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1C3557), Color(0xFF2A4F7C)],
                  begin: Alignment.topLeft, end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(children: [
                Container(
                  width: 50, height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Center(child: Text(kEmoji[top.category] ?? '📦',
                      style: const TextStyle(fontSize: 24))),
                ),
                const SizedBox(width: 14),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(top.title,
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Colors.white)),
                  const SizedBox(height: 2),
                  Text('${top.category}  ·  ${_date(top.date)}',
                      style: const TextStyle(color: Colors.white60, fontSize: 12)),
                ])),
                Text('Rs ${_fmt(top.amount)}',
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: kAccent)),
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
        color: Colors.white, borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFFADB5BD), fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: kPrimary)),
      ]),
    );
    return full ? card : Expanded(child: card);
  }
}

Widget _card({required String label, required Widget child}) => Container(
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: Colors.white, borderRadius: BorderRadius.circular(16),
    boxShadow: [BoxShadow(color: const Color(0x0D000000), blurRadius: 10, offset: const Offset(0, 3))],
  ),
  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF6B7280))),
    const SizedBox(height: 12),
    child,
  ]),
);

InputDecoration _deco(String hint) => InputDecoration(
  hintText: hint,
  hintStyle: const TextStyle(color: Color(0xFFADB5BD), fontSize: 14),
  filled: true, fillColor: const Color(0xFFF9FAFB),
  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  border:        OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: kPrimary, width: 1.5)),
  errorBorder:   OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE8624A))),
);

String _fmt(double v) {
  final n = v.toStringAsFixed(0);
  final buf = StringBuffer();
  int count = 0;
  for (int i = n.length - 1; i >= 0; i--) {
    if (count > 0 && count % 3 == 0) buf.write(',');
    buf.write(n[i]); count++;
  }
  return buf.toString().split('').reversed.join();
}

final _months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
String _date(DateTime d)  => '${d.day} ${_months[d.month - 1]} ${d.year}';
String _date2(DateTime d) => '${d.day.toString().padLeft(2, '0')} ${_months[d.month - 1]} ${d.year}';


class PayScreen extends StatefulWidget {
  const PayScreen({super.key});
  @override
  State<PayScreen> createState() => _PayScreenState();
}

class _PayScreenState extends State<PayScreen> {
  String? _selectedMethod;
  final _amountCtrl  = TextEditingController();
  final _accountCtrl = TextEditingController();
  final _nameCtrl    = TextEditingController();
  final _formKey     = GlobalKey<FormState>();
  bool _processing   = false;

  final List<Map<String, dynamic>> _methods = [
    {
      'id':    'jazzcash',
      'name':  'JazzCash',
      'color': Color(0xFFCC0000),
      'hint':  'Enter JazzCash mobile number',
      'label': 'Mobile Number',
    },
    {
      'id':    'easypaisa',
      'name':  'Easypaisa',
      'color': Color(0xFF00A651),
      'hint':  'Enter Easypaisa mobile number',
      'label': 'Mobile Number',
    },
    {
      'id':    'bank',
      'name':  'Bank Transfer',
      'color': Color(0xFF003087),
      'hint':  'Enter IBAN (PK36SCBL...)',
      'label': 'IBAN Number',
    },
  ];

  @override
  void dispose() {
    _amountCtrl.dispose();
    _accountCtrl.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  Map<String, dynamic>? get _activeMethod =>
      _methods.firstWhere((m) => m['id'] == _selectedMethod, orElse: () => {});

  void _submitPayment() async {
    if (_selectedMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a payment method'), backgroundColor: Color(0xFFE8624A)),
      );
      return;
    }
    if (!_formKey.currentState!.validate()) return;

    setState(() => _processing = true);
    await Future.delayed(const Duration(seconds: 2)); // simulate processing
    setState(() => _processing = false);

    if (!mounted) return;
    _showSuccessDialog();
  }

  void _showSuccessDialog() {
    final method = _activeMethod!;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            width: 70, height: 70,
            decoration: BoxDecoration(
              color: const Color(0xFF12B886).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check_circle, color: Color(0xFF12B886), size: 40),
          ),
          const SizedBox(height: 16),
          const Text('Payment Sent!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: kPrimary)),
          const SizedBox(height: 8),
          Text(
            'Rs ${_amountCtrl.text} sent via ${method['name']}\nto ${_nameCtrl.text}',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFF6B7280), fontSize: 14),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _amountCtrl.clear();
                _accountCtrl.clear();
                _nameCtrl.clear();
                setState(() => _selectedMethod = null);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimary, foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Done', style: TextStyle(fontWeight: FontWeight.w700)),
            ),
          ),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        title: const Text('Send Payment', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
        backgroundColor: kPrimary,
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            // ── Select Method ──
            _card(
              label: 'Select Payment Method',
              child: Column(children: _methods.map((m) {
                final sel   = _selectedMethod == m['id'];
                final color = m['color'] as Color;
                return GestureDetector(
                  onTap: () => setState(() => _selectedMethod = m['id']),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: sel ? color.withValues(alpha: 0.06) : Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: sel ? color : Colors.grey.shade200, width: sel ? 2 : 1),
                    ),
                    child: Row(children: [
                      _payLogo(m['id'] as String, color),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(m['name'],
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: sel ? FontWeight.w700 : FontWeight.w500,
                                color: sel ? color : const Color(0xFF374151),
                              )),
                          Text(
                            m['id'] == 'bank' ? 'IBAN / Account Transfer' : 'Mobile Wallet',
                            style: const TextStyle(fontSize: 11, color: Color(0xFFADB5BD)),
                          ),
                        ]),
                      ),
                      if (sel)
                        Icon(Icons.check_circle, color: color, size: 22)
                      else
                        Icon(Icons.radio_button_unchecked, color: Colors.grey.shade400, size: 22),
                    ]),
                  ),
                );
              }).toList()),
            ),
            const SizedBox(height: 14),

            // ── Amount ──
            _card(
              label: 'Amount (Rs) *',
              child: TextFormField(
                controller: _amountCtrl,
                keyboardType: TextInputType.number,
                decoration: _deco('Enter amount e.g. 500'),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Required';
                  final n = double.tryParse(v.trim());
                  if (n == null || n <= 0) return 'Enter a valid positive amount';
                  return null;
                },
              ),
            ),
            const SizedBox(height: 14),

            // ── Recipient Name ──
            _card(
              label: 'Recipient Name *',
              child: TextFormField(
                controller: _nameCtrl,
                decoration: _deco('e.g. Ali Hassan'),
                validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
              ),
            ),
            const SizedBox(height: 14),


            if (_selectedMethod != null) ...[
              _card(
                label: '${_activeMethod!['label']} *',
                child: TextFormField(
                  controller: _accountCtrl,
                  keyboardType: _selectedMethod == 'bank'
                      ? TextInputType.text
                      : TextInputType.phone,
                  decoration: _deco(_activeMethod!['hint']),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Required';
                    if (_selectedMethod != 'bank' && v.trim().length < 10)
                      return 'Enter a valid mobile number';
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 14),
            ],


            if (_selectedMethod != null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1C3557), Color(0xFF2A4F7C)],
                    begin: Alignment.topLeft, end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Payment Summary',
                      style: TextStyle(color: Colors.white60, fontSize: 12, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 12),
                  _summaryRow('Method',    _activeMethod!['name']),
                  _summaryRow('Amount',    _amountCtrl.text.isEmpty  ? '—' : 'Rs ${_amountCtrl.text}'),
                  _summaryRow('Recipient', _nameCtrl.text.isEmpty    ? '—' : _nameCtrl.text),
                  _summaryRow('Account',   _accountCtrl.text.isEmpty ? '—' : _accountCtrl.text),
                ]),
              ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _processing ? null : _submitPayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kAccent,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey.shade300,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 2,
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                child: _processing
                    ? const SizedBox(
                  width: 22, height: 22,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                )
                    : const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(Icons.send_rounded, size: 20),
                  SizedBox(width: 8),
                  Text('Send Payment'),
                ]),
              ),
            ),

            const SizedBox(height: 12),
            Center(
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.lock_outline, size: 14, color: Colors.grey.shade400),
                const SizedBox(width: 4),
                Text('Secured & Encrypted', style: TextStyle(color: Colors.grey.shade400, fontSize: 12)),
              ]),
            ),
            const SizedBox(height: 20),
          ]),
        ),
      ),
    );
  }

  Widget _summaryRow(String label, String value) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: const TextStyle(color: Colors.white60, fontSize: 13)),
      Text(value, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
    ]),
  );

  // Branded logo widget for each payment method
  Widget _payLogo(String id, Color color) {
    if (id == 'jazzcash') {
      return Container(
        width: 54, height: 36,
        decoration: BoxDecoration(
          color: const Color(0xFFCC0000),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Text(
            'Jazz\nCash',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 9,
              fontWeight: FontWeight.w900,
              height: 1.1,
              letterSpacing: 0.5,
            ),
          ),
        ),
      );
    } else if (id == 'easypaisa') {
      return Container(
        width: 54, height: 36,
        decoration: BoxDecoration(
          color: const Color(0xFF00A651),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Text(
            'easy\npaisa',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 9,
              fontWeight: FontWeight.w900,
              height: 1.1,
              letterSpacing: 0.3,
            ),
          ),
        ),
      );
    } else {
      // Bank Transfer - generic bank icon styled
      return Container(
        width: 54, height: 36,
        decoration: BoxDecoration(
          color: const Color(0xFF003087),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.account_balance, color: Colors.white, size: 16),
              Text(
                'BANK',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 7,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}