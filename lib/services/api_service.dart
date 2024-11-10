import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String url = "http://apiacademia.runasp.net/api/Usuario/InsertUsuario";

  // ignore: non_constant_identifier_names
  Future<String> CadastrarUsuario(Map<String, dynamic> data) async {
    try{
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(data),
      );

      // ignore: avoid_print
      print('Resposta: ${response.body}');

      if(response.statusCode == 200){
        // ignore: avoid_print
        print('Resposta: ${response.body}');
        return response.body;
      }else{
        // ignore: avoid_print
        print('Erro: ${response.statusCode}');
         return response.body;
      }
    }catch (e){
      // ignore: avoid_print
      print('exceçao: ${e}');
      return '';
    }
  }
}