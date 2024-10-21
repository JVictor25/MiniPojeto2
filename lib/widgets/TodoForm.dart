import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TodoForm extends StatefulWidget {
  final void Function(String, String, DateTime, String, String) onSubmit;
  final bool isModifying;

  const TodoForm({
    super.key,
    required this.onSubmit,
    required this.isModifying,
  });

  @override
  State<TodoForm> createState() => _TodoFormState();
}

class _TodoFormState extends State<TodoForm> {
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _observacaoController = TextEditingController();
  DateTime _dataSelecionada = DateTime.now();
  String _prioridadeSelecionada = 'NORMAL'; // Valor padrão

  void _submitForm() {
    String _tituloTarefa = _tituloController.text;
    String _descricaoTarefa = _descricaoController.text;
    String _observacaoTarefa = _observacaoController.text;

    if (_tituloTarefa.isEmpty || _descricaoTarefa.isEmpty) {
      return; // Verifica se os campos obrigatórios estão preenchidos
    }

    widget.onSubmit(
      _tituloTarefa,
      _descricaoTarefa,
      _dataSelecionada,
      _prioridadeSelecionada,
      _observacaoTarefa,
    );
    Navigator.of(context).pop();
  }

  void _showDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2024, 1, 1),
            lastDate: DateTime(2025))
        .then((pickedDate) {
      //chamada no futuro
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _dataSelecionada = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          // Campo para o título da tarefa
          Text(
            "Título: ",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          SizedBox(height: 16),
          TextField(
            controller: _tituloController,
            decoration: InputDecoration(
              hintText: "Inserir título",
              hintStyle: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ),
          SizedBox(height: 16),

          // Campo para a descrição
          Text(
            "Descrição: ",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          SizedBox(height: 16),
          TextField(
            controller: _descricaoController,
            decoration: InputDecoration(
              hintText: "Inserir descrição",
              hintStyle: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ),
          SizedBox(height: 16),

          // Campo para selecionar a prioridade
          Text("Prioridade: "),
          DropdownButton<String>(
            value: _prioridadeSelecionada,
            onChanged: (String? novaPrioridade) {
              setState(() {
                _prioridadeSelecionada = novaPrioridade!;
              });
            },
            items: ['ALTA', 'NORMAL', 'BAIXA'].map((String prioridade) {
              return DropdownMenuItem<String>(
                value: prioridade,
                child: Text(prioridade),
              );
            }).toList(),
          ),
          SizedBox(height: 16),

          // Campo de observações
          Text(
            "Observação: ",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          SizedBox(height: 16),
          TextField(
            controller: _observacaoController,
            decoration: InputDecoration(
              hintText: "Inserir observação",
              hintStyle: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ),
          SizedBox(height: 16),

          Container(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Row(children: <Widget>[
                Expanded(
                  child: Text(
                    _dataSelecionada == null
                        ? 'Nenhuma data selecionada'
                        : 'Data selecionada: ${DateFormat('dd/MM/y').format(_dataSelecionada)}',
                  ),
                ),
                TextButton(
                    //style: TextButton.styleFrom(primary: Colors.blue),
                    onPressed: _showDatePicker,
                    child: Text(
                      'Selecionar Data',
                    ))
              ]),
            ),
          ),
          Column(children: [
            ElevatedButton(
              onPressed: () => _submitForm(),
              child: Text(widget.isModifying ? "Modificar" : "Adicionar"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Voltar',
                style: TextStyle(color: Colors.blue, fontSize: 11),
              ),
            ),
          ]),
          SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }
}
