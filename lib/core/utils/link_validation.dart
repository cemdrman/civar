/// Matches http(s):// / www. prefixes and bare domain-looking strings
/// (e.g. "example.com", "insta.gr/abc") so bios can't smuggle in a link.
final _linkPattern = RegExp(
  r'(https?:\/\/|www\.)|\b[a-zA-Z0-9-]+\.(com|net|org|io|co|tr|dev|app|me|xyz|info|link|gg|ly)\b',
  caseSensitive: false,
);

bool containsLink(String text) => _linkPattern.hasMatch(text);
