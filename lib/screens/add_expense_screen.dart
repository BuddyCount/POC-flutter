import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/group_provider.dart';
import '../models/expense.dart';
import '../models/group.dart';
import '../models/person.dart';
import 'package:intl/intl.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  String _selectedCurrency = 'EUR';
  String? _selectedPayer;
  final Set<String> _selectedPeople = {};
  DateTime _selectedDate = DateTime.now();

  final List<String> _currencies = ['EUR', 'USD', 'CHF', 'GBP'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final groupProvider = Provider.of<GroupProvider>(context, listen: false);
      if (groupProvider.currentGroup != null) {
        _selectedPayer = groupProvider.currentGroup!.members.first.id;
        for (var person in groupProvider.currentGroup!.members) {
          _selectedPeople.add(person.id);
        }
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Expense'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Consumer<GroupProvider>(
        builder: (context, groupProvider, child) {
          final currentGroup = groupProvider.currentGroup;
          
          if (currentGroup == null) {
            return const Center(
              child: Text('No group selected'),
            );
          }

          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                _buildNameField(),
                const SizedBox(height: 16),
                _buildAmountField(),
                const SizedBox(height: 16),
                _buildCurrencyDropdown(),
                const SizedBox(height: 16),
                _buildPayerDropdown(currentGroup),
                const SizedBox(height: 16),
                _buildDatePicker(),
                const SizedBox(height: 16),
                _buildSplitBetweenSection(currentGroup),
                const SizedBox(height: 32),
                _buildSubmitButton(groupProvider),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: const InputDecoration(
        labelText: 'Expense Name',
        hintText: 'e.g., Dinner, Hotel, Transportation',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.receipt),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter an expense name';
        }
        return null;
      },
    );
  }

  Widget _buildAmountField() {
    return TextFormField(
      controller: _amountController,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        labelText: 'Amount',
        hintText: '0.00',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.attach_money),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter an amount';
        }
        final amount = double.tryParse(value);
        if (amount == null || amount <= 0) {
          return 'Please enter a valid amount';
        }
        return null;
      },
    );
  }

  Widget _buildCurrencyDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedCurrency,
      decoration: const InputDecoration(
        labelText: 'Currency',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.currency_exchange),
      ),
      items: _currencies.map((currency) {
        return DropdownMenuItem(
          value: currency,
          child: Text(currency),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedCurrency = value!;
        });
      },
    );
  }

  Widget _buildPayerDropdown(Group currentGroup) {
    return DropdownButtonFormField<String>(
      value: _selectedPayer,
      decoration: const InputDecoration(
        labelText: 'Paid by',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.person),
      ),
      items: currentGroup.members.map((person) {
        return DropdownMenuItem(
          value: person.id,
          child: Text(person.name),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedPayer = value;
        });
      },
      validator: (value) {
        if (value == null) {
          return 'Please select who paid';
        }
        return null;
      },
    );
  }

  Widget _buildDatePicker() {
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: _selectedDate,
          firstDate: DateTime.now().subtract(const Duration(days: 365)),
          lastDate: DateTime.now().add(const Duration(days: 30)),
        );
        if (date != null) {
          setState(() {
            _selectedDate = date;
          });
        }
      },
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Date',
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.calendar_today),
        ),
        child: Text(
          DateFormat('MMM dd, yyyy').format(_selectedDate),
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildSplitBetweenSection(Group currentGroup) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Split between:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        ...currentGroup.members.map((person) => CheckboxListTile(
          title: Text(person.name),
          value: _selectedPeople.contains(person.id),
          onChanged: (bool? value) {
            setState(() {
              if (value == true) {
                _selectedPeople.add(person.id);
              } else {
                _selectedPeople.remove(person.id);
              }
            });
          },
          controlAffinity: ListTileControlAffinity.leading,
        )),
        if (_selectedPeople.isEmpty)
          const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text(
              'Please select at least one person',
              style: TextStyle(
                color: Colors.red,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSubmitButton(GroupProvider groupProvider) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _selectedPeople.isNotEmpty ? () => _submitExpense(groupProvider) : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
        ),
        child: const Text(
          'Add Expense',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }

  void _submitExpense(GroupProvider groupProvider) {
    if (!_formKey.currentState!.validate() || _selectedPeople.isEmpty) {
      return;
    }

    final expense = Expense(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      amount: double.parse(_amountController.text),
      currency: _selectedCurrency,
      paidBy: _selectedPayer!,
      date: _selectedDate,
      splitBetween: _selectedPeople.toList(),
    );

    groupProvider.addExpense(expense);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${expense.name} added successfully!'),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context);
  }
} 