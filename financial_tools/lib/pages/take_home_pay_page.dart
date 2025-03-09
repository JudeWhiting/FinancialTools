import 'package:flutter_application/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application/utils/global_functions.dart';
import 'package:flutter_application/utils/app_state.dart';





class TakeHomePayPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    final TextEditingController payController = TextEditingController();
    final TextEditingController pensionController = TextEditingController();

    double calculateTaxDeductions (double pay) {
      if (pay > Variables().higherRateThreshold) {
        return Variables().additionalRateMultiplier * (pay - Variables().higherRateThreshold) + calculateTaxDeductions(Variables().higherRateThreshold);
      }
      else if (pay > Variables().basicRateThreshold) {
        return Variables().higherRateMultiplier * (pay - Variables().basicRateThreshold) + calculateTaxDeductions(Variables().basicRateThreshold);
      }
      else if (pay > Variables().personalAllowanceThreshold) {
        return Variables().basicRateMultiplier * (pay - Variables().personalAllowanceThreshold);
      }
      else {
        return 0;
      }
    }

    double calculateNiDeductions(double pay) {
      
      if (pay > Variables().niStandardThreshold) {
        return Variables().niExtraMultiplier * (pay - Variables().niStandardThreshold) + calculateNiDeductions(Variables().niStandardThreshold);
      }
      else if (pay > Variables().niNoPaymentThreshold) {
        return Variables().niStandardMultiplier * (pay - Variables().niNoPaymentThreshold);
      }
      else {
        return 0;
      }
    }

    double calculateStudentLoanDeductions (double pay) {

      if (pay > Variables().studentLoanThreshold) {
        return Variables().studentLoanMultiplier * (pay - Variables().studentLoanThreshold);
      }
      else {
        return 0;
      }

    }
    
    double pensionDeductions = appState.income * 0.01 * appState.pensionSacrifice;
    double studentLoanDeductions = calculateStudentLoanDeductions(appState.income);
    studentLoanDeductions = appState.studentLoanRepayments ? studentLoanDeductions : 0;
    double niDeductions = calculateNiDeductions(appState.income);
    double taxDeductions = calculateTaxDeductions(appState.income - pensionDeductions);
    

    double takeHomePay = appState.income - studentLoanDeductions - niDeductions - taxDeductions - pensionDeductions;


    return Column(
      children: <Widget>[
        SizedBox(height: 20),
         Row(
           children: [
             Text('    Gross Income:  £  ', style: TextStyle(fontWeight: FontWeight.bold)),
             SizedBox(width: 100, height: 40, child: TextField(controller: payController,
             decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
             ),)),
             SizedBox(width: 20,),

           ],
         ),
         SizedBox(height: 20),
         Row(
          children: [
            Text('    Pension Deduction:  %  ', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(width: 100, height: 40, child: TextField(controller: pensionController,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
             ),)),
          ],
         ),
         ElevatedButton(onPressed: () {appState.updateIncome(double.parse(payController.text), double.parse(pensionController.text));}, child: Text('Go!')),
         SizedBox(height: 20,),
         ElevatedButton(onPressed: () {appState.updateStudentLoanRepayments();}, child: Text('Toggle student loan repayments (Plan 2)')),
         SizedBox(height: 20),
         Table(
          border: TableBorder.all(color: Colors.black, width: 2),
          columnWidths: {
            0: FixedColumnWidth(100),
            1: FixedColumnWidth(100),
            2: FixedColumnWidth(100),
            3: FixedColumnWidth(100),
          },
          children: [
            TableRow(
              children: [
                TableCell(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('', style: TextStyle(fontWeight: FontWeight.bold)),
                )),
                TableCell(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Yearly', style: TextStyle(fontWeight: FontWeight.bold)),
                )),
                TableCell(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Monthly', style: TextStyle(fontWeight: FontWeight.bold)),
                )),
                TableCell(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Weekly', style: TextStyle(fontWeight: FontWeight.bold)),
                )),
              ],
            ),
            TableRow(
              children: [
                TableCell(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Gross Income', style: TextStyle(fontWeight: FontWeight.bold)),
                )),
                TableCell(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(formatNumber(appState.income), style: TextStyle(fontWeight: FontWeight.bold)),
                )),
                TableCell(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(formatNumber(appState.income / 12), style: TextStyle(fontWeight: FontWeight.bold)),
                )),
                TableCell(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(formatNumber(appState.income / 52), style: TextStyle(fontWeight: FontWeight.bold)),
                )),
              ],
            ),
            TableRow(
              children: [
                TableCell(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Pension (${appState.pensionSacrifice}%)', style: TextStyle(fontWeight: FontWeight.bold)),
                )),
                TableCell(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(formatNumber(pensionDeductions)),
                )),
                TableCell(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(formatNumber(pensionDeductions / 12)),
                )),
                TableCell(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(formatNumber(pensionDeductions / 52)),
                )),
              ],
            ),
            TableRow(
              children: [
                TableCell(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Tax', style: TextStyle(fontWeight: FontWeight.bold)),
                )),
                TableCell(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(formatNumber(taxDeductions)),
                )),
                TableCell(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(formatNumber(taxDeductions / 12)),
                )),
                TableCell(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(formatNumber(taxDeductions / 52)),
                )),
              ],
            ),
            TableRow(
              children: [
                TableCell(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('National Insurance', style: TextStyle(fontWeight: FontWeight.bold)),
                )),
                TableCell(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(formatNumber(niDeductions)),
                )),
                TableCell(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(formatNumber(niDeductions / 12)),
                )),
                TableCell(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(formatNumber(niDeductions / 52)),
                )),
              ],
            ),
            TableRow(
              children: [
                TableCell(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Student Loan', style: TextStyle(fontWeight: FontWeight.bold)),
                )),
                TableCell(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(formatNumber(studentLoanDeductions)),
                )),
                TableCell(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(formatNumber(studentLoanDeductions / 12)),
                )),
                TableCell(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(formatNumber(studentLoanDeductions / 52)),
                )),
              ],
            ),
            TableRow(
              children: [
                TableCell(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Take Home', style: TextStyle(fontWeight: FontWeight.bold)),
                )),
                TableCell(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(formatNumber(takeHomePay), style: TextStyle(fontWeight: FontWeight.bold)),
                )),
                TableCell(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(formatNumber(takeHomePay / 12), style: TextStyle(fontWeight: FontWeight.bold)),
                )),
                TableCell(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(formatNumber(takeHomePay / 52), style: TextStyle(fontWeight: FontWeight.bold)),
                )),
              ],
            ),
          ],
         ),
      ]
    );
  }
}