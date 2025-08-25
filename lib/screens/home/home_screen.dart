import 'package:flutter/material.dart';
import '../../api/api_service.dart';
import '../../models/ordem_servico.dart';
import '../../utils/secure_storage.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SecureStorage _secureStorage = SecureStorage();
  final ApiService _apiService = ApiService();
  late Future<List<OrdemServico>> _ordensFuture;

  @override
  void initState() {
    super.initState();
    _loadOrdensServico();
  }

  void _loadOrdensServico() {
    setState(() {
      _ordensFuture = _apiService.getOrdensServico();
    });
  }

  Future<void> _logout() async {
    await _secureStorage.deleteAllTokens();
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/');
    }
  }

  // Função auxiliar para obter a cor baseada no status da OS
  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'ABERTA':
        return Colors.blue.shade700;
      case 'EM ANDAMENTO':
        return Colors.amber.shade800;
      case 'CONCLUÍDA':
        return Colors.green.shade700;
      case 'CANCELADA':
        return Colors.red.shade700;
      default:
        return Colors.grey.shade600;
    }
  }

  // Função auxiliar para criar o widget de prioridade com cor e ícone
  Widget _buildPriorityChip(String prioridade) {
    Color chipColor;
    IconData iconData;

    switch (prioridade.toUpperCase()) {
      case 'ALTA':
        chipColor = Colors.red.shade100;
        iconData = Icons.keyboard_double_arrow_up_rounded;
        break;
      case 'MÉDIA':
        chipColor = Colors.amber.shade100;
        iconData = Icons.drag_handle_rounded;
        break;
      case 'BAIXA':
      default:
        chipColor = Colors.green.shade100;
        iconData = Icons.keyboard_double_arrow_down_rounded;
    }

    return Chip(
      avatar: Icon(iconData, size: 16, color: chipColor.computeLuminance() > 0.5 ? Colors.black87 : Colors.white),
      label: Text(prioridade),
      backgroundColor: chipColor,
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      labelStyle: TextStyle(color: chipColor.computeLuminance() > 0.5 ? Colors.black87 : Colors.white, fontWeight: FontWeight.bold),
      visualDensity: VisualDensity.compact,
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Ordens de Serviço'),
        actions: [
          IconButton(
            tooltip: 'Sair',
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => _loadOrdensServico(),
        child: FutureBuilder<List<OrdemServico>>(
          future: _ordensFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Erro ao carregar dados: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Nenhuma Ordem de Serviço encontrada.'));
            }

            final ordens = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: ordens.length,
              itemBuilder: (context, index) {
                final ordem = ordens[index];
                return Card(
                  elevation: 2.0,
                  margin: const EdgeInsets.symmetric(vertical: 6.0),
                  child: InkWell(
                    onTap: () {
                      // NAVEGAÇÃO PARA A TELA DE DETALHES
                      Navigator.pushNamed(
                        context,
                        '/os_details',
                        arguments: ordem,
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // LINHA 1: Número da OS e Status
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'OS: ${ordem.numero}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(ordem.status),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  ordem.status.toUpperCase(),
                                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 16),

                          // LINHA 2: Código do Ativo e Unidade
                          Row(
                            children: [
                              const Icon(Icons.qr_code_scanner, size: 16, color: Colors.black54),
                              const SizedBox(width: 8),
                              Text('Ativo: ${ordem.ativo.codigo}'),
                              const Text('  |  '),
                              const Icon(Icons.location_on_outlined, size: 16, color: Colors.black54),
                              const SizedBox(width: 4),
                              Expanded(child: Text(ordem.ativo.unidade, overflow: TextOverflow.ellipsis)),
                            ],
                          ),
                          const SizedBox(height: 8),

                          // LINHA 3: Tipo de Manutenção
                          Row(
                            children: [
                              const Icon(Icons.build_outlined, size: 16, color: Colors.black54),
                              const SizedBox(width: 8),
                              Text('Tipo: ${ordem.tipoManutencao}'),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // LINHA 4: Prioridade e Data
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildPriorityChip(ordem.prioridade),
                              Text(
                                DateFormat('dd/MM/yyyy').format(ordem.dataAbertura),
                                style: const TextStyle(color: Colors.black54, fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
