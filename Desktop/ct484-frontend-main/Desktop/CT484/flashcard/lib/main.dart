import 'package:flashcard/models/FlashCard.dart';
import 'package:flashcard/screens/LoginScreen.dart';
import 'package:flashcard/screens/FlashCardAddScreen.dart';
import 'package:flashcard/screens/FlashCardPlayScreen.dart';
import 'package:flashcard/screens/FlashCardsScreen.dart';
import 'package:flashcard/screens/SignupScreen.dart';
import 'package:flashcard/services/AuthService.dart';
import 'package:flashcard/services/FlashCardService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:flashcard/screens/FlashCardDetailScreen.dart';
import 'package:flashcard/FlashCardDetailArguments.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => FlashCardService(),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthService(),
        ),
      ],
      child: Consumer<AuthService>(builder: (context, authService, child) {
        return GetMaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: authService.isLogin ? FlashCardsScreen() : LoginScreen(),
          routes: {
            LoginScreen.routeName: (context) => LoginScreen(),
            SignupScreen.routeName: (context) => SignupScreen(),
            FlashCardsScreen.routeName: (context) => FlashCardsScreen(),
            FlashCardPlayScreen.routeName: (context) => FlashCardPlayScreen(),
          },
          onGenerateRoute: (settings) {
            if (settings.name == FlashCardDetailScreen.routeName) {
              final args = settings.arguments as FlashCardDetailArguments;
              return MaterialPageRoute(
                builder: (context) {
                  FlashCard flashCard = FlashCard(
                    id: '',
                    word: '',
                    meaning: '',
                    example: '',
                    isFavorite: false,
                  );
                  if (args.id != null) {
                    FlashCard? result = context
                        .read<FlashCardService>()
                        .getFlashCardById(args.id);
                    if (result != null) {
                      flashCard = result;
                    }
                  }
                  return FlashCardDetailScreen(flashCard, args.isRandom);
                },
              );
            } else if (settings.name == FlashCardAddScreen.routeName) {
              final flashCardId = settings.arguments as String?;
              return MaterialPageRoute(
                builder: (context) {
                  FlashCard flashCard = FlashCard(
                    id: '',
                    word: '',
                    meaning: '',
                    example: '',
                    isFavorite: false,
                  );
                  if (flashCardId != null) {
                    FlashCard? result = context
                        .read<FlashCardService>()
                        .getFlashCardById(flashCardId);
                    if (result != null) {
                      flashCard = result;
                    }
                  }
                  return FlashCardAddScreen(flashCard);
                },
              );
            }
            return null;
          },
        );
      }),
    );
  }
}
