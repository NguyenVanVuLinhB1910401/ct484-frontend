import 'package:flashcard/components/FlashCardTile.dart';
import 'package:flashcard/models/AuthLogin.dart';
import 'package:flashcard/models/FlashCard.dart';
import 'package:flashcard/screens/FlashCardAddScreen.dart';
import 'package:flashcard/screens/LoginScreen.dart';
import 'package:flashcard/services/AuthService.dart';
import 'package:flashcard/services/FlashCardService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:flashcard/screens/FlashCardPlayScreen.dart';

class FlashCardsScreen extends StatefulWidget {
  const FlashCardsScreen({super.key});

  static final routeName = '/flashcards';

  @override
  State<FlashCardsScreen> createState() => _FlashCardsScreenState();
}

class _FlashCardsScreenState extends State<FlashCardsScreen> {
  bool showAll = true;
  MaterialStatePropertyAll<Color> unClickBackgroundColor =
      MaterialStatePropertyAll<Color>(Color.fromARGB(255, 234, 171, 171));
  MaterialStatePropertyAll<Color> clickingBackgroundColor =
      MaterialStatePropertyAll<Color>(Colors.red);
  String contentSearch = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Danh sách FlashCard",
        ),
        backgroundColor: Colors.green,
      ),
      backgroundColor: Colors.blue[200],
      drawer: Drawer(
        backgroundColor: Color.fromARGB(255, 131, 232, 135),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              height: 150,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.yellow,
                ),
                child: ListTile(
                  leading: Icon(
                    Icons.account_circle_sharp,
                    size: 40,
                    color: Colors.pink,
                  ),
                  title: Text(
                    context.read<AuthService>().isLogin
                        ? (context.read<AuthService>().getEmailUserLogined() ??
                            '')
                        : '',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.pink,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ListTile(
              leading: Icon(
                Icons.play_arrow_rounded,
                size: 40,
                color: Colors.pink,
              ),
              title: const Text(
                'Xem ngẫu nhiên 1 FlashCard',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.pink,
                ),
              ),
              onTap: () {
                Navigator.of(context).pushNamed(FlashCardPlayScreen.routeName);
              },
            ),
            SizedBox(
              height: 10,
            ),
            ListTile(
              leading: Icon(
                Icons.add,
                size: 30,
                color: Colors.pink,
              ),
              title: const Text(
                'Thêm 1 FlashCard',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.pink,
                ),
              ),
              onTap: () {
                Navigator.of(context).pushNamed(FlashCardAddScreen.routeName);
              },
            ),
            SizedBox(
              height: 10,
            ),
            ListTile(
              leading: Icon(
                Icons.logout,
                size: 30,
                color: Colors.pink,
              ),
              title: const Text(
                'Đăng xuất',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.pink,
                ),
              ),
              onTap: () {
                Navigator.of(context).pushReplacementNamed("/");
                context.read<AuthService>().logout();
              },
            ),
          ],
        ),
      ),
      body: OrientationBuilder(builder: (context, orientation) {
        return Column(
          children: [
            orientation == Orientation.portrait
                ? Column(
                    children: [
                      buildSearchInput(),
                      buildFavoriteTabs(),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: buildSearchInput(),
                      ),
                      Expanded(
                        flex: 1,
                        child: buildFavoriteTabs(),
                      ),
                    ],
                  ),
            Consumer<FlashCardService>(
              builder: (context, flashCardService, child) {
                return FutureBuilder(
                    future: showAll
                        ? flashCardService.fetchFlashCards()
                        : flashCardService.fetchFlashCardsFavorited(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Container(
                          margin: EdgeInsets.all(10),
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: Colors.yellow,
                            ),
                          ),
                        );
                      } else {
                        List<FlashCard> flashCards = contentSearch == ""
                            ? context.read<FlashCardService>().flashCards
                            : context
                                .read<FlashCardService>()
                                .flashCards
                                .where((flashCard) =>
                                    flashCard.word.contains(contentSearch))
                                .toList();

                        return Expanded(
                          child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount:
                                  orientation == Orientation.portrait ? 1 : 2,
                              childAspectRatio: 4 / 1,
                            ),
                            itemCount: flashCards.length,
                            itemBuilder: (context, index) {
                              return FlashCardTile(
                                  flashCard: flashCards[index]);
                            },
                          ),
                        );
                      }
                    });
              },
            ),
          ],
        );
      }),
    );
  }

  Widget buildSearchInput() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 8,
        right: 8,
        bottom: 8,
        top: 16,
      ),
      child: TextFormField(
        initialValue: contentSearch,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: "Search",
          hintText: "Search",
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
        onChanged: (text) {
          setState(() {
            contentSearch = text;
          });
        },
      ),
    );
  }

  Widget buildFavoriteTabs() {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              style: ButtonStyle(
                backgroundColor:
                    showAll ? clickingBackgroundColor : unClickBackgroundColor,
              ),
              onPressed: () {
                setState(() {
                  showAll = true;
                });
              },
              child: Text(
                "Tất cả",
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              style: ButtonStyle(
                backgroundColor:
                    showAll ? unClickBackgroundColor : clickingBackgroundColor,
              ),
              onPressed: () {
                setState(() {
                  showAll = false;
                });
              },
              child: Text(
                "Yêu thích",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
