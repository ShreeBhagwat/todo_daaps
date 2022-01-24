// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.4.22 <0.9.0;

contract TodosContract {
    uint256 public todoCount;

    struct Todos{
        uint256 id;
        string todoTitle;
        string todoCategory;
        uint256 timeStamp;
    }

    mapping(uint256 => Todos) public todos;

    constructor() public {
        todoCount = 0;
    }


    event TodoAdded(uint256 _id);
    event TodoDeleted(uint256 _id);
    event TodoEdited(uint256 _id);

    function addTodo(string memory _todoTitle, string memory _todoCategory, uint256 timeStamp) public {
        todos[todoCount] = Todos(
            todoCount,
            _todoTitle,
            _todoCategory,
            timeStamp
        );
        emit TodoAdded(todoCount);
        todoCount++;
    }

    function deleteTodo(uint256 _id) public {
        delete todos[_id];
        emit TodoDeleted(_id);
    }

    function editTodo(
        uint256 _id, string memory _todoTitle, string memory _todoCategory
    ) public {
        todos[_id] = Todos(_id, _todoTitle, _todoCategory, todos[_id].timeStamp);
        emit TodoAdded(_id);
    }
}