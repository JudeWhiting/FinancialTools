import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';

class Variables {
  final double personalAllowanceThreshold = 12570;
  final double basicRateThreshold = 50270;
  final double basicRateMultiplier = 0.2;
  final double higherRateThreshold = 125140;
  final double higherRateMultiplier = 0.4;
  final double additionalRateMultiplier = 0.45;

  final double niNoPaymentThreshold = 242 * 52;
  final double niStandardThreshold = 967 * 52;
  final double niStandardMultiplier = 0.08;
  final double niExtraMultiplier = 0.02;

  final double studentLoanThreshold = 27295;
  final double studentLoanMultiplier = 0.09;
  

}


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 149, 160, 207)),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

String formatNumber (double pay) {
      String roundedPay = pay.toStringAsFixed(2);
      int count = 0;
      for (int i = 3; i < roundedPay.length; i++) {
        if (count == 3) {
          roundedPay = '${roundedPay.substring(0, roundedPay.length - i)},${roundedPay.substring(roundedPay.length - i)}';
          count = 0;
        }
        else {
          count += 1;
        }
      }
      String output = '£$roundedPay';

      return output;
    }

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

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {

    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
      case 1:
        page = TakeHomePayPage();
      case 2:
        page = PensionPage();
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: Row(
            children: [
              SafeArea(
                child: NavigationRail(
                  extended: constraints.maxWidth >= 600,
                  destinations: [
                    NavigationRailDestination(
                      icon: Icon(Icons.home),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.favorite),
                      label: Text('Take-home Pay'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.favorite),
                      label: Text('Pension')
                      ),
                  ],
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (value) {
                    setState(() {
                      selectedIndex = value;
                    });
                  },
                ),
              ),
              Expanded(
                child: Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: page,
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(children: [Row(children: [SizedBox(child: Text('A collection of tools to help manage finances. WIP.\nLast updated: 4/3/25'))])]);
  }
}

class PensionPage extends StatefulWidget {
  @override
  _PensionPageState createState() => _PensionPageState();
}


class _PensionPageState extends State<PensionPage> {

  bool _isChecked = false;
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

    

    double calculatePensionSavings(double paymentMonthly, int monthsUntilRetirement, double interestRateMonthly) {
      if (monthsUntilRetirement > 0) {
        return paymentMonthly * pow(interestRateMonthly, paymentMonthly) + calculatePensionSavings(paymentMonthly, monthsUntilRetirement - 1, interestRateMonthly);
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
          children: [
            Checkbox(value: _isChecked, onChanged: (bool? newValue) {
              setState(() {
                _isChecked = newValue!;
              });
            })
          ],
        ),
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
        Row(children: [
          ElevatedButton(onPressed: () {
            setState(() {
              totalPaymentYearly = (double.parse(payController.text) * 0.01 * double.parse(personalPercentageController.text)) + (double.parse(payController.text) * 0.01 * double.parse(companyPercentageController.text)) + (double.parse(extraAmountMonthlyController.text) * 12);
              yearsUntilRetirement = int.parse(yearsUntilRetirementController.text);
              interest = double.parse(interestController.text);
            });
          }, child: Text('Go!')),
          Text(formatNumber(totalPaymentYearly)),
          Text('            '),
          Text(formatNumber(pensionSavings)),
        ],)
      ]
    );
  }
}
























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