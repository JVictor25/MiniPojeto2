class Tarefa {
  Tarefa({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.dataTarefa,
    required this.prioridade,
    required this.observacao,
  }) : dataCriacao = DateTime.now(); // A data de criação é automaticamente a data atual

  String id;
  String titulo;  // Novo campo para o título da tarefa
  String descricao;
  DateTime dataTarefa;  // Data definida pelo usuário
  DateTime dataCriacao; // Data de criação automática
  String prioridade;  // ALTA, NORMAL, BAIXA
  String observacao;  // Comentários sobre a tarefa
}