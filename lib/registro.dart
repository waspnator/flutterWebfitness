import 'package:flutter/material.dart';
import 'package:flutter_webview_academia/main.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:flutter_webview_academia/services/api_service.dart';
import 'package:flutter_webview_academia/services/notification_service.dart';
import 'package:intl/intl.dart';

class CadastroScreen extends StatelessWidget {
  const CadastroScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
          title: const Text('Cadastro de Usuários'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            // Adiciona a rolagem
            child: Column(
              children: <Widget>[
                Image.asset(
                  'assets/power-gym.png',
                  height: 100,
                ),
                const SizedBox(height: 20),
                const CadastroForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CadastroForm extends StatefulWidget {
  const CadastroForm({super.key});

  @override
  _CadastroFormState createState() => _CadastroFormState();
}

class _CadastroFormState extends State<CadastroForm> {
  final _formKey = GlobalKey<FormState>();

  final _nomeController = TextEditingController();
  final _sobrenomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _celularController = TextEditingController();
  final _cpfController = TextEditingController(); // Controller para CPF
  final _senhaController = TextEditingController();
  final _repetirSenhaController = TextEditingController();

  final ApiService apiService = ApiService();
  bool _isLoading = false; // Controlador de estado para o loading
  bool _isObscureSenha = true; // Controla a visibilidade da senha
  bool _isObscureRepetirSenha =
      true; // Controla a visibilidade da repetir senha

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                  controller: _nomeController,
                  decoration: const InputDecoration(labelText: 'Nome'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira um nome';
                    }
                    if (value.length < 3) {
                      return 'O nome deve conter ao menos 3 caracteres';
                    }
                    return null;
                  }),
              TextFormField(
                  controller: _sobrenomeController,
                  decoration: const InputDecoration(labelText: 'Sobrenome'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira um sobrenome';
                    }
                    if (value.length < 3) {
                      return 'O sobrenome deve conter ao menos 3 caracteres';
                    }
                    return null;
                  }),
              TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira um email';
                    }
                    String pattern = r'^[^@]+@[^@]+\.[^@]+';
                    RegExp regex = RegExp(pattern);
                    if (!regex.hasMatch(value)) {
                      return 'Por favor, insira um email válido';
                    }
                    return null;
                  }),
              TextFormField(
                controller: _celularController,
                decoration: const InputDecoration(labelText: 'Celular'),
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  MaskedInputFormatter('(##) #####-####'),
                ],
              ),
              // Campo CPF com máscara
              TextFormField(
                controller: _cpfController,
                decoration: const InputDecoration(labelText: 'CPF'),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  MaskedInputFormatter('###.###.###-##'), // Máscara de CPF
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um CPF';
                  }
                  if (!isValidCPF(value)) {
                    return 'CPF inválido';
                  }
                  return null;
                },
              ),
              // Campo Senha com ícone de olho
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Senha',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscureSenha ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscureSenha =
                            !_isObscureSenha; // Alterna visibilidade
                      });
                    },
                  ),
                ),
                obscureText: _isObscureSenha,
                controller: _senhaController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira uma senha';
                  }
                  if (value.length < 8) {
                    return 'A senha deve conter ao menos 8 caracteres';
                  }
                  if (!RegExp(r'[A-Z]').hasMatch(value)) {
                    return 'A senha deve conter ao menos uma letra maiúscula';
                  }
                  if (!RegExp(r'[0-9]').hasMatch(value)) {
                    return 'A senha deve conter ao menos um número';
                  }
                  return null;
                },
              ),
              // Campo Repetir Senha com ícone de olho
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Repetir Senha',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscureRepetirSenha
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscureRepetirSenha =
                            !_isObscureRepetirSenha; // Alterna visibilidade
                      });
                    },
                  ),
                ),
                obscureText: _isObscureRepetirSenha,
                controller: _repetirSenhaController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, repita a senha cadastrada';
                  }
                  if (value != _senhaController.text) {
                    return 'As senhas não são iguais';
                  }
                  return null;
                },
              ),
              Container(
                padding: const EdgeInsets.all(30.0),
                height: 100,
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 100,
                        child: ElevatedButton(
                          onPressed: () async {
                            // Verifica se o formulário é válido
                            if (_formKey.currentState!.validate()) {
                              // Se a validação passar, inicia o carregamento
                              setState(() {
                                _isLoading = true;
                              });

                              // Continua com a lógica de cadastro
                              DateTime data = DateTime.now();
                              String formataData =
                                  DateFormat("yyyy-MM-ddTHH:mm:ss")
                                      .format(data);

                              String token = await NotificationService.instance
                                  .initialize();

                              try {
                                Future<String> stringFuture =
                                    apiService.CadastrarUsuario({
                                  "idUsuario": 0,
                                  "nome": _nomeController.text,
                                  "sobrenome": _sobrenomeController.text,
                                  "celular": _celularController.text,
                                  "cpf": _cpfController.text,
                                  "email": _emailController.text,
                                  "login": _emailController.text,
                                  "senha": _senhaController.text,
                                  "idCliente": 1,
                                  "tipoLogin": "user",
                                  "flgAtivo": true,
                                  "dtInclusao": formataData,
                                  "dtAlteracao": formataData,
                                  "tokenAparelho": token
                                });

                                String message = await stringFuture;

                                setState(() {
                                  _isLoading = false; // Desativa o carregamento
                                });

                                // Exibe a mensagem de sucesso ou erro
                                if (message == "Sucesso") {
                                  // Limpa os campos
                                  _nomeController.clear();
                                  _sobrenomeController.clear();
                                  _emailController.clear();
                                  _celularController.clear();
                                  _cpfController.clear();
                                  _senhaController.clear();
                                  _repetirSenhaController.clear();

                                  showAlertDialog(context,
                                      'Usuário cadastrado com sucesso!');
                                } else if (message ==
                                    "Email já cadastrado, utilize a recuperação de senha na tela de login") {
                                  showAlertDialog(context,
                                      'Email já cadastrado, utilize a recuperação de senha na tela de login');
                                } else {
                                  showAlertDialog(
                                      context, 'Erro ao cadastrar o usuário!');
                                }
                              } catch (e) {
                                setState(() {
                                  _isLoading =
                                      false; // Desativa o carregamento em caso de erro
                                });
                                showAlertDialog(context,
                                    'Ocorreu um erro ao tentar cadastrar o usuário. Tente novamente mais tarde.');
                              }
                            } else {
                              setState(() {
                                _isLoading =
                                    false;// Se a validação falhar, desativa o carregamento
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white, // cor do texto
                            backgroundColor: Colors.orange,
                          ),
                          child: const Text("Cadastrar"),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(left: 8.0),
                        height: 100,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MyApp()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.orange,
                          ),
                          child: const Text("Voltar"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Exibe o loading quando _isLoading for true
        if (_isLoading)
          const Center(
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }

  bool isValidCPF(String cpf) {
    cpf = cpf.replaceAll(RegExp(r'[^0-9]'), '');
    if (cpf.length != 11) {
      return false;
    }
    if (RegExp(r'^(\d)\1{10}$').hasMatch(cpf)) {
      return false;
    }
    List<int> cpfDigits = cpf.split('').map((e) => int.parse(e)).toList();
    int calcDigit(int factor, int length) {
      int sum = 0;
      for (int i = 0; i < length; i++) {
        sum += cpfDigits[i] * (factor - i);
      }
      int remainder = sum % 11;
      return (remainder < 2) ? 0 : 11 - remainder;
    }

    int firstVerifier = calcDigit(10, 9);
    if (firstVerifier != cpfDigits[9]) {
      return false;
    }
    int secondVerifier = calcDigit(11, 10);
    if (secondVerifier != cpfDigits[10]) {
      return false;
    }
    return true;
  }

  void showAlertDialog(BuildContext content, String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Cadastro'),
            content: Text(message),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Ok'))
            ],
          );
        });
  }
}
