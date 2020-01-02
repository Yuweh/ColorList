//
//  ToDoListViewController.swift
//  ColorList
//
//  Created by Francis Jemuel Bergonia on 1/2/20.
//  Copyright © 2020 Xi Apps. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    var itemArray = [Item]()
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if let items = defaults.array(forKey: "ToDoListArray") as? [String] {
//            itemArray = items
//        }
        self.addNewItem(itemName: "Code")
        self.addNewItem(itemName: "Eat")
        self.addNewItem(itemName: "Sleep")
        
    }

    func addNewItem(itemName: String) {
        let newItem = Item()
        newItem.title = itemName
        self.itemArray.append(newItem)
    }
    
    @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New TO DO Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            print("item added")
            if let itemToAppend = textField.text {
                self.addNewItem(itemName: itemToAppend)
                self.defaults.set(self.itemArray, forKey: "ToDoListArray")
                self.tableView.reloadData()
            }
            
        }
        
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
}

extension ToDoListViewController {
    
    //MARK: TableView DataSource Methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        cell.accessoryType = itemArray[indexPath.row].done == true ? .checkmark : .none
        return cell
    }
    
    //MARK: Tabbleview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        itemArray[indexPath.row].done == false ? true : false
        if tableView.cellForRow(at: indexPath)?.accessoryType ==  .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType =  .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType =  .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
