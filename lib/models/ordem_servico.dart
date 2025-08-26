import 'ativo.dart';
import 'tecnico.dart';

class OrdemServico {
  final String numero;
  // CORREÇÃO: Campos separados para o valor e para a exibição
  final String status;
  final String statusDisplay;
  final String prioridade;
  final String prioridadeDisplay;
  final String tipoManutencao;
  final String tipoManutencaoDisplay;

  final DateTime dataAbertura;
  final DateTime? dataConclusao;
  final String descricaoProblema;
  final String? descricaoServico;
  final Ativo ativo;
  final Tecnico tecnico;

  OrdemServico({
    required this.numero,
    required this.status,
    required this.statusDisplay,
    required this.prioridade,
    required this.prioridadeDisplay,
    required this.tipoManutencao,
    required this.tipoManutencaoDisplay,
    required this.dataAbertura,
    this.dataConclusao,
    required this.descricaoProblema,
    this.descricaoServico,
    required this.ativo,
    required this.tecnico,
  });

  factory OrdemServico.fromJson(Map<String, dynamic> json) {
    return OrdemServico(
      numero: json['numero']?.toString() ?? '',
      // CORREÇÃO: Mapeando os campos de valor e de exibição separadamente
      status: json['status'] ?? 'ABERTA',
      statusDisplay: json['status_display'] ?? 'Aberta',
      prioridade: json['prioridade'] ?? 'BAIXA',
      prioridadeDisplay: json['prioridade_display'] ?? 'Baixa',
      tipoManutencao: json['tipo'] ?? 'CORRETIVA',
      tipoManutencaoDisplay: json['tipo_display'] ?? 'Corretiva',

      dataAbertura: json['data_abertura'] != null
          ? DateTime.parse(json['data_abertura'])
          : DateTime.now(),
      dataConclusao: json['data_conclusao'] != null
          ? DateTime.parse(json['data_conclusao'])
          : null,
      descricaoProblema: json['descricao_problema'] ?? 'Sem descrição',
      descricaoServico: json['descricao_servico'],
      ativo: Ativo.fromJson(json['ativo'] is Map<String, dynamic> ? json['ativo'] : {}),
      tecnico: Tecnico.fromJson(json['tecnico_responsavel'] is Map<String, dynamic> ? json['tecnico_responsavel'] : {}),
    );
  }

  /// NOVO MÉTODO: Prepara os dados para serem enviados em uma requisição PATCH.
  Map<String, dynamic> toJsonForUpdate({required String newStatus, required String newProblemDescription}) {
    return {
      'status': newStatus,
      'descricao_problema': newProblemDescription,
    };
  }
}
