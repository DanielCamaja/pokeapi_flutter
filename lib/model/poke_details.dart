class Pokedata {
  final List<FlavorTextEntry> pokedata;

  Pokedata({
    required this.pokedata,
  });

  factory Pokedata.fromJson(Map<String, dynamic> json) {
    return Pokedata(
      pokedata: (json['flavor_text_entries'] as List)
          .map((entryJson) => FlavorTextEntry.fromJson(entryJson as Map<String, dynamic>))
          .toList(),
    );
  }
}

class FlavorTextEntry {
  final String flavorText;
  final Language language;
  final Version version;

  FlavorTextEntry({
    required this.flavorText,
    required this.language,
    required this.version,
  });

  factory FlavorTextEntry.fromJson(Map<String, dynamic> json) {
    return FlavorTextEntry(
      flavorText: json['flavor_text'],
      language: Language.fromJson(json['language'] as Map<String, dynamic>),
      version: Version.fromJson(json['version'] as Map<String, dynamic>),
    );
  }
}

class Language {
  final String name;
  final String url;

  Language({
    required this.name,
    required this.url,
  });

  factory Language.fromJson(Map<String, dynamic> json) {
    return Language(
      name: json['name'],
      url: json['url'],
    );
  }
}

class Version {
  final String name;
  final String url;

  Version({
    required this.name,
    required this.url,
  });

  factory Version.fromJson(Map<String, dynamic> json) {
    return Version(
      name: json['name'],
      url: json['url'],
    );
  }
}
