import 'package:flutter/material.dart';

import '../models/pokemon.dart';
import '../services/pokemon_service.dart';
import '../widgets/pokemon_details.dart';

class PokemonScreen extends StatefulWidget {
  const PokemonScreen({super.key});

  @override
  State<PokemonScreen> createState() => _PokemonScreenState();
}

class _PokemonScreenState extends State<PokemonScreen> {
  final _controller = TextEditingController(text: 'scyther');
  final _service = PokemonService();

  // Screen states: loading, error, success.
  bool _isLoading = false;
  String? _error;
  Pokemon? _pokemon;

  @override
  void initState() {
    super.initState();
    _search(); // Show Scyther when the app opens.
  }

  Future<void> _search() async {
    // Prevent repeated submissions while a request is in progress.
    if (_isLoading) return;

    final name = _controller.text.trim().toLowerCase();
    if (name.isEmpty) {
      setState(() => _error = 'Please enter a Pokémon name.');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
      _pokemon = null;
    });

    try {
      final pokemon = await _service.fetchPokemon(name);
      if (mounted) setState(() => _pokemon = pokemon);
    } catch (e) {
      if (mounted) {
        setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pokémon Lookup')),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    enabled: !_isLoading,
                    onSubmitted: (_) => _search(),
                    decoration: const InputDecoration(
                      hintText: 'Enter a Pokémon name',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: _isLoading ? null : _search, // disabled while loading
                  child: const Text('Search'),
                ),
              ],
            ),
          ),

          // Result
          Expanded(child: _buildResult()),
        ],
      ),
    );
  }

  Widget _buildResult() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(_error!, textAlign: TextAlign.center),
        ),
      );
    }
    if (_pokemon != null) {
      return PokemonDetails(pokemon: _pokemon!);
    }
    return const SizedBox.shrink();
  }
}
