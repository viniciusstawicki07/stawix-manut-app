class Ativo {
  final int id;
  final String nome;
  final String codigo;
  final String numeroPatrimonio;
  final String descricao;
  final String tipoEquipamento;
  final String status;
  final String unidade;
  final String? fabricante;
  final String? modelo;

  Ativo({
    required this.id,
    required this.nome,
    required this.codigo,
    required this.numeroPatrimonio,
    required this.descricao,
    required this.tipoEquipamento,
    required this.status,
    required this.unidade,
    this.fabricante,
    this.modelo,
  });

  factory Ativo.fromJson(Map<String, dynamic> json) {
    return Ativo(
      // CORREÇÃO: Análise robusta para o ID, evitando erros de tipo.
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      nome: json['nome'] ?? 'Nome não informado',
      codigo: json['codigo']?.toString() ?? 'S/C',
      numeroPatrimonio: json['numero_patrimonio']?.toString() ?? 'N/P',
      descricao: json['descricao'] ?? '',
      tipoEquipamento: json['tipo_equipamento'] ?? '',
      status: json['status'] ?? '',
      unidade: json['unidade'] ?? '',
      fabricante: json['fabricante'],
      modelo: json['modelo'],
    );
  }
}
