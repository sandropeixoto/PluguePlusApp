import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:plugueplus/config/api_config.dart';

class ApiService {
  /// Realiza uma requisicao GET para a API.
  Future<List<dynamic>> getData(String table, {Map<String, String>? params}) async {
    try {
      final uri = Uri.parse(ApiConfig.baseUrl).replace(
        path: '${Uri.parse(ApiConfig.baseUrl).path}/$table',
        queryParameters: params,
      );

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        // A API PHP-CRUD-API retorna um objeto com uma chave correspondente ao nome da tabela
        final data = json.decode(response.body);
        return data[table] ?? []; // Retorna a lista de registros
      } else {
        // Em caso de erro, lanca uma excecao
        throw Exception('Falha ao carregar os dados: ${response.statusCode}');
      }
    } catch (e) {
      // Em caso de erro de rede ou parsing, propaga a excecao
      throw Exception('Falha na conexao: $e');
    }
  }

  /// Faz upload de um arquivo para a API de arquivos.
  Future<String> uploadFile(String filePath, String destination) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiConfig.uploadBaseUrl),
      );

      // Adiciona o caminho de destino e o arquivo
      request.fields['destination'] = destination;
      request.files.add(await http.MultipartFile.fromPath('file', filePath));

      var streamedResponse = await request.send();

      if (streamedResponse.statusCode == 200) {
        final response = await http.Response.fromStream(streamedResponse);
        final data = json.decode(response.body);
        if (data['success'] == true && data['url'] != null) {
          return data['url']; // Retorna a URL do arquivo
        } else {
          throw Exception('Falha no upload: ${data['message']}');
        }
      } else {
        throw Exception('Erro no servidor de upload: ${streamedResponse.statusCode}');
      }
    } catch (e) {
      throw Exception('Falha no upload do arquivo: $e');
    }
  }
}
