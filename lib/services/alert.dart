
import 'package:flutter/material.dart';
 
class Alert extends StatelessWidget {
  const Alert({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        child: const Text('Show alert'),
        onPressed: () {
          _showAlertDialog(context,'teste');
        },
      ),
    );
  }
    void _showAlertDialog(BuildContext context, String message){
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: const Text('Cadastro'),
          content: Text(message),
          actions: <Widget>[
            TextButton(onPressed: (){
              Navigator.of(context).pop();
            }, 
            child: const Text('Ok'))
          ],
        );
      }
    );
  }
  
}