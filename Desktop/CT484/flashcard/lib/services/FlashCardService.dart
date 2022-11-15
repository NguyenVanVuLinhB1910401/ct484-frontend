import 'dart:io';

import 'package:flashcard/models/AuthLogin.dart';
import 'package:flashcard/models/FlashCard.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FlashCardService with ChangeNotifier {
  List<FlashCard> flashCards = [];

  Future<List<FlashCard>> fetchFlashCards() async {
    try {
      String url =
          "http://10.0.2.2:3000/api/flashCard?email=" + (AuthLogin.email ?? '');
      Uri uri = Uri.parse(url);
      var res = await http.get(uri);
      print(res);
      print("..........................................");
      print(FlashCard.fromListJson(jsonDecode(res.body) as List<FlashCard>));
      flashCards =
          FlashCard.fromListJson(jsonDecode(res.body) as List<dynamic>);
    } catch (error) {
      flashCards = [];
    }
    print(flashCards);
    return flashCards;
  }

  Future<List<FlashCard>> fetchFlashCardsFavorited() async {
    try {
      String url = "http://10.0.2.2:3000/api/flashCard/favorite?email=" +
          (AuthLogin.email ?? '');
      Uri uri = Uri.parse(url);
      var res = await http.get(uri);
      flashCards =
          FlashCard.fromListJson(jsonDecode(res.body) as List<dynamic>);
    } catch (error) {
      flashCards = [];
    }

    return flashCards;
  }

  int get length {
    return this.flashCards.length;
  }

  int get lengthFavorited {
    return this
        .flashCards
        .where((flashCard) => flashCard.isFavorite)
        .toList()
        .length;
  }

  FlashCard getFlashCardByIndex(int index) {
    return flashCards[index];
  }

  FlashCard? getFlashCardById(String id) {
    return flashCards.firstWhere((flashCard) => flashCard.id == id);
  }

  void deleteFlashCardById(String id) async {
    String url = "http://10.0.2.2:3000/api/flashCard/" + id;
    Uri uri = Uri.parse(url);

    await http.delete(uri);

    flashCards.removeWhere((flashCard) => flashCard.id == id);
    notifyListeners();
  }

  void addFlashCard(FlashCard flashCard) async {
    String url =
        "http://10.0.2.2:3000/api/flashCard?email=" + (AuthLogin.email ?? '');
    Uri uri = Uri.parse(url);

    final flashCardJson = await http.post(
      uri,
      body: json.encode(flashCard.toJson()),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      },
    );

    FlashCard flashCardResponse = FlashCard.fromJson(
        json.decode(flashCardJson.body) as Map<String, dynamic>);
    this.flashCards.add(flashCardResponse);
    notifyListeners();
  }

  void updateFlashCard(FlashCard newFlashCard) async {
    String url = "http://10.0.2.2:3000/api/flashCard/" +
        newFlashCard.id +
        "?email=" +
        (AuthLogin.email ?? '');
    Uri uri = Uri.parse(url);

    final flashCardJson = await http.put(
      uri,
      body: json.encode(newFlashCard.toJson()),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      },
    );

    for (var i = 0; i < flashCards.length; i++) {
      if (flashCards[i].id == newFlashCard.id) {
        flashCards[i].word = newFlashCard.word;
        flashCards[i].meaning = newFlashCard.meaning;
        flashCards[i].example = newFlashCard.example;
        flashCards[i].isFavorite = newFlashCard.isFavorite;
      }
    }

    notifyListeners();
  }

  void toggleFlashCardFavorite(String id) async {
    String url = "http://10.0.2.2:3000/api/flashCard/favorite/" + id;
    Uri uri = Uri.parse(url);

    http.put(uri);
  }
}
