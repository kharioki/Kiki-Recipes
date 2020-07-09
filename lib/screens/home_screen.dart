import 'dart:convert';

import 'package:Kiki_Recipes/models/recipe.dart';
import 'package:Kiki_Recipes/screens/recipe_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Recipe> recipes = new List<Recipe>();

  TextEditingController textEditingController = new TextEditingController();

  // Edaman variables
  String applicationID = 'faa82759';
  String applicationKey = '3eaad079d2a0e181b0633fb2a40afabd';

  getRecipes(String query) async {
    String url =
        "https://api.edamam.com/search?q=$query&app_id=${applicationID}&app_key=${applicationKey}";

    var response = await http.get(url);

    Map<String, dynamic> jsonData = jsonDecode(response.body);

    jsonData["hits"].forEach((element) {
      Recipe recipe = new Recipe();
      recipe = Recipe.fromMap(element['recipe']);
      // save into our list of recipes
      recipes.add(recipe);

      setState(() {
        recipes = recipes;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: FractionalOffset.topRight,
                end: FractionalOffset.bottomLeft,
                colors: [
                  const Color(0xFF020024),
                  const Color(0xFF09796B),
                ], // whitish to gray
                tileMode:
                    TileMode.repeated, // repeats the gradient over the canvas
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 60, horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Kikis',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Text(
                        'Recipes',
                        style: TextStyle(
                          color: Color(0xFF09796B),
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  Text(
                    'What would you like to cook today?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Just enter the ingredients you have and we will show the best recipe for you.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 30),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: textEditingController,
                            decoration: InputDecoration(
                              hintText: 'Enter Ingredient',
                              hintStyle: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                              ),
                            ),
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ),
                        SizedBox(width: 16),
                        InkWell(
                          onTap: () async {
                            if (textEditingController.text.isNotEmpty) {
                              // recipes = new List();

                              // String url =
                              //     "https://api.edamam.com/search?q=${textEditingController.text}&app_id=${applicationID}&app_key=${applicationKey}";

                              // var response = await http.get(url);

                              // Map<String, dynamic> jsonData =
                              //     jsonDecode(response.body);

                              // jsonData["hits"].forEach((element) {
                              //   Recipe recipe = new Recipe();
                              //   recipe = Recipe.fromMap(element['recipe']);
                              //   // save into our list of recipes
                              //   recipes.add(recipe);
                              // });
                              getRecipes(textEditingController.text);

                              print('yeah');
                            } else {
                              print('nah');
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.search,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                  Container(
                    child: GridView(
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          mainAxisSpacing: 10.0,
                          maxCrossAxisExtent: 200.0,
                        ),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        physics: ClampingScrollPhysics(),
                        children: List.generate(recipes.length, (index) {
                          return GridTile(
                            child: RecipeTile(
                              title: recipes[index].label,
                              imgUrl: recipes[index].image,
                              url: recipes[index].url,
                              desc: recipes[index].source,
                            ),
                          );
                        })),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RecipeTile extends StatefulWidget {
  final String title, desc, imgUrl, url;

  RecipeTile({this.title, this.desc, this.imgUrl, this.url});

  @override
  _RecipieTileState createState() => _RecipieTileState();
}

class _RecipieTileState extends State<RecipeTile> {
  _launchURL(String url) async {
    print(url);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            if (kIsWeb) {
              _launchURL(widget.url);
            } else {
              print(widget.url + " this is what we are going to see");
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RecipeScreen(postUrl: widget.url),
                ),
              );
            }
          },
          child: Container(
            margin: EdgeInsets.all(8),
            child: Stack(
              children: <Widget>[
                Image.network(
                  widget.imgUrl,
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                ),
                Container(
                  width: 200,
                  alignment: Alignment.bottomLeft,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.white30, Colors.white],
                          begin: FractionalOffset.centerRight,
                          end: FractionalOffset.centerLeft)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.title,
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.black54,
                              fontFamily: 'Overpass'),
                        ),
                        Text(
                          widget.desc,
                          style: TextStyle(
                              fontSize: 10,
                              color: Colors.black54,
                              fontFamily: 'Overpass'),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
