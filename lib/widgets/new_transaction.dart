import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addNewTx;

  const NewTransaction({required this.addNewTx, super.key});

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();

  final _amountController = TextEditingController();

  DateTime? _selectedDate;

  void _submitData() {
    if (_amountController.text.isEmpty) {
      return;
    }

    final submittedTitle = _titleController.text;
    final submittedAmount = double.parse(_amountController.text);

    if (submittedTitle.isEmpty ||
        submittedAmount <= 0 ||
        _selectedDate == null) {
      return;
    }

    widget.addNewTx(
      submittedTitle,
      submittedAmount,
      _selectedDate,
    );

    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
              top: 10,
              left: 10,
              right: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Title',
                ),
                controller: _titleController,
                onSubmitted: (_) => _submitData(),
                // onChanged: (value) => titleInput = value,
              ),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Amount',
                ),
                controller: _amountController,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => _submitData(),
              ),
              SizedBox(
                height: 60,
                child: Row(children: [
                  Expanded(
                    child: _selectedDate == null
                        ? const Text('No Date Chosen!')
                        : Row(
                            children: [
                              const Text('Picked Date: '),
                              Text(
                                DateFormat.yMMMMd().format(_selectedDate!),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                  ),
                  ElevatedButton(
                    onPressed: _presentDatePicker,
                    child: const Text(
                      'Choose Date',
                    ),
                  ),
                ]),
              ),
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: ElevatedButton(
                    onPressed: _submitData,
                    child: const Text('Add Transaction'),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
