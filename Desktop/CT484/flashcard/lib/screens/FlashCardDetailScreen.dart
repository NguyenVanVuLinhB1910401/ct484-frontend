import 'package:flashcard/models/FlashCard.dart';
import 'package:flashcard/screens/FlashCardAddScreen.dart';
import 'package:flashcard/screens/FlashCardPlayScreen.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

class FlashCardDetailScreen extends StatefulWidget {
  const FlashCardDetailScreen(this.flashCard, this.isRandom, {super.key});
  final FlashCard flashCard;
  final bool isRandom;
  static final routeName = '/flashcard-detail';
  @override
  State<FlashCardDetailScreen> createState() => _FlashCardDetailScreenState();
}

class _FlashCardDetailScreenState extends State<FlashCardDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("FlashCard's Detail"),
      ),
      backgroundColor: Colors.blue[200],
      body: ListView(
        children: [
          Container(
            margin: EdgeInsets.only(left: 20, top: 20),
            child: Text(
              'Word:',
              style: TextStyle(fontSize: 30),
            ),
          ),
          Container(
            color: Color.fromARGB(255, 166, 156, 160),
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.all(10),
            alignment: Alignment.center,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                widget.flashCard.word,
                style: TextStyle(fontSize: 80, color: Colors.yellow),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 20),
            child: Text(
              'Meaning:',
              style: TextStyle(fontSize: 30),
            ),
          ),
          Container(
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.all(10),
            color: Color.fromARGB(255, 166, 163, 156),
            alignment: Alignment.center,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                widget.flashCard.meaning,
                style: TextStyle(fontSize: 50, color: Colors.yellow),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 20),
            child: Text(
              'Example:',
              style: TextStyle(fontSize: 30),
            ),
          ),
          Container(
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.all(10),
            color: Color.fromARGB(255, 166, 163, 156),
            child: Text(
              widget.flashCard.example ?? "",
              style: TextStyle(fontSize: 35, color: Colors.yellow),
            ),
          ),
          SizedBox(height: 10),
          widget.isRandom
              ? TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.of(context)
                        .pushNamed(FlashCardPlayScreen.routeName);
                  },
                  style: TextButton.styleFrom(
                    textStyle: TextStyle(
                      fontSize: 30,
                    ),
                    backgroundColor: Colors.green,
                  ),
                  child: Text("Next word ->"))
              : TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.of(context).pushNamed(
                      FlashCardAddScreen.routeName,
                      arguments: widget.flashCard.id,
                    );
                  },
                  child: Text('Update'),
                ),
          SizedBox(
            height: 10,
            width: double.infinity,
          ),
        ],
      ),
      floatingActionButton: ValueListenableBuilder<bool>(
          valueListenable: widget.flashCard.isFavoriteListenable,
          builder: (context, isFavorite, child) {
            return FloatingActionButton.large(
              backgroundColor:
                  isFavorite == true ? Colors.red[200] : Colors.white,
              child: Icon(
                isFavorite == true ? Icons.favorite : Icons.favorite_border,
                color: Colors.red,
                size: 50,
              ),
              onPressed: () {
                widget.flashCard.isFavorite = !isFavorite;
              },
            );
          }),
    );
  }
}
