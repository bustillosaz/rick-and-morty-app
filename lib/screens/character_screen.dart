import 'package:flutter/material.dart';
import 'package:rickandmortyapp/models/character_model.dart';

class CharacterScreen extends StatelessWidget {
  final Character character;
  const CharacterScreen({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(character.name!),
      ),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: [
            SizedBox(
              height: 200,
              width: double.infinity,
              child: Hero(tag: character.id!, child: Image.network(character.image!)),
            )
          ],
        ),
      ),
    );
  }
}
