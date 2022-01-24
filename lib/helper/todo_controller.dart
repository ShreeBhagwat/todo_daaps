import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:todo_trial_dapp/modles/todo.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

class TodoController extends ChangeNotifier {
  List<Todo> todos = [];
  bool isLoading = true;
  late int todoCount;

  final String _rpcUrl = "http://127.0.0.1:7545";
  final String _wsUrl = "ws://127.0.0.1:7545/";

  final String _privateKey =
      "80b53d9cf43459fe12c97de0f9b9e658f504d86d001b8d22e5822d533022ca3a";

  late Web3Client _client;
  late String _abiCode;

  late Credentials _credentials;
  late EthereumAddress _contractAddress;

  late DeployedContract _contract;
  late ContractFunction _todoCount;
  late ContractFunction _todos;
  late ContractFunction _addTodo;
  late ContractFunction _deleteTodo;
  late ContractFunction _editTodo;
  late ContractEvent _todoAddedEvent;
  late ContractEvent _todoDeletedEvent;

  TodoController() {
    init();
  }

  init() async {
    _client = Web3Client(_rpcUrl, Client(), socketConnector: () {
      return IOWebSocketChannel.connect(_wsUrl).cast<String>();
    });

    await getAbi();
    await getCreadentials();
    await getDeployedContract();
  }

  Future<void> getAbi() async {
    String abiStringFile = await rootBundle
        .loadString("contracts/build/contracts/TodosContract.json");
    var jsonAbi = jsonDecode(abiStringFile);
    _abiCode = jsonEncode(jsonAbi['abi']);
    _contractAddress =
        EthereumAddress.fromHex(jsonAbi["networks"]["5777"]["address"]);
  }

  Future<void> getCreadentials() async {
    _credentials = await _client.credentialsFromPrivateKey(_privateKey);
  }

  Future<void> getDeployedContract() async {
    _contract = DeployedContract(
        ContractAbi.fromJson(_abiCode, "TodosContract"), _contractAddress);
    _todoCount = _contract.function("todoCount");
    _todos = _contract.function("todos");
    _addTodo = _contract.function("addTodo");
    _deleteTodo = _contract.function("deleteTodo");
    _editTodo = _contract.function("editTodo");

    _todoAddedEvent = _contract.event("TodoAdded");
    _todoDeletedEvent = _contract.event("TodoDeleted");
    await getTodo();
  }

  getTodo() async {
    List todoList = await _client
        .call(contract: _contract, function: _todoCount, params: []);
    BigInt totalTodos = todoList[0];
    todoCount = totalTodos.toInt();
    todos.clear();
    for (int i = 0; i < todoCount; i++) {
      var temp = await _client.call(
          contract: _contract, function: _todos, params: [BigInt.from(i)]);
      if (temp[1] != "") {
        todos.add(
          Todo(
            id: temp[0].toString(),
            title: temp[1],
            category: temp[2],
            created:
                DateTime.fromMillisecondsSinceEpoch(temp[3].toInt() * 1000),
          ),
        );
      }
    }
    isLoading = false;
    notifyListeners();
  }

  addTodo(Todo todo) async {
    isLoading = true;
    notifyListeners();
    await _client.sendTransaction(
      _credentials,
      Transaction.callContract(
        contract: _contract,
        function: _addTodo,
        parameters: [
          todo.title,
          todo.category,
          BigInt.from(todo.created.millisecondsSinceEpoch),
        ],
      ),
    );
    await getTodo();
  }

  deleteTodo(int id) async {
    isLoading = true;
    notifyListeners();
    await _client.sendTransaction(
      _credentials,
      Transaction.callContract(
        contract: _contract,
        function: _deleteTodo,
        parameters: [BigInt.from(id)],
      ),
    );
    await getTodo();
  }

  editTodo(Todo todo) async {
    isLoading = true;
    notifyListeners();
    await _client.sendTransaction(
      _credentials,
      Transaction.callContract(
        contract: _contract,
        function: _editTodo,
        parameters: [
          BigInt.from(int.parse(todo.id)),
          todo.title,
          todo.category
        ],
      ),
    );
    await getTodo();
  }
}
