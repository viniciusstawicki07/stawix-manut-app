import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:manutencao_bj_app/models/ordem_servico.dart';
import '../utils/secure_storage.dart';

class ApiService {
  // ATENÇÃO: Use o IP da sua máquina, não localhost, para testes no emulador/dispositivo físico.
  // Para o emulador do Android, o IP do localhost da sua máquina é 10.0.2.2
  static const String _baseUrl = 'http://172.16.1.11:8000';
  final SecureStorage _secureStorage = SecureStorage();

  /// Realiza o login na API e armazena os tokens JWT.
  /// Retorna `true` em caso de sucesso e `false` em caso de falha.
  Future<bool> login(String username, String password) async {
    final url = Uri.parse('$_baseUrl/api/token/');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Salva os tokens de forma segura
        await _secureStorage.writeToken('access', data['access']);
        await _secureStorage.writeToken('refresh', data['refresh']);
        return true;
      } else {
        // Trata outros códigos de status (ex: 401 Unauthorized)
        print('Erro de login - Status: ${response.statusCode}');
        print('Corpo da resposta: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Uma exceção ocorreu ao tentar fazer login: $e');
      return false;
    }
  }

  /// Busca a lista de Ordens de Serviço da API.
  /// Requer um token de acesso válido.
  Future<List<OrdemServico>> getOrdensServico() async {
    final accessToken = await _secureStorage.readToken('access');
    if (accessToken == null) {
      // Se não houver token, não podemos fazer a chamada.
      // Em um app real, aqui você poderia tentar renovar o token ou deslogar o usuário.
      print('Token de acesso não encontrado.');
      return [];
    }

    final url = Uri.parse('$_baseUrl/api/ordens/');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        // Decodifica a resposta, que é uma lista de JSONs
        // NOTA: A API do Django REST Framework geralmente retorna os resultados dentro de uma chave "results" quando há paginação.
        // Se a sua view não usa paginação, a resposta pode ser a lista diretamente.
        // Vou assumir que não há paginação para simplificar.
        final List<dynamic> responseBody = json.decode(utf8.decode(response.bodyBytes));

        // Mapeia a lista de JSON para uma lista de objetos OrdemServico
        List<OrdemServico> ordens = responseBody
            .map((data) => OrdemServico.fromJson(data))
            .toList();

        return ordens;
      } else {
        print('Erro ao buscar Ordens de Serviço - Status: ${response.statusCode}');
        print('Corpo da resposta: ${response.body}');
        return [];
      }
    } catch (e) {
      print('Uma exceção ocorreu ao buscar as Ordens de Serviço: $e');
      return [];
    }
  }
}
