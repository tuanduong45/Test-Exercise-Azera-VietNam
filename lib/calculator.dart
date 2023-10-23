
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:shared_preferences/shared_preferences.dart';


class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}
class Calculation{
  String inputHistory ;
  String outputHistory ;
  static List<Calculation> historyList = [];

  Calculation({required this.inputHistory, required this.outputHistory});
   Calculation.fromJson(Map<String, dynamic> json) 
    
      : inputHistory = json['inputHistory'],
      outputHistory =  json['outputHistory'];
  
  
  Map<String, dynamic> toJson() => {
      'inputHistory': inputHistory,
      'outputHistory': outputHistory,
  };
}

class _CalculatorScreenState extends State<CalculatorScreen> {
   String input ='';
   String output ='';
   List<Calculation> _calculationHistory = [];
   Map<String,String> lastRunHistory ={};

  

  @override
  void initState() {
    super.initState();
    loadHistory().then((history) {
      setState(() {
        lastRunHistory = history;
      });

    });
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple Calculator'),
        actions: [
          IconButton(
              onPressed: onHistoryPressed,
              icon: const Icon(Icons.history_rounded)),
        ],
      ),
      body: Column(
        children: [
          /// Input Display
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              alignment: Alignment.bottomRight,
              child: Text(
                input,
                style: const TextStyle(fontSize: 24.0),
              ),
            ),
          ),

          /// Output Display
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              alignment: Alignment.bottomRight,
              child: Text(
                output,
                style: const TextStyle(
                    fontSize: 36.0, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          /// Keyboard Layout
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              buildButton("("),
              buildButton(")"),
              buildButton("%"),
              buildButton("C"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              buildButton("7"),
              buildButton("8"),
              buildButton("9"),
              buildButton("/"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              buildButton("4"),
              buildButton("5"),
              buildButton("6"),
              buildButton("*"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              buildButton("1"),
              buildButton("2"),
              buildButton("3"),
              buildButton("-"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              buildButton("0"),
              buildButton("."),
              buildButton("="),
              buildButton("+"),
            ],
          ),
          Expanded(
            child: Container(),
          ),
        ],
      ),
    );
  }

  Widget buildButton(String buttonText) {
    return Expanded(
      child: ElevatedButton(
      onPressed: () {
        onButtonPressed(buttonText);
      },
      child: SizedBox(
        width: 40,
        height: 40,
        child: Center(
          child: Text(
            buttonText,
            style: const TextStyle(fontSize: 20.0),
          ),
        ),
      ),
      ),
    );

  }


  // Define a function to handle button clicks
  void onButtonPressed(String value) {
    setState(() {
      if(value == 'C'){
        input ='';
        output ='';
      }else if (value =='='){
        calculate();
      }
      else {
        String newInput = input + value ; 
        if(canAppendValue(newInput, value)){
          input = newInput ;    
        }else{
          print('Invalid Input');
        }
      }
    });
  }
  // TODO: Return calculation result given the input operations
// Example:
//  Input: 5.6×-9.21+12÷-0.521
//  Output: -75.576

  void calculate() {
    try{
    Parser p = Parser();
    Expression exp = p.parse(input);
    ContextModel contextModel = ContextModel();
    double eval = exp.evaluate(EvaluationType.REAL, contextModel);
    if(eval.isNaN){
      output='Invalid input';
    }else{
      output = eval.toString();
      _calculationHistory.add(Calculation(inputHistory: input, outputHistory: output));
    }
    }catch(e){
        output = 'Error';
      };
     }
    
  // TODO: Show Popup dialog displaying calculation history so that when user
  // clicks a line, replace current input and output with input and output from
  // that line
  // See Google Calculator for reference: https://i.imgur.com/iwKp1JS.gif
  void onHistoryPressed() {
   showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Calculation History'),
          content: Container(
            width: 200,
            height : 400,
            child: ListView.builder(
              itemCount: _calculationHistory.length,
              itemBuilder: (BuildContext context, int index) {
                Calculation calculation = _calculationHistory[index];
                return ListTile(
                  title: Text(calculation.inputHistory),
                  subtitle: Text(calculation.outputHistory),
                  onTap: () {
                    setState(() {
                      input = calculation.inputHistory;
                      output = calculation.outputHistory;
                    });
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
  

  // TODO: Load last run history from file
  // Note: Everytime user pressed "=" to get math result, calculation input and
  // output should be persisted to disk for retrieving later.
  //
  // Reference: https://docs.flutter.dev/cookbook/persistence/key-value
  Future<Map<String,String>> loadHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String , String> history = {};
    Map<String , dynamic> jsondata = prefs.getString("last run history ")!=null 
    ? json.decode(prefs.getString("last run history")!):null;
    if(jsondata!=null){
      jsondata.forEach((key, value) {
        history[key] = value.toString();
      });
    }

  return history;
  }
  Future<void> persistLastRunHistory(Map<String,String> history ) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString("last run history", json.encode(history));
  }
  
     
     

// TODO: Return true when next value or operation can be added to current input
// Example:
//  ----------------
//  currentInput: 5
//  nextValue: ÷
//  Output: true
//  ----------------
//  currentInput: 5÷
//  nextValue: /
//  Output: false (Invalid operation: 5÷/)
bool canAppendValue(String currentInput, String nextValue) {
  RegExp validInput = RegExp(r'^[-+*/()%.0-9]+$');
  String testExpression = currentInput + nextValue;
  return validInput.hasMatch(testExpression);
}
}


