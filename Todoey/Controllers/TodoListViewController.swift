//
//  ViewController.swift
//  Todoey
//
//  Created by Rod Toll on 8/3/19.
//  Copyright © 2019 Rod Toll. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    let realm = try! Realm()
    
    var itemsList: Results<Item>?
    
    var selectedCategory: Category? {
        didSet {
            self.loadData()
        }
    }

    func loadData() {
        
        itemsList = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = self.selectedCategory!.title

        guard let colorHex = self.selectedCategory?.hexColor else { fatalError("Category without color") }
        
        setupNavBar(withHexColor: colorHex)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        setupNavBar(withHexColor: "0096FF")
    }
    
    func setupNavBar(withHexColor hexColor: String) {
        guard let navBar = navigationController?.navigationBar else { fatalError("Navbar doesn't resolve") }
        guard let backgroundColor = UIColor(hexString: hexColor) else { fatalError("Invalid color used for navbar background") }
        navBar.barTintColor = backgroundColor
        searchBar.barTintColor = backgroundColor
        navBar.tintColor = ContrastColorOf(backgroundColor, returnFlat: true)
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(backgroundColor, returnFlat: true)]
    }
    
    //MARK - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsList?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = itemsList?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
            let itemCount = itemsList?.count ?? 0
            let baseColor = UIColor(hexString: selectedCategory!.hexColor)!
            cell.backgroundColor = baseColor.darken(byPercentage: CGFloat(Double(indexPath.row)/Double(itemCount)) )
            cell.textLabel?.textColor = ContrastColorOf(cell.backgroundColor!, returnFlat: true)
        } else {
            cell.textLabel?.text = "No items found"
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    //MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = itemsList?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error updating done flag. Error: \(error)")
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }

    //MARK - Add new item

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField: UITextField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.done = false
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                        self.tableView.reloadData()
                    }
                } catch {
                    print("Error sending data: \(error)")
                }
            }
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            print(alertTextField.text!)
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let itemToDelete = self.itemsList?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(itemToDelete)
                }
            } catch {
                print("Error deleting it")
            }
        } else {
            print("Error finding category to delete")
        }
    }
    

}

//MARK - Search Bar
extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        itemsList = itemsList?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            loadData();

            DispatchQueue.main.async() {
                searchBar.resignFirstResponder()
            }
        }
    }
    
}

