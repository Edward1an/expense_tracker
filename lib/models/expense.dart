import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

enum Category {
  work,
  travel,
  cinema,
  food,
}

const categoryIcons = {
  Category.food: Icons.local_pizza,
  Category.travel: Icons.flight_takeoff,
  Category.cinema: Icons.movie,
  Category.work: Icons.work,
};

class Expense {
  Expense(
      {required this.amount,
      required this.date,
      required this.title,
      required this.category})
      : id = uuid.v4();
  final Category category;
  final String id;
  final String title;
  final DateTime date;
  final double amount;
  String get formattedDate {
    return DateFormat.yMMMd().format(date);
  }
}

class ExpenseBucket {
  final Category category;
  final List<Expense> expenses;

  ExpenseBucket.forCategory(List<Expense> allExpenses, this.category)
      : expenses = allExpenses
            .where((element) => element.category == category)
            .toList();

  double get totalExpenses {
    double sum = 0;
    for (var e in expenses) {
      sum += e.amount;
    }
    return sum;
  }

  ExpenseBucket({required this.category, required this.expenses});
}
