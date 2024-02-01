import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:flutter/material.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
        amount: 33,
        date: DateTime.now(),
        title: "title1",
        category: Category.food),
    Expense(
        amount: 33,
        date: DateTime.now(),
        title: "title2",
        category: Category.food),
    Expense(
        amount: 33,
        date: DateTime.now(),
        title: "title3",
        category: Category.food),
    Expense(
        amount: 33,
        date: DateTime.now(),
        title: "title4",
        category: Category.food)
  ];
  final Widget mainContent = const Center(
    child: Text(
      "There is no text. try adding some",
      textAlign: TextAlign.center,
    ),
  );

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
        useSafeArea: true,
        isScrollControlled: true,
        context: context,
        builder: (ctx) {
          return NewExpenses(
            onAddExpense: (expense) {
              _addExpense(expense);
            },
          );
        });
  }

  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(
      () {
        _registeredExpenses.remove(expense);
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Expense ${expense.title} removed",
                textAlign: TextAlign.center),
            duration: const Duration(seconds: 1),
            action: SnackBarAction(
              label: "undo",
              onPressed: (() {
                setState(() {
                  _registeredExpenses.insert(expenseIndex, expense);
                });
              }),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Row(
            children: [
              Text(
                "Flutter ExpenseTracker",
              ),
            ],
          ),
          actions: [
            IconButton(
              onPressed: _openAddExpenseOverlay,
              icon: const Icon(
                Icons.add,
              ),
            ),
          ],
        ),
        body: MediaQuery.of(context).size.width < 600
            ? Column(
                children: [
                  Chart(
                    expenses: _registeredExpenses,
                  ),
                  Expanded(
                    child: _registeredExpenses.isEmpty
                        ? mainContent
                        : ExpensesList(
                            expenses: _registeredExpenses,
                            onRemoveExpense: _removeExpense,
                          ),
                  ),
                ],
              )
            : Row(
                children: [
                  Expanded(
                    child: Chart(
                      expenses: _registeredExpenses,
                    ),
                  ),
                  Expanded(
                    child: _registeredExpenses.isEmpty
                        ? mainContent
                        : ExpensesList(
                            expenses: _registeredExpenses,
                            onRemoveExpense: _removeExpense,
                          ),
                  ),
                ],
              ));
  }
}
