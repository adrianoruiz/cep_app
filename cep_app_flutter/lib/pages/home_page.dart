import 'dart:math';

import 'package:cep_app/models/endereco_model.dart';
import 'package:cep_app/repositories/cep_repository.dart';
import 'package:cep_app/repositories/cep_repository_impl.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CepRepository cepRepository = CepRepositoryImpl();

  bool loading = false;
  EnderecoModel? enderecoModel;
  final formKey = GlobalKey<FormState>();
  final cepEC = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    cepEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar CEP'),
      ),
      body: SingleChildScrollView(
          child: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Column(
            children: [
              TextFormField(
                controller: cepEC,
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return 'O campo nao pode ser vazio';
                  }
                  return null;
                },
              ),
              Visibility(
                  visible: loading, child: const CircularProgressIndicator()),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        loading = true;
                      });
                      final valid = formKey.currentState?.validate() ?? false;
                      if (valid) {
                        try {
                          final endereco =
                              await cepRepository.getCep(cepEC.text);
                          print(endereco);
                          setState(() {
                            loading = false;
                            enderecoModel = endereco;
                          });
                        } catch (e) {
                          setState(() {
                            enderecoModel = null;
                            loading = false;
                          });
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('Não foi possível consultar o cep'),
                          ));
                        }
                      }
                    },
                    child: const Text('Buscar')),
              ),
              Visibility(
                  visible: enderecoModel != null,
                  child: Text(
                      'Logradouro ${enderecoModel?.logradouro} complemento: ${enderecoModel?.complemento} cep: ${enderecoModel?.cep}'))
            ],
          ),
        ),
      )),
    );
  }
}
