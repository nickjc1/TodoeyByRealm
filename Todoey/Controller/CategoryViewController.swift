//
//  CategoryViewController.swift
//  Todoey
//
//  Created by CHAO JIANG on 6/6/18.
//  Copyright © 2018 nickjc1. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableTableViewController {
    
    // MARK: - Declare veriable here:
    
    let realm = try! Realm()
    
    var categories: Results<Category>?

    // MARK: - viewDidLoad()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategory()
    }
    
    // MARK: - tableview datasource method:
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categories?[indexPath.row] {
            cell.backgroundColor = UIColor(hexString: category.backColor)
            cell.textLabel?.text = category.name
            cell.textLabel?.textColor = ContrastColorOf(cell.backgroundColor!, returnFlat: true)
        }
//      cell.textLabel?.text = categories?[indexPath.row].name ?? "No Category Added Yet"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (categories?.count)!
    }
    
    // MARK: - tableview delegate method:
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItem", sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    // MARK: - prepare segue method:
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    // MARK: - addbuttonPressed method:
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Cotegory", message: "", preferredStyle: .alert)
        let addItemAction = UIAlertAction(title: "Add", style: .default) { (action) in
            let theCategory = Category()
            
            let categoryName = textField.text
            theCategory.name = categoryName!
            
            theCategory.backColor = UIColor.randomFlat.hexValue()
            
            self.saveCategory(theCategory)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            print("dismiss")
        }
        
        alert.addAction(addItemAction)
        alert.addAction(cancelAction)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Category"
            textField = alertTextField
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Model Manipulation methods:
    
    func saveCategory(_ theCategory: Category) {
        
        do{
            try realm.write {
                realm.add(theCategory)
            }
        }catch{
            print("error save category")
        }
        tableView.reloadData()
    }
    
    func loadCategory() {
        
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    // MARK: help method for delete category
    
    override func deleteData(at indexPath: IndexPath) {
        if let category = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    for item in category.items {
                        self.realm.delete(item)
                    }
                    self.realm.delete(category)
                }
            } catch {
                print("error deleting category \(error)")
            }
//          tableView.reloadData()
        }
    }
}
