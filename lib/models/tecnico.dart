class Tecnico {
  final int id;
  final String nome;
  final String matricula;
  final String status;

  Tecnico({
    required this.id,
    required this.nome,
    required this.matricula,
    required this.status,
  });

  factory Tecnico.fromJson(Map<String, dynamic> json) {
    return Tecnico(
      // CORREÇÃO: Análise robusta para o ID.
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      nome: json['nome'] ?? 'Técnico não atribuído',
      matricula: json['matricula']?.toString() ?? 'S/M',
      status: json['status'] ?? 'Desconhecido',
    );
  }
}
