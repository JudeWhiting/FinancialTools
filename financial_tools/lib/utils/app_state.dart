import 'package:flutter/material.dart';

class MyAppState extends ChangeNotifier {

  var income = 0.0;
double pensionSacrifice = 0;
  void updateIncome(double userInputIncome, double userInputPension) {
    income = userInputIncome;
    pensionSacrifice = userInputPension;
    notifyListeners();
  }

  bool studentLoanRepayments = false;
  void updateStudentLoanRepayments() {
    studentLoanRepayments = !studentLoanRepayments;
    print(studentLoanRepayments);
    notifyListeners();
  }

  void updatePensionSacrifice(double userInputPension) {
    pensionSacrifice = userInputPension;
    notifyListeners;
  }
}