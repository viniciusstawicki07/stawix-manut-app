import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/ordem_servico.dart';

class OsDetailsScreen extends StatelessWidget {
  const OsDetailsScreen({super.key});

  // Função auxiliar para criar uma linha de informação com ícone
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey.shade600),
          const SizedBox(width: 12),
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  // Função auxiliar para criar um card de informação
  Widget _buildInfoCard({required String title, required List<Widget> children}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 1.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(height: 20),
            ...children,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Recebe o objeto OrdemServico passado como argumento da tela anterior
    final ordem = ModalRoute.of(context)!.settings.arguments as OrdemServico;

    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes da OS: ${ordem.numero}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // Card de Status e Prioridade
            Card(
              color: Colors.blueGrey.shade50,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        const Text('STATUS', style: TextStyle(fontSize: 12, color: Colors.black54)),
                        const SizedBox(height: 4),
                        Text(ordem.status, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                    Column(
                      children: [
                        const Text('PRIORIDADE', style: TextStyle(fontSize: 12, color: Colors.black54)),
                        const SizedBox(height: 4),
                        Text(ordem.prioridade, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Card de Informações do Ativo
            _buildInfoCard(
              title: 'Ativo',
              children: [
                _buildInfoRow(Icons.qr_code, 'Código', ordem.ativo.codigo),
                _buildInfoRow(Icons.description_outlined, 'Descrição', ordem.ativo.descricao),
                _buildInfoRow(Icons.location_on_outlined, 'Unidade', ordem.ativo.unidade),
                _buildInfoRow(Icons.build_circle_outlined, 'Tipo', ordem.ativo.tipoEquipamento),
                _buildInfoRow(Icons.tag, 'Patrimônio', ordem.ativo.numeroPatrimonio),
                _buildInfoRow(Icons.factory_outlined, 'Fabricante', ordem.ativo.fabricante ?? 'N/D'),
                _buildInfoRow(Icons.model_training, 'Modelo', ordem.ativo.modelo ?? 'N/D'),
              ],
            ),

            // Card de Detalhes da Manutenção
            _buildInfoCard(
              title: 'Detalhes da Manutenção',
              children: [
                _buildInfoRow(Icons.calendar_today, 'Data de Abertura', DateFormat('dd/MM/yyyy HH:mm').format(ordem.dataAbertura)),
                _buildInfoRow(
                  Icons.check_circle_outline,
                  'Data de Conclusão',
                  ordem.dataConclusao != null ? DateFormat('dd/MM/yyyy HH:mm').format(ordem.dataConclusao!) : 'Pendente',
                ),
                _buildInfoRow(Icons.person_outline, 'Técnico', ordem.tecnico.nome),
              ],
            ),

            // Card de Descrição do Problema
            _buildInfoCard(
              title: 'Descrição do Problema',
              children: [
                Text(ordem.descricaoProblema),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Implementar lógica para iniciar/concluir a OS
        },
        label: const Text('Iniciar Serviço'),
        icon: const Icon(Icons.play_arrow_rounded),
      ),
    );
  }
}
