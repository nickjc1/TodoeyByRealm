//
//  ViewController.swift
//  Todoey
//
//  Created by CHAO JIANG on 5/23/18.
//  Copyright © 2018 nickjc1. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    // MARK: - Declare veriable here:
    
    var itemArray = [Item]()
    let theContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    // MARK: - viewdidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Do any additional setup after loading the view, typically from a nib.
        
        //find the path to where the data is stored in your device:
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        loadItems()
        
        
    }

    //MARK: - TableView DataSource Methods
    
    //Declare cellForRowAtIndexPath here:
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        //ternery operator to rewrite code:
        cell.accessoryType = item.isChecked ? .checkmark : .none
        
        return cell;
    }

    //Declare numOfRowsInSection here:
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count;
    }
    
    //MARK: - TableView Delegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        theContext.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        //update ischecked attribute method1:
        let ischecked : Bool = itemArray[indexPath.row].isChecked
        itemArray[indexPath.row].setValue(!ischecked, forKey: "isChecked")

        //update ischecked attribute method2:
//      itemArray[indexPath.row].isChecked = !itemArray[indexPath.row].isChecked
        
        tableView.deselectRow(at: indexPath, animated: true)
        saveItems()
        
    }
    
    //MARK: - addButtonPressed method
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        //declare a local variable:
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let addItemAction = UIAlertAction(title: "Add Item", style: .default) {(action) in
            
            let item = Item(context: self.theContext)
            item.title = textField.text!
            item.isChecked = false
            item.parentCategory = self.selectedCategory
            self.itemArray.append(item)
            
            self.saveItems()
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
    
    func saveItems() {
        
        do {
            try theContext.save()
        } catch {
            print("error save item array \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest(), and predicate: NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", (selectedCategory?.name)!)
        
        if let searchPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, searchPredicate])
        }else {
            request.predicate = categoryPredicate
        }
        
        do {
            itemArray = try theContext.fetch(request)
        } catch {
            print("error fetch item array \(error)")
        }
        
        tableView.reloadData()
    }
}

//MARK: - Search Bar Methods

extension TodoListViewController : UISearchBarDelegate {
    
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//
//        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        loadItems(with: request)
//
//    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        if(searchBar.text?.count == 0) {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        } else {
            loadItems(with: request, and: predicate)
        }
    }
}
