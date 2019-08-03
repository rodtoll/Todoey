//
//  ViewController.swift
//  Todoey
//
//  Created by Rod Toll on 8/3/19.
//  Copyright © 2019 Rod Toll. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var initialItems = ["Find Mike", "Buy Eggos", "Destroy Demogorgon"]
    var itemArray = [Item]()
    
//    var userDefaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()

        for index in 0...(initialItems.count-1) {
            let newItem = Item()
            newItem.todoText = initialItems[index]
            newItem.checked = false
            itemArray.append(newItem)
        }
        
        //if let items  = userDefaults.array(forKey: "TodoListArray") as? [String] {
        //    itemArray = items
        //}
        
        //userDefaults["TodoListArray"]
        // Do any additional setup after loading the view.
    }
    
    //MARK - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].todoText
        cell.accessoryType = itemArray[indexPath.row].checked ? .checkmark : .none
        
        return cell
    }
    
    //MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].checked = !itemArray[indexPath.row].checked
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }

    //MARK - Add new item

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField: UITextField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            let newItem = Item()
            newItem.checked = false
            newItem.todoText = textField.text!
            self.itemArray.append(newItem)
//            self.itemArray.append(textField.text!)
//            self.userDefaults.set(self.itemArray, forKey: "TodoListArray")
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            print(alertTextField.text!)
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
}

