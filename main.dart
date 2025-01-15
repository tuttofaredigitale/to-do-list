import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() {
  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-DoList Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TodoHomePage(),
    );
  }
}

class TodoHomePage extends StatefulWidget {
  const TodoHomePage({Key? key}) : super(key: key);

  @override
  _TodoHomePageState createState() => _TodoHomePageState();
}

class _TodoHomePageState extends State<TodoHomePage> {
  final TextEditingController _textController = TextEditingController();
  List<String> _todos = [];

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  // Carica i task salvati da SharedPreferences
  Future<void> _loadTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final String? todosString = prefs.getString('todos_key');
    if (todosString != null) {
      final List decodedList = jsonDecode(todosString);
      setState(() {
        _todos = decodedList.map((item) => item.toString()).toList();
      });
    }
  }

  // Salva i task correnti in SharedPreferences
  Future<void> _saveTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedList = jsonEncode(_todos);
    await prefs.setString('todos_key', encodedList);
  }

  // Aggiunge un nuovo task alla lista
  void _addTodo() {
    final newTask = _textController.text.trim();
    if (newTask.isNotEmpty) {
      setState(() {
        _todos.add(newTask);
      });
      _textController.clear();
      _saveTodos();
    }
  }

  // Rimuove un task dalla lista
  void _removeTodoAt(int index) {
    setState(() {
      _todos.removeAt(index);
    });
    _saveTodos();
  }

  // Gestione del riordino della lista
  void _reorderTodos(int oldIndex, int newIndex) {
    // Se l'elemento è rimosso prima di arrivare a una posizione successiva,
    // bisogna regolare la posizione "newIndex".
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    setState(() {
      final String item = _todos.removeAt(oldIndex);
      _todos.insert(newIndex, item);
    });
    _saveTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Progetto To-Do List'),
      ),
      body: Column(
        children: [
          // Sezione per l’inserimento di nuovi task
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      labelText: 'Aggiungi un nuovo task',
                    ),
                    onSubmitted: (_) => _addTodo(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addTodo,
                ),
              ],
            ),
          ),
          // Sezione che mostra la lista (riordinabile) dei task
          Expanded(
            child: ReorderableListView(
              onReorder: _reorderTodos,
              children: [
                for (int i = 0; i < _todos.length; i++)
                  Dismissible(
                    key: ValueKey(_todos[i]),
                    direction: DismissDirection.endToStart,
                    onDismissed: (_) {
                      _removeTodoAt(i);
                    },
                    background: Container(
                      color: Colors.redAccent,
                      alignment: Alignment.centerRight,
                      child: const Padding(
                        padding: EdgeInsets.only(right: 16.0),
                        child: Icon(Icons.delete, color: Colors.white),
                      ),
                    ),
                    child: ListTile(
                      key: ValueKey(_todos[i]), // Key unica per il riordino
                      title: Text(_todos[i]),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _removeTodoAt(i),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
