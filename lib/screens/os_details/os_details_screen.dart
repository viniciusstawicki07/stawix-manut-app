import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/ordem_servico.dart';

class OsDetailsScreen extends StatefulWidget {
  const OsDetailsScreen({super.key});

  @override
  State<OsDetailsScreen> createState() => _OsDetailsScreenState();
}

class _OsDetailsScreenState extends State<OsDetailsScreen> {
  late OrdemServico ordem;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Pega a OS enviada da tela de lista
    ordem = ModalRoute.of(context)!.settings.arguments as OrdemServico;
  }

  /// Navega para a tela de edição e aguarda um resultado.
  /// Se a edição for salva, a tela de edição retornará a OS atualizada,
  /// e nós atualizamos o estado desta tela para refletir as mudanças.
  Future<void> _navigateToEditScreen() async {
    final result = await Navigator.pushNamed(
      context,
      '/os_edit',
      arguments: ordem,
    );

    if (result != null && result is OrdemServico) {
      setState(() {
        ordem = result;
      });
    }
  }

  // Funções auxiliares para construir a UI
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes da OS: ${ordem.numero}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
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
        onPressed: _navigateToEditScreen,
        label: const Text('Atualizar OS'),
        icon: const Icon(Icons.edit_note_rounded),
      ),
    );
  }
}
