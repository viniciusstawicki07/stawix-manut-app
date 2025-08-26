import 'package:flutter/material.dart';
import '../../models/ordem_servico.dart';
import '../../api/api_service.dart';

class OsEditScreen extends StatefulWidget {
  const OsEditScreen({super.key});

  @override
  State<OsEditScreen> createState() => _OsEditScreenState();
}

class _OsEditScreenState extends State<OsEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();
  late OrdemServico _ordem;

  late TextEditingController _descricaoProblemaController;
  late String _selectedStatus;
  bool _isLoading = false;

  // CORREÇÃO: Lista de status agora corresponde EXATAMENTE ao seu models.py
  final List<String> _statusOptions = [
    'ABERTA',
    'EM_EXECUCAO',
    'CONCLUIDA',
    'FECHADA',
    'CANCELADA',
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _ordem = ModalRoute.of(context)!.settings.arguments as OrdemServico;
    // O controlador agora edita a 'descricaoProblema'
    _descricaoProblemaController = TextEditingController(text: _ordem.descricaoProblema);
    // Converte o status da OS (ex: "Em Execução") para o formato interno da chave (ex: "EM_EXECUCAO")
    _selectedStatus = _ordem.status.toUpperCase().replaceAll(' ', '_');
  }

  @override
  void dispose() {
    _descricaoProblemaController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() { _isLoading = true; });

      final updatedOrdem = await _apiService.updateOrdemServico(
        osNumero: _ordem.numero,
        newStatus: _selectedStatus,
        // Enviando a descrição do problema atualizada
        newProblemDescription: _descricaoProblemaController.text,
      );

      setState(() { _isLoading = false; });

      if (updatedOrdem != null && mounted) {
        Navigator.of(context).pop(updatedOrdem);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Falha ao salvar as alterações.'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Editar OS: ${_ordem.numero}')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<String>(
                value: _statusOptions.contains(_selectedStatus) ? _selectedStatus : null,
                decoration: const InputDecoration(labelText: 'Status da OS', border: OutlineInputBorder()),
                items: _statusOptions.map((String status) {
                  return DropdownMenuItem<String>(value: status, child: Text(status.replaceAll('_', ' ')));
                }).toList(),
                onChanged: (newValue) {
                  setState(() { _selectedStatus = newValue!; });
                },
              ),
              const SizedBox(height: 24),
              TextFormField(
                // Controlador e label ajustados para 'Descrição do Problema'
                controller: _descricaoProblemaController,
                decoration: const InputDecoration(
                  labelText: 'Descrição do Problema',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 5,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _submitForm,
                icon: _isLoading
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.save),
                label: const Text('Salvar Alterações'),
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
