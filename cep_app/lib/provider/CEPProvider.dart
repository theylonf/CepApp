import 'package:cep_app/model/CEP.dart';
import 'package:cep_app/service/CEPService.dart';
import 'package:flutter/cupertino.dart';

class CEPProvider extends ChangeNotifier {
  List<CEP> ceps = [];
  final CEPService cepService = CEPService();

  Future<void> fetchCEPs() async {
    ceps = await cepService.fetchCEPs();
    notifyListeners();
  }

  Future<void> cadastrarCEP(CEP cep) async {
    await cepService.cadastrarCEP(cep);
    ceps.add(cep);
    notifyListeners();
  }

  Future<void> atualizarCEP(CEP cepAntigo, CEP novoCEP) async {
    await cepService.atualizarCEP(cepAntigo, novoCEP);
    final index = ceps.indexWhere((c) => c.objectId == cepAntigo.objectId);
    if (index != -1) {
      ceps[index] = novoCEP;
      notifyListeners();
    }
  }

  Future<void> excluirCEP(CEP cep) async {
    await cepService.excluirCEP(cep);
    ceps.remove(cep);
    notifyListeners();
  }
}