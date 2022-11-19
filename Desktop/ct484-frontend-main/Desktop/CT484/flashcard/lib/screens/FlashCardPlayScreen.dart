import 'package:flashcard/models/FlashCard.dart';
import 'package:flashcard/screens/FlashCardDetailScreen.dart';
import 'package:flashcard/services/FlashCardService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'package:flashcard/FlashCardDetailArguments.dart';

class FlashCardPlayScreen extends StatefulWidget {
  const FlashCardPlayScreen({super.key});

  static final routeName = '/flashcard-play';

  @override
  State<FlashCardPlayScreen> createState() => _FlashCardPlayScreenState();
}

class _FlashCardPlayScreenState extends State<FlashCardPlayScreen> {
  FlashCard? flashCard;

  void initState() {
    super.initState();
    FlashCardService flashCardService = context.read<FlashCardService>();
    flashCard = flashCardService
        .getFlashCardByIndex(Random().nextInt(flashCardService.length));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Play'),
        ),
        body: ListView(
          children: [
            Container(
              margin: EdgeInsets.only(top: 100),
              alignment: Alignment.center,
              child: Text(
                'Word:',
                style: TextStyle(fontSize: 30),
              ),
            ),
            Container(
                margin: EdgeInsets.only(top: 60),
                padding: EdgeInsets.all(10),
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(
                    flashCard?.word ?? "",
                    style: TextStyle(fontSize: 90, color: Colors.yellow),
                  ),
                )),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.of(context).pushNamed(
                  FlashCardDetailScreen.routeName,
                  arguments: FlashCardDetailArguments(flashCard?.id ?? "", true),
                );
              },
              child: Text('Show meaning'),
            )
          ],
        ));
  }
}
