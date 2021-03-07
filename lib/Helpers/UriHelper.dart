class UriHelper {
  UriHelper();
  Uri _uri = Uri.http('192.168.43.174:8000', '/api/books');

  get uri => _uri;
}
