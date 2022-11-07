import 'package:flutter/material.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({Key? key}) : super(key: key);

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final TextEditingController _textEditingController = TextEditingController();

  List<String> tarefas = []; //criação de lista

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("C.R.U.Dismissible"),
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(children: <Widget>[
            TextField(
              controller: _textEditingController,
            ),
            SizedBox(
              height: 400,
              child: ListView.separated(
                separatorBuilder: (context, index) => Divider(),
                itemCount: tarefas.length,
                itemBuilder: (context, index) {
                  final item = tarefas[index];
                  /*return ListTile(title: Text(tarefas[index]));*/
                  return Dismissible(
                    background: Container(
                      padding: EdgeInsets.only(left: 10),
                      alignment: Alignment.centerLeft,
                      color: Colors.red.withOpacity(0.8),
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    onDismissed: (direction) {
                      setState(() {
                        tarefas.removeAt(index);
                        print("REMOVIDO");
                      });
                      Scaffold.of(context).showSnackBar(
                        SnackBar(
                          content: Text("$item foi removido"),
                        ),
                      );
                    },
                    key: ValueKey(tarefas[index]),
                    child: ListTile(
                      title: Text(
                        tarefas[index],
                      ),
                    ),
                  );
                },
              ),
            ),
          ])),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          if (_textEditingController.text.isNotEmpty) {
            setState(() {
              tarefas.add(_textEditingController.text); // Add o item na lista
            });
            _textEditingController.clear();
          }
          //print(tarefas); //printa no console
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
