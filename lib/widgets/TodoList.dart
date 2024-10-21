import '../model/Tarefa.dart';
import '../screens/TaskDetail.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TodoList extends StatefulWidget {
  final List<Tarefa> listaTarefas;

  const TodoList({
    super.key,
    required this.listaTarefas,
  });

  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  List<Tarefa> _listaTarefas = [];

  List<String> _ordenarOptions = [
    'Prioridade',
    'Data de criação',
    'Data da tarefa'
  ];
  String? _ordenarSelected = 'Data de criação';

  @override
  void initState() {
    super.initState();
    _listaTarefas =
        widget.listaTarefas; // Inicializamos a lista com os dados do widget pai
  }

  void _ordenarItems(String? select) {
  setState(() {
    switch (select) {
      case 'Prioridade':
        _listaTarefas.sort((a, b) {
          int priorityCompare = _comparePrioridade(a.prioridade, b.prioridade);
          if (priorityCompare != 0) return priorityCompare;

          // Se as prioridades forem iguais, ordenar pela data de criação
          return a.dataCriacao.compareTo(b.dataCriacao);
        });
        break;
      case 'Data de criação':
        _listaTarefas.sort((a, b) => a.dataCriacao.compareTo(b.dataCriacao));
        break;
      case 'Data da tarefa':
        _listaTarefas.sort((a, b) => a.dataTarefa.compareTo(b.dataTarefa));
        break;
    }
  });
}

// Função auxiliar para comparar prioridades
int _comparePrioridade(String prioridadeA, String prioridadeB) {
  // Mapeia as prioridades para valores inteiros
  const Map<String, int> priorityValues = {
    'ALTA': 1,
    'NORMAL': 2,
    'BAIXA': 3,
  };

  // Retorna a diferença entre os valores das prioridades
  return priorityValues[prioridadeA]!.compareTo(priorityValues[prioridadeB]!);
}

  void _deleteTask(String id) {
    setState(() {
      // Atualiza o estado antes de remover a tarefa
      _listaTarefas.removeWhere((tarefa) => tarefa.id == id);
    });
  }

  void _openTaskDetail(Tarefa tarefa, int index) async {
  // Espera o retorno da TaskDetail
  final result = await Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => TaskDetail(tarefa: tarefa, listaTarefas: _listaTarefas, index: index),
    ),
  );

  // Se a tarefa foi editada, atualiza a lista
  if (result is Tarefa) {
    setState(() {
      _listaTarefas[index] = result;
    });
  }

  // Se a tarefa foi excluída, remove-a da lista
  if (result == 'deleted') {
    setState(() {
      _listaTarefas.removeAt(index);
    });
  }
}

  void _showDeleteConfirmation(BuildContext context, String id, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmação de Exclusão'),
          content: Text('Tem certeza que deseja excluir esta tarefa?'),
          actions: <Widget>[
            TextButton(
              child: Text('Não'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Sim'),
              onPressed: () {
                _deleteTask(id,);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_listaTarefas.isEmpty) {
      return Center(
        child: Text(
          "Nenhuma tarefa cadastrada",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      );
    }

    return Container(
      height: 300,
      child: Column(
        children: [
          // Filtro "Ordenar por" colocado fora do ListView.builder
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Ordenar por:'),
              DropdownButton<String>(
                value: _ordenarSelected,
                onChanged: (String? newValue) {
                  setState(() {
                    _ordenarSelected = newValue;
                  });
                  _ordenarItems(newValue);
                },
                items: _ordenarOptions.map((String option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
              ),
            ],
          ),
          // ListView.builder para exibir as tarefas
          Expanded(
            child: ListView.builder(
              itemCount: _listaTarefas.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(8),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "${DateFormat('dd/MM/y').format(_listaTarefas.elementAt(index).dataTarefa)}",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                color: DateUtils.isSameDay(
                                        _listaTarefas
                                            .elementAt(index)
                                            .dataTarefa,
                                        DateTime.now())
                                    ? Colors.green
                                    : (_listaTarefas
                                            .elementAt(index)
                                            .dataTarefa
                                            .isBefore(DateTime.now())
                                        ? const Color.fromARGB(255, 255, 0, 0)
                                        : Colors.black),
                              ),
                        ),
                        Expanded(
                          child: Text(
                            _listaTarefas.elementAt(index).titulo,
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              _listaTarefas.elementAt(index).prioridade,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: _listaTarefas
                                                .elementAt(index)
                                                .prioridade ==
                                            'ALTA'
                                        ? Colors.red
                                        : (_listaTarefas
                                                    .elementAt(index)
                                                    .prioridade ==
                                                'NORMAL'
                                            ? Colors.orange
                                            : Colors.black),
                                  ),
                              textAlign: TextAlign.right,
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () => _showDeleteConfirmation(
                                  context, _listaTarefas.elementAt(index).id, index),
                            ),
                            IconButton(
                              icon: Icon(Icons.info),
                              onPressed: () => _openTaskDetail(_listaTarefas[index],index),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
