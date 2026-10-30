/// Data model for one Pokémon (reuses the JSON-to-model idea from the
/// previous lesson).
class Pokemon {
  final int id;
  final String name;
  final int height; // decimetres
  final int weight; // hectograms
  final String imageUrl;
  final List<String> types;
  final List<String> abilities;
  final Map<String, int> stats;
  final List<String> moves; // e.g. "slash (Lv 24)"

  const Pokemon({
    required this.id,
    required this.name,
    required this.height,
    required this.weight,
    required this.imageUrl,
    required this.types,
    required this.abilities,
    required this.stats,
    required this.moves,
  });

  /// Converts the decoded JSON map into a Pokemon object.
  factory Pokemon.fromJson(Map<String, dynamic> json) {
    final sprites = json['sprites'] as Map<String, dynamic>;

    return Pokemon(
      id: json['id'] as int,
      name: json['name'] as String,
      height: json['height'] as int,
      weight: json['weight'] as int,
      // Large artwork if available, otherwise the small sprite.
      imageUrl: (sprites['other']?['official-artwork']?['front_default'] ??
              sprites['front_default'] ??
              '') as String,
      types: (json['types'] as List)
          .map((t) => t['type']['name'] as String)
          .toList(),
      abilities: (json['abilities'] as List)
          .map((a) => a['ability']['name'] as String)
          .toList(),
      stats: {
        for (final s in json['stats'] as List)
          s['stat']['name'] as String: s['base_stat'] as int,
      },
      moves: _levelUpMoves(json['moves'] as List),
    );
  }

  /// Keeps only the moves learned by level-up in Scarlet/Violet,
  /// sorted by level.
  static List<String> _levelUpMoves(List moves) {
    final result = <MapEntry<int, String>>[];
    for (final m in moves) {
      for (final v in m['version_group_details'] as List) {
        if (v['version_group']['name'] == 'scarlet-violet' &&
            v['move_learn_method']['name'] == 'level-up') {
          result.add(MapEntry(
            v['level_learned_at'] as int,
            m['move']['name'] as String,
          ));
        }
      }
    }
    result.sort((a, b) => a.key.compareTo(b.key));
    return result.map((e) => '${e.value} (Lv ${e.key})').toList();
  }
}
