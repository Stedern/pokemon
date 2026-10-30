# pokemon – Pokémon Lookup

IT 126 – Module 3, Lesson 4: Communicating with Services (Application activity)

A Flutter app that extends the previous Pokémon activity. Instead of using a JSON map in the source code, it retrieves Pokémon information from the [PokéAPI](https://pokeapi.co).

## Features

- A text field where the user enters a Pokémon name (opens with **scyther** already loaded)
- An HTTP GET request to `https://pokeapi.co/api/v2/pokemon/{name}`
- Displays the image, name, ID, types, height, weight, abilities, base stats, and level-up moves (Scarlet/Violet)
- A loading indicator while the request is in progress
- Clear error messages when a request fails or the data cannot be read
- The Search button and text field are disabled during a request, so repeated submissions cannot happen

## Project structure

```
lib/
├── main.dart                      # App entry point
├── models/pokemon.dart            # Pokemon data model + fromJson
├── services/pokemon_service.dart  # HTTP GET request and error handling
├── screens/pokemon_screen.dart    # Search bar and loading/error/success states
└── widgets/pokemon_details.dart   # Displays the Pokémon details
```

## How the app handles requests

**Successful requests.** The service sends a GET request with the `http` package. If the status code is `200`, the body is decoded with `jsonDecode()` from `dart:convert` and converted into a `Pokemon` object with `Pokemon.fromJson()`. The screen then shows the details.

**Unsuccessful responses.** If the server responds with `404 Not Found`, the app shows "No Pokémon named ... was found." Any other non-200 status shows "Server error: [code]". The response body is not processed in either case.

**Network failures.** If no response is received (no internet or server unreachable), the `http` package throws a `ClientException` and the app shows "No internet connection." Requests taking longer than 10 seconds show a timeout message. The user can press Search again to retry.

**Invalid data.** If the body is not valid JSON, or a required field is missing or has the wrong type, the app shows "Could not read the Pokémon data." instead of crashing or showing incomplete information.

## Proposed offline strategy

Offline storage is not implemented in this activity. It could be added like this:

1. After every successful request, save the JSON response locally (for example with `shared_preferences`), using the Pokémon name as the key, together with the time it was saved.
2. When a request fails because of a network error, load the saved JSON for that Pokémon and display it with a note such as "Showing saved data. It may be outdated."
3. Let the user search again to refresh when the connection returns.
4. A `404` should not fall back to saved data, because the server has confirmed the Pokémon does not exist.

Pokémon data rarely changes, so saved information stays accurate for a long time.

## Running the app

```
flutter pub get
flutter run -d chrome
```

Try `scyther`, `pikachu`, or `charizard` for successful lookups, and `thispokemondoesnotexist` to see the 404 handling.
