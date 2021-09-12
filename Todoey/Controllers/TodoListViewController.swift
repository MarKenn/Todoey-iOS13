//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    lazy var realm = try! Realm()
    var items: Results<Item>?
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        guard let color = mainColor else { return .darkContent }
        return color.isLight() ? .darkContent : .lightContent
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            if let text = alert.textFields?.first?.text,
               let currentCategory = self.selectedCategory{
                
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = text
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving item: \(error)")
                }
                
                self.tableView.reloadData()
            }
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new item"
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let colorString = selectedCategory?.bgHexColor,
           let color = UIColor(hexString: colorString) {
            updateNavBar(backgroundColor: color)
            
            let contrastColor = ContrastColorOf(color, returnFlat: true)
            
            searchBar.backgroundImage = UIImage()
            searchBar.backgroundColor = color
            
            let textField = searchBar.searchTextField
            textField.backgroundColor = contrastColor
            textField.textColor = color
            textField.leftView?.tintColor = color
            
            tableView.backgroundColor = contrastColor
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    // MARK: - TableView DataSource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = items?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
            
            if let hexColor = selectedCategory?.bgHexColor,
               let bgColor = UIColor(hexString: hexColor)?.darken(byPercentage: CGFloat(indexPath.row)*0.4 / CGFloat(items!.count)) {
                cell.backgroundColor = bgColor
                cell.textLabel?.textColor = ContrastColorOf(bgColor, returnFlat: true)
            }
        } else {
            cell.textLabel?.text = "No items added"
        }
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let item = items?[indexPath.row] else { return }
        
        do {
            try realm.write{
                item.done = !item.done
            }
        } catch {
            print("Error saving done status: \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    //MARK: - Model manipulation methods
    
    func loadItems() {
        items = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        guard let item = self.items?[indexPath.row] else { return }
        do {
            try realm.write {
                realm.delete(item)
            }
        } catch {
            print("Error deleting item: \(error)")
        }
    }
    
}

//MARK: - UISearchBar delegate
extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        items = items?.filter("title CONTAINS[cd] %@", searchBar.text!)
            .sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

