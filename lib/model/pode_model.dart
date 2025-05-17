class Pokemon {
  final int id;
  final String name;
  final int weight;
  final int height;
  final Sprites sprites;
  final List<Stat> stats;
  final List<Type> types;

  Pokemon({
    required this.id,
    required this.weight,
    required this.height,
    required this.name,
    required this.sprites,
    required this.stats,
    required this.types,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      id: json['id'],
      name: json['name'],
      weight: json['weight'],
      height: json['height'],
      sprites: Sprites.fromJson(json['sprites']),
      stats: (json['stats'] as List)
          .map((statJson) => Stat.fromJson(statJson as Map<String, dynamic>)) // Añadido casteo
          .toList(),
      types: (json['types'] as List)
          .map((typeJson) => Type.fromJson(typeJson as Map<String, dynamic>))  // Añadido casteo
          .toList(),
    );
  }
}

class Sprites {
  final Other? other;

  Sprites({this.other});

  factory Sprites.fromJson(Map<String, dynamic> json) {
    return Sprites(
      other: json['other'] != null ? Other.fromJson(json['other'] as Map<String, dynamic>) : null, // Añadido casteo
    );
  }
}

class Other {
  final Home? home;

  Other({this.home});

  factory Other.fromJson(Map<String, dynamic> json) {
    return Other(
      home: json['home'] != null ? Home.fromJson(json['home'] as Map<String, dynamic>) : null, // Añadido casteo
    );
  }
}

class Home {
  final String? frontDefault;

  Home({this.frontDefault});

  factory Home.fromJson(Map<String, dynamic> json) {
    return Home(
      frontDefault: json['front_default'],
    );
  }
}

class Stat {
  final int baseStat;
  final int effort;
  final StatName stat;

  Stat({
    required this.baseStat,
    required this.effort,
    required this.stat,
  });

  factory Stat.fromJson(Map<String, dynamic> json) {
    return Stat(
      baseStat: json['base_stat'],
      effort: json['effort'],
      stat: StatName.fromJson(json['stat'] as Map<String, dynamic>), // Añadido casteo
    );
  }
}

class StatName {
  final String name;
  final String url;

  StatName({
    required this.name,
    required this.url,
  });

  factory StatName.fromJson(Map<String, dynamic> json) {
    return StatName(
      name: json['name'],
      url: json['url'],
    );
  }
}

class Type {
  final int slot;
  final TypeName type;

  Type({
    required this.slot,
    required this.type,
  });

  factory Type.fromJson(Map<String, dynamic> json) {
    return Type(
      slot: json['slot'],
      type: TypeName.fromJson(json['type'] as Map<String, dynamic>), // Añadido casteo
    );
  }
}

class TypeName {
  final String name;
  final String url;

  TypeName({
    required this.name,
    required this.url,
  });

  factory TypeName.fromJson(Map<String, dynamic> json) {
    return TypeName(
      name: json['name'],
      url: json['url'],
    );
  }
}
