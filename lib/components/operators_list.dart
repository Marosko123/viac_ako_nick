import 'package:ViacAkoNick/common/global_variables.dart';
import 'package:ViacAkoNick/common/server_handling/request_handler.dart';
import 'package:ViacAkoNick/models/operator.dart';
import 'package:flutter/material.dart';

class OperatorsList extends StatefulWidget {
  const OperatorsList({super.key});

  @override
  State<OperatorsList> createState() => _OperatorsListState();
}

class _OperatorsListState extends State<OperatorsList> {
  late Future<List<Operator>> futureOperators;

  @override
  void initState() {
    super.initState();
    futureOperators = RequestHandler.getOnlineOperators();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280.0, // Height for 5 ListTiles (approximately 56.0 per ListTile)
      child: FutureBuilder<List<Operator>>(
        future: futureOperators,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Momentálne nie je dostupný žiadny operátor.'),
            );
          } else if (snapshot.hasData) {
            return OperatorsListComponent(operators: snapshot.data!);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

class OperatorsListComponent extends StatefulWidget {
  const OperatorsListComponent({super.key, required this.operators});

  final List<Operator> operators;

  @override
  State<OperatorsListComponent> createState() => _OperatorsListComponentState();
}

class _OperatorsListComponentState extends State<OperatorsListComponent> {
  int _selectedConsultantIndex = 0;

  @override
  void initState() {
    super.initState();

    GlobalVariables.operatorId = widget.operators[0].id;
    GlobalVariables.operatorName =
        '${widget.operators[0].user.name} ${widget.operators[0].user.surname}';
  }

  void _onOperatorSelected(int index) {
    setState(() {
      _selectedConsultantIndex = index;
      GlobalVariables.operatorId = widget.operators[index].id;
      GlobalVariables.operatorName =
          '${widget.operators[index].user.name} ${widget.operators[index].user.surname}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.operators.length, // Access the widget's operators
      itemBuilder: (context, index) {
        return RadioListTile<int>(
          value: index,
          groupValue: _selectedConsultantIndex,
          onChanged: (int? value) {
            _onOperatorSelected(value!); // Corrected callback method
          },
          title: Text(
              '${widget.operators[index].user.name} ${widget.operators[index].user.surname}'),
          secondary: const Text(
            '👨',
            style: TextStyle(fontSize: 24),
          ),
        );
      },
    );
  }
}
