import 'package:flutter/material.dart';
import '../../api/api_service.dart';
import '../../models/ordem_servico.dart';
import '../../utils/secure_storage.dart';
import 'package:intl/intl.dart'; // Adicione a dependência `intl: ^0.19.0` no pubspec.yaml

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

  // Função para retornar um ícone e cor com base na prioridade
  Widget _buildPriorityIcon(String prioridade) {
    switch (prioridade.toUpperCase()) {
      case 'ALTA':
        return Icon(Icons.keyboard_arrow_up_rounded, color: Colors.red.shade700);
      case 'MEDIA':
        return Icon(Icons.remove_rounded, color: Colors.amber.shade700);
      case 'BAIXA':
      default:
        return Icon(Icons.keyboard_arrow_down_rounded, color: Colors.green.shade700);
    }
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
                      // TODO: Navegar para a tela de detalhes
                      print('Tocou na OS: ${ordem.numero}');
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  'OS: ${ordem.numero}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Chip(
                                label: Text(ordem.status, style: const TextStyle(fontSize: 12)),
                                padding: EdgeInsets.zero,
                                visualDensity: VisualDensity.compact,
                              ),
                            ],
                          ),
                          const Divider(height: 16),
                          Row(
                            children: [
                              const Icon(Icons.precision_manufacturing_outlined, size: 18, color: Colors.black54),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  ordem.ativo.nome,
                                  style: const TextStyle(fontSize: 15),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.description_outlined, size: 18, color: Colors.black54),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  ordem.descricaoProblema,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  _buildPriorityIcon(ordem.prioridade),
                                  Text(ordem.prioridade),
                                ],
                              ),
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
