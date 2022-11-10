import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todolist/pages/three_page.dart';
import 'package:todolist/pages/two_page.dart';

import '../models/item.dart';

// ignore: must_be_immutable
class TodoListPage extends StatefulWidget {
  TodoListPage({Key? key}) : super(key: key);

  var items = <Item>[];

  // TodoListPage() {
  //    items = [];
  //   items.add(Item(title: "ITEM 1", done: true));
  //   items.add(Item(title: "ITEM 2", done: false));
  //   items.add(Item(title: "ITEM 3", done: true));
  // }

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  var textEditingController = TextEditingController();
  final PageController _controladorPagina = PageController();

  int indexBottonNavigationBar = 0;

  setPaginaAtual(page) {
    //controlador  Navegação com PageView, Bottom Navigation e Animações
    setState(() {
      indexBottonNavigationBar = page;
    });
  }

  void add() {
    if (textEditingController.text.isEmpty) return;
    setState(() {
      widget.items.add(Item(
        title: textEditingController.text,
        done: false,
      ));
      textEditingController.clear();
      save(); //ou //textEditingController.text="";
    });
  }

  void remove(int index) {
    setState(() {
      widget.items.removeAt(index);
      save();
    });
  }

  Future load() async {
    // ignore: invalid_use_of_visible_for_testing_member
    SharedPreferences.setMockInitialValues({});
    var prefs = await SharedPreferences.getInstance();
    var data = prefs.getString('data');
    if (data != null) {
      Iterable decoded = jsonDecode(data);
      List<Item> result = decoded.map((e) => Item.fromJson(e)).toList();
      setState(() {
        widget.items = result;
      });
    }
  }

  save() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString("data", jsonEncode(widget.items));
    print("$prefs");
  }

  _TodoListPageState() {
    load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("C.R.U.Dismissible"),
      ),
      drawer: const Drawer(),
      body: PageView(
        onPageChanged: setPaginaAtual,
        controller: _controladorPagina,
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: <Widget>[
                TextField(
                  autofocus: true,
                  keyboardType: TextInputType.text,
                  controller: textEditingController,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                  decoration:
                      const InputDecoration(labelText: "Adicione Item:"),
                ),
                SizedBox(
                  height: 350,
                  child: ListView.builder(
                    itemCount: widget.items.length,
                    itemBuilder: (context, int index) {
                      int reversedIndex =
                          widget.items.length - 1 - index; //inversor de lista
                      final item = widget.items[reversedIndex];
                      return Dismissible(
                        background: Container(
                          padding: const EdgeInsets.only(left: 10),
                          alignment: Alignment.centerLeft,
                          color: Colors.red.withOpacity(0.2),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                        onDismissed: (direction) {
                          setState(
                            () {
                              if (direction == DismissDirection.startToEnd) {
                                remove(reversedIndex);
                                save();
                                // ignore: avoid_print
                                print("Deletado para DIREITA");
                              } else {
                                remove(reversedIndex);
                                save();
                                // ignore: avoid_print
                                print("Deletado para ESQUERDA");
                              }
                            },
                          );

                          final snackBar = SnackBar(
                            content: Text("jjjjj foi deletado"),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        },
                        key: Key(item.title),
                        child: CheckboxListTile(
                          title: Text(item.title),
                          value: item.done,
                          onChanged: (value) {
                            setState(
                              () {
                                item.done = value!;
                                save();
                              },
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          twoPage(),
          threePage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: indexBottonNavigationBar,
        onTap: (int page) {
          setState(() {
            indexBottonNavigationBar = page;
          });
          _controladorPagina.animateToPage(page,
              duration: const Duration(milliseconds: 400), curve: Curves.ease);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: "Listas Salvas",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.archive),
            label: "Salvar",
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: add,
        child: const Icon(Icons.add),
      ),
    );
  }
}
