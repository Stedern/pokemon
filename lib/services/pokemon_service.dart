import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/pokemon.dart';

/// Sends requests to the PokéAPI and turns failures into clear messages.
class PokemonService {
  static const _baseUrl = 'https://pokeapi.co/api/v2/pokemon';

  Future<Pokemon> fetchPokemon(String name) async {
    final url = Uri.parse('$_baseUrl/$name');

    // 1. Network errors: no response received.
    final http.Response response;
    try {
      response = await http.get(url).timeout(const Duration(seconds: 10));
    } on TimeoutException {
      throw Exception('The request took too long. Please try again.');
    } on http.ClientException {
      throw Exception('No internet connection.');
    }

    // 2. HTTP errors: the server responded but not with 200 OK.
    if (response.statusCode == 404) {
      throw Exception('No Pokémon named "$name" was found.');
    }
    if (response.statusCode != 200) {
      throw Exception('Server error: ${response.statusCode}');
    }

    // 3. Data errors: invalid JSON or missing fields.
    try {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return Pokemon.fromJson(data);
    } catch (_) {
      throw Exception('Could not read the Pokémon data.');
    }
  }
}
