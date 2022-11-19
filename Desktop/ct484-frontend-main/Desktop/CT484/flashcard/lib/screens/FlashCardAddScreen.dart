import 'package:flashcard/models/FlashCard.dart';
import 'package:flashcard/services/FlashCardService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

class FlashCardAddScreen extends StatefulWidget {
  const FlashCardAddScreen(this.flashCard, {super.key});
  final FlashCard flashCard;
  static final routeName = '/flashcard-add';

  @override
  State<FlashCardAddScreen> createState() => _FlashCardAddScreenState();
}

class _FlashCardAddScreenState extends State<FlashCardAddScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.flashCard.id == ''
            ? Text("Add A Contact")
            : Text("Edit A Contact"),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
          child: ListView(
            children: [
              buildWordField(),
              SizedBox(
                height: 15,
              ),
              buildMeaningField(),
              SizedBox(
                height: 15,
              ),
              buildExampleField(),
              SizedBox(
                height: 20,
              ),
              buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  TextFormField buildWordField() {
    return TextFormField(
      initialValue: widget.flashCard.word,
      decoration: const InputDecoration(labelText: "Word"),
      textInputAction: TextInputAction.next,
      autofocus: true,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please provide a value.';
        }
        return null;
      },
      onSaved: (value) {
        widget.flashCard.word = value ?? '';
      },
    );
  }

  TextFormField buildMeaningField() {
    return TextFormField(
      initialValue: widget.flashCard.meaning,
      decoration: const InputDecoration(labelText: "Meaning"),
      textInputAction: TextInputAction.next,
      autofocus: true,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please provide a value.';
        }
        return null;
      },
      onSaved: (value) {
        widget.flashCard.meaning = value ?? '';
      },
    );
  }

  TextFormField buildExampleField() {
    return TextFormField(
      initialValue: widget.flashCard.example,
      decoration: const InputDecoration(labelText: "Example"),
      autofocus: true,
      maxLines: 3,
      onSaved: (value) {
        widget.flashCard.example = value ?? '';
      },
    );
  }

  ElevatedButton buildSaveButton() {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();
          if (widget.flashCard.id == '') {
            context.read<FlashCardService>().addFlashCard(widget.flashCard);
          } else {
            context.read<FlashCardService>().updateFlashCard(widget.flashCard);
          }
          Navigator.of(context).pop();
        }
      },
      child: const Text('Save'),
    );
  }
}
