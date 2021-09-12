//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Mark Kenneth Bayona on 8/22/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit
import ChameleonFramework

class SwipeTableViewController: UITableViewController {
    var mainColor: UIColor?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        guard let color = mainColor else { return .darkContent }
        return color.isLight() ? .darkContent : .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none
    }
    
    // MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.CellID, for: indexPath)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "") { action, view, complete in
            self.updateModel(at: indexPath)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            complete(true)
        }
        deleteAction.image = UIImage(systemName: "trash.fill")
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func updateModel(at indexPath: IndexPath) {}
    
    func updateNavBar(backgroundColor: UIColor) {
        self.mainColor = backgroundColor
        guard let navController = navigationController else { return }
        let navBar = navController.navigationBar
        
        let contrastColor = ContrastColorOf(backgroundColor, returnFlat: true)
        let titleColorAttribute = [ NSAttributedString.Key.foregroundColor: contrastColor]
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.titleTextAttributes = titleColorAttribute
        appearance.largeTitleTextAttributes = titleColorAttribute
        appearance.backgroundColor = backgroundColor
        
        navBar.tintColor = contrastColor
        navBar.standardAppearance = appearance
        navBar.scrollEdgeAppearance = appearance
        
        self.navigationItem.rightBarButtonItem?.tintColor = contrastColor
        self.navigationController?.navigationBar.setNeedsLayout()
        self.setNeedsStatusBarAppearanceUpdate()
    }
}
