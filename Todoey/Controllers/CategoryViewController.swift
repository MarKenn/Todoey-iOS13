//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Mark Kenneth Bayona on 8/16/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    lazy var realm = try! Realm()
    var categories: Results<Category>?
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { _ in
            if let text = alert.textFields?.first?.text, !text.isEmpty {
                let newCategory = Category()
                newCategory.name = text
                newCategory.bgHexColor = RandomFlatColor().hexValue()
                
                self.save(category: newCategory)
            }
        }
        
        alert.addTextField { textfield in
            textfield.placeholder = "Create new category"
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateNavBar(backgroundColor: .white)
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categories?[indexPath.row],
           let bgColor = UIColor(hexString: category.bgHexColor) {
            cell.textLabel?.text = category.name
            cell.textLabel?.textColor = ContrastColorOf(bgColor, returnFlat: true)
            cell.backgroundColor = bgColor
        } else {
            cell.textLabel?.text = "No categories added yet"
        }
        
        return cell
    }
    
    // MARK: - Table view data delegates
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.GoToItems, sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Data Manipulation
    func save(category: Category, reloadTable: Bool = true) {
        do {
            try realm.write {
                realm.add(category)
            }
            if reloadTable {
                tableView.reloadData()
            }
        } catch {
            print("Error saving context: \(error)")
        }
    }
    
    func loadCategories() {
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        guard let category = self.categories?[indexPath.row] else { return }
        do {
            try realm.write {
                realm.delete(category.items)
                realm.delete(category)
            }
        } catch {
            print("Error deleting category: \(error)")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.GoToItems {
            let destinationVC = segue.destination as! TodoListViewController
            
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.selectedCategory = categories?[indexPath.row]
            }
        }
    }
}
