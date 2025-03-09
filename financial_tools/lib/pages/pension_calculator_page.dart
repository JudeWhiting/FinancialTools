import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_application/utils/global_functions.dart';

class PensionPage extends StatefulWidget {
  @override
  _PensionPageState createState() => _PensionPageState();
}


class _PensionPageState extends State<PensionPage> {

  double totalPaymentYearly = 0.0;
  int yearsUntilRetirement = 0;
  double interest = 0;
  
  @override
  Widget build(BuildContext context) {

    final TextEditingController payController = TextEditingController();
    final TextEditingController personalPercentageController = TextEditingController();
    final TextEditingController companyPercentageController = TextEditingController();
    final TextEditingController extraAmountMonthlyController = TextEditingController();
    final TextEditingController yearsUntilRetirementController = TextEditingController();
    final TextEditingController interestController = TextEditingController();
    final TextEditingController currentSavingsController = TextEditingController();

    

    double calculatePensionSavings(double paymentMonthly, int monthsUntilRetirement, double interestRateMonthly) {
      if (monthsUntilRetirement > 0) {
        return paymentMonthly * pow(interestRateMonthly, monthsUntilRetirement) + calculatePensionSavings(paymentMonthly, monthsUntilRetirement - 1, interestRateMonthly);
      }
      else {
        return 0.0;
      }




    }
    
    double pensionSavings = calculatePensionSavings(totalPaymentYearly / 12, yearsUntilRetirement * 12, 1 + (interest * 0.01)/12);
    print(1 + (interest * 0.01)/12); 
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Text('    Gross Income:  £  ', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(width: 100, height: 40, child: TextField(controller: payController,
            decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            ),)),
          ]
        ),
        SizedBox(height: 20),
        Row(
          children: <Widget>[
            Text('    Pension Deduction:  %  ', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(width: 100, height: 40, child: TextField(controller: personalPercentageController,
            decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            ),)),
          ]
        ),
        SizedBox(height: 20),
        Row(
          children: <Widget>[
            Text('    Company Pension Payment:  %  ', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(width: 100, height: 40, child: TextField(controller: companyPercentageController,
            decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            ),)),
          ]
        ),
        SizedBox(height: 20),
        Row(
          children: <Widget>[
            Text('    Extra Contribution (Monthly):  £  ', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(width: 100, height: 40, child: TextField(controller: extraAmountMonthlyController,
            decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            ),)),
          ]
        ),
        SizedBox(height: 20),
        Row(
          children: <Widget>[
            Text('    Years Until Retirement:  ', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(width: 100, height: 40, child: TextField(controller: yearsUntilRetirementController,
            decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            ),)),
          ]
        ),
        SizedBox(height: 20),
        Row(
          children: <Widget>[
            Text('    Average Yearly Interest:  %  ', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(width: 100, height: 40, child: TextField(controller: interestController,
            decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            ),)),
          ]
        ),
        SizedBox(height: 20),
        Row(
          children: <Widget>[
            Text('    Current Savings:  £  ', style: TextStyle(fontWeight: FontWeight.bold),),
            SizedBox(width: 100, height: 40, child: TextField(controller: currentSavingsController,
            decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            ),)),
          ]
        ),
        SizedBox(height: 20),
        Row(children: [
          ElevatedButton(onPressed: () {
            setState(() {
              totalPaymentYearly = (double.parse(payController.text) * 0.01 * double.parse(personalPercentageController.text)) + (double.parse(payController.text) * 0.01 * double.parse(companyPercentageController.text)) + (double.parse(extraAmountMonthlyController.text) * 12);
              yearsUntilRetirement = int.parse(yearsUntilRetirementController.text);
              interest = double.parse(interestController.text);
            });
          }, child: Text('Go!')),
        ],),
        Text('Future Investment Value:  ', style: TextStyle(fontWeight: FontWeight.bold),),
        Text(formatNumber(pensionSavings)),
      ]
    );
  }
}