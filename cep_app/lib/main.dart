import 'package:cep_app/model/CEP.dart';
import 'package:cep_app/provider/CEPProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChangeNotifierProvider(
        create: (context) => CEPProvider(),
        child: CEPListScreen(),
      ),
    );
  }
}

class CEPListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cepProvider = Provider.of<CEPProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de CEPs'),
      ),
      body: FutureBuilder(
        future: cepProvider.fetchCEPs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else {
            return Consumer<CEPProvider>(
              builder: (context, cepProvider, child) {
                final ceps = cepProvider.ceps;
                return ListView.builder(
                  itemCount: ceps.length,
                  itemBuilder: (context, index) {
                    final cep = ceps[index];
                    return ListTile(
                      title: Text(cep.cep),
                      subtitle: Text(cep.logradouro),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          _editarCEP(context, cep);
                        },
                      ),
                      onLongPress: () {
                        _excluirCEP(context, cep);
                      },
                    );
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _cadastrarCEP(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _cadastrarCEP(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        final cepProvider = Provider.of<CEPProvider>(context, listen: false);
        TextEditingController cepController = TextEditingController();
        TextEditingController logradouroController = TextEditingController();
        TextEditingController bairroController = TextEditingController();
        TextEditingController cidadeController = TextEditingController();
        TextEditingController numeroController = TextEditingController();

        return AlertDialog(
          title: const Text('Cadastrar CEP'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: cepController,
                  decoration: const InputDecoration(labelText: 'CEP')),
              TextField(
                  controller: logradouroController,
                  decoration: const InputDecoration(labelText: 'Logradouro')),
              TextField(
                  controller: bairroController,
                  decoration: const InputDecoration(labelText: 'Bairro')),
              TextField(
                  controller: cidadeController,
                  decoration: const InputDecoration(labelText: 'Cidade')),
              TextField(
                  controller: numeroController,
                  decoration: const InputDecoration(labelText: 'Número')),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                CEP novoCEP = CEP(
                  objectId: '',
                  cep: cepController.text,
                  logradouro: logradouroController.text,
                  bairro: bairroController.text,
                  cidade: cidadeController.text,
                  numero: int.tryParse(numeroController.text),
                );

                cepProvider.cadastrarCEP(novoCEP);
                Navigator.of(context).pop();
              },
              child: const Text('Cadastrar'),
            ),
          ],
        );
      },
    );
  }

  void _editarCEP(BuildContext context, CEP cep) {
    showDialog(
      context: context,
      builder: (context) {
        final cepProvider = Provider.of<CEPProvider>(context, listen: false);
        TextEditingController cepController =
            TextEditingController(text: cep.cep);
        TextEditingController logradouroController =
            TextEditingController(text: cep.logradouro);
        TextEditingController bairroController =
            TextEditingController(text: cep.bairro);
        TextEditingController cidadeController =
            TextEditingController(text: cep.cidade);
        TextEditingController numeroController =
            TextEditingController(text: cep.numero?.toString() ?? '');

        return AlertDialog(
          title: const Text('Editar CEP'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: cepController,
                  decoration: const InputDecoration(labelText: 'CEP')),
              TextField(
                  controller: logradouroController,
                  decoration: const InputDecoration(labelText: 'Logradouro')),
              TextField(
                  controller: bairroController,
                  decoration: const InputDecoration(labelText: 'Bairro')),
              TextField(
                  controller: cidadeController,
                  decoration: const InputDecoration(labelText: 'Cidade')),
              TextField(
                  controller: numeroController,
                  decoration: const InputDecoration(labelText: 'Número')),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                CEP novoCEP = CEP(
                  objectId: cep.objectId,
                  cep: cepController.text,
                  logradouro: logradouroController.text,
                  bairro: bairroController.text,
                  cidade: cidadeController.text,
                  numero: int.tryParse(numeroController.text),
                );

                cepProvider.atualizarCEP(cep, novoCEP);
                Navigator.of(context).pop();
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  void _excluirCEP(BuildContext context, CEP cep) {
    showDialog(
      context: context,
      builder: (context) {
        final cepProvider = Provider.of<CEPProvider>(context, listen: false);

        return AlertDialog(
          title: const Text('Excluir CEP'),
          content: const Text('Tem certeza de que deseja excluir este CEP?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                cepProvider.excluirCEP(cep);
                Navigator.of(context).pop();
              },
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );
  }
}
