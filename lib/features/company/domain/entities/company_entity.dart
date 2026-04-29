class CompanyEntity {
  final String cnpj;
  final String name;
  final String server;
  final int port;
  final String status;
  final String seniorUser;
  final String seniorPassword;

  CompanyEntity({
    required this.cnpj,
    required this.name,
    required this.server,
    required this.port,
    required this.status,
    required this.seniorPassword,
    required this.seniorUser,
  });
}
