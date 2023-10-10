class CEP {
  String objectId;
  String cep;
  String logradouro;
  String bairro;
  String cidade;
  int? numero;

  CEP({
    required this.objectId,
    required this.cep,
    required this.logradouro,
    required this.bairro,
    required this.cidade,
    this.numero,
  });
}