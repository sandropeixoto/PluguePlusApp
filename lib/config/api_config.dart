/// Configuracoes usadas em producao para consumir o php-crud-api.
class ApiConfig {
  static const String baseUrl =
      'https://sspeixoto.com.br/api/api-plugueplus.php';

  /// Nomes das tabelas no php-crud-api (ajuste aqui se divergir).
  static const String categoriesTable = 'categories';
  static const String servicesTable = 'services';
  static const String chargersTable = 'charging_points';
  static const String postsTable = 'posts';
  static const String usersTable = 'users';
}
