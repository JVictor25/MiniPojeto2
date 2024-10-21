import '../model/Tarefa.dart';
import '../widgets/TodoForm.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class TaskDetail extends StatefulWidget {
  final Tarefa tarefa;
  final List<Tarefa> listaTarefas;
  final int index;

  const TaskDetail({
    super.key,
    required this.tarefa,
    required this.listaTarefas,
    required this.index,
  });
  @override
  _TaskDetailState createState() => _TaskDetailState();
}

class _TaskDetailState extends State<TaskDetail> {

  void _editTarefa(
      String tituloTarefa,
      String descricaoTarefa,
      DateTime dataSelecionada,
      String prioridadeTarefa,
      String observacaoTarefa) {
    Tarefa _tarefaEditada = Tarefa(
      id: widget.tarefa.id,
      titulo: tituloTarefa,
      descricao: descricaoTarefa,
      dataTarefa: dataSelecionada,
      prioridade: prioridadeTarefa,
      observacao: observacaoTarefa,
    );
    setState(() {
      final index = widget.listaTarefas.indexWhere((t) => t.id == _tarefaEditada.id);
      if (index != -1) {
        widget.listaTarefas[index] = _tarefaEditada;
      }
    });
      Navigator.pop(context, _tarefaEditada);
  }
    void _openTaskForm() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: TodoForm(onSubmit: _editTarefa, isModifying: true,),
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context, String id) {
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
                _deleteTask(id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteTask(String id) {
    setState(() {
      widget.listaTarefas.removeWhere((tarefa) => tarefa.id == id);
    });
    
    // Retorna um valor indicando que a tarefa foi excluída
    Navigator.pop(context, 'deleted');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalhes da tarefa"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("ID: ${widget.tarefa.id}", textAlign: TextAlign.center),
            Text("Titulo: ${widget.tarefa.titulo}", textAlign: TextAlign.center),
            Text("Descrição: ${widget.tarefa.descricao}", textAlign: TextAlign.center),
            Text("Data: ${DateFormat('dd/MM/yyyy').format(widget.tarefa.dataTarefa)}",
                textAlign: TextAlign.center),
            Text(
                "Data da criação: ${DateFormat('dd/MM/yyyy').format(widget.tarefa.dataCriacao)}",
                textAlign: TextAlign.center),
            Text("Prioridade: ${widget.tarefa.prioridade}",
                textAlign: TextAlign.center),
            Text("Observacao: ${widget.tarefa.observacao}",
                textAlign: TextAlign.center),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () => _openTaskForm(),
                  child: Text("Editar Tarefa"),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _showDeleteConfirmation(
                  context, widget.listaTarefas.elementAt(widget.index).id),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
