import 'dart:convert';
import 'package:cep_app/model/CEP.dart';
import 'package:dio/dio.dart';

class CEPService {
  final Dio dio = Dio();
  final String back4appUrl = 'https://parseapi.back4app.com/classes/Cep';

  Future<List<CEP>> fetchCEPs() async {
    try {
      final response = await dio.get(
        back4appUrl,
        options: Options(
          headers: {
            'X-Parse-Application-Id': '1PDp1RIBzSKEJ2W0l6LcGXtx0cpwaTmiWU5P2rjN',
            'X-Parse-REST-API-Key': '2q3JXpoQiTEF9QFDx0ePvjwLRqOA81grz5gH6tWX',
          },
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['results'];
        final List<CEP> cepsList = data.map((cepData) {
          return CEP(
            objectId: cepData['objectId'],
            cep: cepData['cep'],
            logradouro: cepData['logradouro'],
            bairro: cepData['bairro'],
            cidade: cepData['cidade'],
            numero: cepData['numero'],
          );
        }).toList();

        return cepsList;
      } else {
        print('Erro ao buscar CEPs no Back4App: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Erro ao buscar CEPs no Back4App: $e');
      return [];
    }
  }

  Future<void> cadastrarCEP(CEP cep) async {
    try {
      final response = await dio.post(
        back4appUrl,
        data: {
          'cep': cep.cep,
          'logradouro': cep.logradouro,
          'bairro': cep.bairro,
          'cidade': cep.cidade,
          'numero': cep.numero,
        },
        options: Options(
          headers: {
            'X-Parse-Application-Id': '1PDp1RIBzSKEJ2W0l6LcGXtx0cpwaTmiWU5P2rjN',
            'X-Parse-REST-API-Key': '2q3JXpoQiTEF9QFDx0ePvjwLRqOA81grz5gH6tWX',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 201) {
        print('CEP cadastrado com sucesso no Back4App');
      } else {
        print('Erro ao cadastrar CEP no Back4App: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao cadastrar CEP no Back4App: $e');
    }
  }

  Future<void> atualizarCEP(CEP cepAtual, CEP novoCEP) async {
    try {
      final response = await dio.put(
        '$back4appUrl/${cepAtual.objectId}',
        data: {
          'objectId': novoCEP.objectId,
          'cep': novoCEP.cep,
          'logradouro': novoCEP.logradouro,
          'bairro': novoCEP.bairro,
          'cidade': novoCEP.cidade,
          'numero': novoCEP.numero,
        },
        options: Options(
          headers: {
            'X-Parse-Application-Id': '1PDp1RIBzSKEJ2W0l6LcGXtx0cpwaTmiWU5P2rjN',
            'X-Parse-REST-API-Key': '2q3JXpoQiTEF9QFDx0ePvjwLRqOA81grz5gH6tWX',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        print('CEP atualizado com sucesso no Back4App');
      } else {
        print('Erro ao atualizar CEP no Back4App: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao atualizar CEP no Back4App: $e');
    }
  }

  Future<void> excluirCEP(CEP cep) async {
    try {
      final response = await dio.delete(
        '$back4appUrl/${cep.objectId}',
        options: Options(
          headers: {
            'X-Parse-Application-Id': '1PDp1RIBzSKEJ2W0l6LcGXtx0cpwaTmiWU5P2rjN',
            'X-Parse-REST-API-Key': '2q3JXpoQiTEF9QFDx0ePvjwLRqOA81grz5gH6tWX',
          },
        ),
      );

      if (response.statusCode == 200) {
        print('CEP excluído com sucesso do Back4App');
      } else {
        print('Erro ao excluir CEP do Back4App: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao excluir CEP do Back4App: $e');
    }
  }
}