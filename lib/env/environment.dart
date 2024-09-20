final class Environment {
  static const restApiUrl = String.fromEnvironment(
      'COUPLE_BOOK_INTEGRATION_API_URL',
      defaultValue: 'http://localhost:8080');
      // defaultValue: 'https://integration.couplebook.me');
}
