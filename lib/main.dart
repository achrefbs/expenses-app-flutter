import 'package:flutter/material.dart';
import './widgets/chart.dart';
import './widgets/transaction_list.dart';
import './widgets/new_transaction.dart';
import './models/transaction.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      theme: ThemeData(
          primarySwatch: Colors.green,
          //accentColor: Colors.amber,
          fontFamily: 'Quicksand',
          textTheme: ThemeData.light().textTheme.copyWith(
                headline6: TextStyle(
                  color: Colors.green,
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                button: TextStyle(color: Colors.white),
              ),
          appBarTheme: AppBarTheme(
            textTheme: ThemeData.light().textTheme.copyWith(
                  headline6: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
          )),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Transaction> _userTransaction = [
    /*Transaction(
      id: 't1',
      title: 'tr1',
      amount: 69,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't2',
      title: 'tr2',
      amount: 69,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't3',
      title: 'tr3',
      amount: 69,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't4',
      title: 'tr4',
      amount: 69,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't5',
      title: 'tr5',
      amount: 69,
      date: DateTime.now(),
    ),*/
  ];
  List<Transaction> get _recentTransactions {
    return _userTransaction.where((elem) {
      return elem.date.isAfter(DateTime.now().subtract(
        Duration(days: 7),
      ));
    }).toList();
  }

  void _addNewTransaction(String title, double amount, DateTime date) {
    final newTx = Transaction(
      title: title,
      amount: amount,
      date: date,
      id: DateTime.now().toString(),
    );

    setState(() {
      _userTransaction.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return NewTransaction(_addNewTransaction);
        });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransaction.removeWhere((tx) {
        return tx.id == id;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Text(
        'Personal Expenses',
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => _startAddNewTransaction(context),
        )
      ],
    );
    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              height: (MediaQuery.of(context).size.height -
                      appBar.preferredSize.height -
                      MediaQuery.of(context).padding.top) *
                  0.3,
              child: Chart(_recentTransactions),
            ),
            Container(
              height: (MediaQuery.of(context).size.height -
                      appBar.preferredSize.height -
                      MediaQuery.of(context).padding.top) *
                  0.7,
              child: TransactionList(_userTransaction, _deleteTransaction),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _startAddNewTransaction(context),
      ),
    );
  }
}
