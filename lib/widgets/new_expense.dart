import 'dart:io';

import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewExpenses extends StatefulWidget {
  const NewExpenses({super.key, required this.onAddExpense});

  final void Function(Expense) onAddExpense;

  @override
  State<NewExpenses> createState() => _NewExpensesState();
}

class _NewExpensesState extends State<NewExpenses> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _chosedDate;
  Category _selectedCategory = Category.cinema;

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    DateTime? selectedDate = await showDatePicker(
      initialDate: _chosedDate,
      context: context,
      firstDate: firstDate,
      lastDate: now,
    );
    setState(() {
      _chosedDate = selectedDate;
    });
  }

  void _submitExpenses() {
    final amountCheck = double.tryParse(_amountController.text);
    final amountIsInvalid = amountCheck == null || amountCheck <= 0;
    if (_titleController.text.trim().isEmpty ||
        amountIsInvalid ||
        _chosedDate == null) {
      showCupertinoDialog(
          context: context,
          builder: (ctx) {
            return CupertinoAlertDialog(
              title: Text(Platform.isIOS ? "IOS" : "Android"),
              content: const Text(
                  "Please make sure you filled out all the required fields"),
              actions: [
                CupertinoButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: const Text("OK"),
                ),
              ],
            );
          });
    } else {
      widget.onAddExpense(
        Expense(
            amount: double.parse(_amountController.text),
            date: _chosedDate!,
            title: _titleController.text,
            category: _selectedCategory),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, constraints) {
      return Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: Column(
            children: [
              if (constraints.maxWidth < 600)
                Column(
                  children: [
                    TextField(
                      controller: _titleController,
                      maxLength: 50,
                      decoration: const InputDecoration(
                        label: Text("Title"),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: TextField(
                            controller: _amountController,
                            maxLength: 10,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              label: Text("Amount"),
                              prefixText: '\$ ',
                            ),
                          ),
                        ),
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                  _chosedDate != null
                                      ? DateFormat.yMMMd().format(_chosedDate!)
                                      : "No selected date",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(fontSize: 12)),
                              const SizedBox(
                                width: 10,
                              ),
                              IconButton(
                                onPressed: _presentDatePicker,
                                icon: const Icon(
                                  Icons.calendar_month,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: [
                        DropdownButton(
                          value: _selectedCategory,
                          items: Category.values
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(
                                    e.name.toUpperCase(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(fontSize: 12),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              if (value == null) {
                                return;
                              }
                              _selectedCategory = value;
                            });
                          },
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Close"),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        ElevatedButton(
                          onPressed: _submitExpenses,
                          child: const Text("submit"),
                        ),
                      ],
                    )
                  ],
                )
              else
                SizedBox(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _titleController,
                                  maxLength: 50,
                                  decoration: const InputDecoration(
                                    label: Text("Title"),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextField(
                                  maxLength: 10,
                                  controller: _amountController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    label: Text("Amount"),
                                    prefixText: '\$ ',
                                  ),
                                ),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              DropdownButton(
                                value: _selectedCategory,
                                items: Category.values
                                    .map(
                                      (e) => DropdownMenuItem(
                                        value: e,
                                        child: Text(
                                          e.name.toUpperCase(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge!
                                              .copyWith(fontSize: 12),
                                        ),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) {
                                  setState(
                                    () {
                                      if (value == null) {
                                        return;
                                      }
                                      _selectedCategory = value;
                                    },
                                  );
                                },
                              ),
                              Row(
                                children: [
                                  Text(
                                      _chosedDate != null
                                          ? DateFormat.yMMMd()
                                              .format(_chosedDate!)
                                          : "No selected date",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(fontSize: 12)),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  IconButton(
                                    onPressed: _presentDatePicker,
                                    icon: const Icon(
                                      Icons.calendar_month,
                                    ),
                                  ),
                                ],
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("Close"),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              ElevatedButton(
                                onPressed: _submitExpenses,
                                child: const Text("submit"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ));
    });
  }
}
