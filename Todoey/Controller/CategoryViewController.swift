//
//  CategoryViewController.swift
//  Todoey
//
//  Created by CHAO JIANG on 6/6/18.
//  Copyright © 2018 nickjc1. All rights reserved.
//

import UIKit
//import CoreData
import RealmSwift

class CategoryViewController: UITableViewController {
    
    // MARK: - Declare veriable here:
    
    let realm = try! Realm()
    
    var categoryArray : [Category] = []
//    let theContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    

    // MARK: - viewDidLoad()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategory()
    }
    
    // MARK: - tableview datasource method:
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        cell.textLabel?.text = categoryArray[indexPath.row].name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    
    // MARK: - tableview delegate method:
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItem", sender: self)
        
    }
    
    // MARK: - prepare segue method:
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
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
            self.categoryArray.append(theCategory)
            
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
    
    func loadCategory(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categoryArray = try theContext.fetch(request)
        } catch {
            print("error fetch category array \(error)")
        }
        tableView.reloadData()
    }
    

}
