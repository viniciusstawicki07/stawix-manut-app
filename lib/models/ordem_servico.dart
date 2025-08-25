import 'ativo.dart';
import 'tecnico.dart';

class OrdemServico {
  final String numero;
  final String status;
  final String prioridade;
  final String tipoManutencao;
  final DateTime dataAbertura;
  final DateTime? dataConclusao;
  final String descricaoProblema;
  final Ativo ativo;
  final Tecnico tecnico;

  OrdemServico({
    required this.numero,
    required this.status,
    required this.prioridade,
    required this.tipoManutencao,
    required this.dataAbertura,
    this.dataConclusao,
    required this.descricaoProblema,
    required this.ativo,
    required this.tecnico,
  });

  factory OrdemServico.fromJson(Map<String, dynamic> json) {
    return OrdemServico(
      numero: json['numero']?.toString() ?? '',
      status: json['status_display'] ?? 'Desconhecido',
      prioridade: json['prioridade_display'] ?? 'N/D',
      tipoManutencao: json['tipo_display'] ?? 'N/D',
      dataAbertura: json['data_abertura'] != null
          ? DateTime.parse(json['data_abertura'])
          : DateTime.now(),
      dataConclusao: json['data_conclusao'] != null
          ? DateTime.parse(json['data_conclusao'])
          : null,
      descricaoProblema: json['descricao_problema'] ?? 'Sem descrição',
      ativo: Ativo.fromJson(json['ativo'] is Map<String, dynamic> ? json['ativo'] : {}),
      tecnico: Tecnico.fromJson(json['tecnico_responsavel'] is Map<String, dynamic> ? json['tecnico_responsavel'] : {}),
    );
  }
}
