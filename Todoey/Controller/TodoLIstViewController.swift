//
//  ViewController.swift
//  Todoey
//
//  Created by CHAO JIANG on 5/23/18.
//  Copyright © 2018 nickjc1. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {

    // MARK: - Declare veriable here:
    
    let realm = try! Realm()
    
    var todoItems : Results<Item>?
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    // MARK: - viewdidLoad()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadItems()
    }

    //MARK: - TableView DataSource Methods
    
    //Declare cellForRowAtIndexPath here:
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            //ternery operator to rewrite code:
            cell.accessoryType = item.isChecked ? .checkmark : .none
        }else {
            cell.textLabel?.text = "No Item Added Yet"
        }
        
        return cell;
    }

    //Declare numOfRowsInSection here:
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1;
    }
    
    //MARK: - TableView Delegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let item = todoItems?[indexPath.row] {
            do{
                try realm.write {
                    item.isChecked = !item.isChecked
                }
            }catch {
                print("error updating ischecked status \(error)")
            }
        }
        
        tableView.reloadData()
    }
    
    //MARK: - addButtonPressed method
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        //declare a local variable:
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let addItemAction = UIAlertAction(title: "Add Item", style: .default) {(action) in
            if let currentCatogery = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCatogery.items.append(newItem)
                    }
                }catch {
                    print("Error saving new item \(error)")
                }
            }
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) {
            (action) in
            print("dismiss")
        }
        
        alert.addAction(addItemAction)
        alert.addAction(cancelAction)
        
        alert.addTextField { (alertTextField) in
            print("add TextField into alert")  //test
            
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
            
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Model Manipulation Methods
    
    func loadItems() {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
}

//MARK: - Search Bar Methods

extension TodoListViewController : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        loadItems()
        
        if searchBar.text?.count == 0 {
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        } else {
            todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: false)
            tableView.reloadData()
        }
    }
}
