import 'package:flutter/material.dart';

import '../models/pokemon.dart';

/// Shows the details of one Pokémon as plain text sections.
class PokemonDetails extends StatelessWidget {
  final Pokemon pokemon;

  const PokemonDetails({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      children: [
        if (pokemon.imageUrl.isNotEmpty)
          Image.network(
            pokemon.imageUrl,
            height: 180,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.broken_image, size: 80),
          ),
        const SizedBox(height: 8),
        Text(
          pokemon.name.toUpperCase(),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        Text(
          '#${pokemon.id}  ·  ${pokemon.types.join(' / ')}',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text('Height: ${pokemon.height / 10} m'),
        Text('Weight: ${pokemon.weight / 10} kg'),
        _Section(
          title: 'Abilities',
          lines: pokemon.abilities.map((a) => '- $a').toList(),
        ),
        _Section(
          title: 'Stats',
          lines: pokemon.stats.entries
              .map((s) => '${s.key}: ${s.value}')
              .toList(),
        ),
        _Section(
          title: 'Moves (level-up, Scarlet/Violet)',
          lines: pokemon.moves.isEmpty
              ? ['None listed for this game.']
              : pokemon.moves.map((m) => '- $m').toList(),
        ),
      ],
    );
  }
}

/// A bold title followed by one line of text per item.
class _Section extends StatelessWidget {
  final String title;
  final List<String> lines;

  const _Section({required this.title, required this.lines});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          for (final line in lines) Text(line),
        ],
      ),
    );
  }
}
