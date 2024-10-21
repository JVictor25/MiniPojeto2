import 'dart:math';

import 'model/Tarefa.dart';
import 'widgets/TodoForm.dart';
import 'package:f04_todo_list/widgets/TodoList.dart';
import 'package:flutter/material.dart';

class TodoApp extends StatefulWidget {
  const TodoApp({super.key});

  @override
  State<TodoApp> createState() => _TodoAppState();
}



class _TodoAppState extends State<TodoApp> {
  List<Tarefa> _listaTarefas = [
    /*Tarefa(
      id: Random().nextInt(9999).toString(),
      titulo: "Estudar",
      descricao: "Estudar EDB",
      dataTarefa: DateTime.now(),
      prioridade: "ALTA",
      observacao: "",
    ),
    Tarefa(
      id: Random().nextInt(9999).toString(),
      titulo: "Jogar",
      descricao: "Jogar 2K",
      dataTarefa: DateTime.now(),
      prioridade: "ALTA",
      observacao: "",
    ),*/
  ];

  void _addTarefa(
      String tituloTarefa,
      String descricaoTarefa,
      DateTime dataSelecionada,
      String prioridadeTarefa,
      String observacaoTarefa) {
    Tarefa _novaTarefa = Tarefa(
      id: Random().nextInt(9999).toString(),
      titulo: tituloTarefa,
      descricao: descricaoTarefa,
      dataTarefa: dataSelecionada,
      prioridade: prioridadeTarefa,
      observacao: observacaoTarefa,
    );
    setState(() {
      _listaTarefas.add(_novaTarefa);
    });
  }

  

   void _openTaskForm() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: TodoForm(onSubmit: _addTarefa, isModifying: false,),
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Minhas Tarefas",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: ThemeData().primaryColor,
        actions: [
          IconButton(
            onPressed: _openTaskForm,
            icon: Icon(
              Icons.add_circle,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Expanded(child: TodoList(listaTarefas: _listaTarefas)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openTaskForm,
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }
}
