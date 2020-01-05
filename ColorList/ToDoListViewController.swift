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
    
    //let defaults = UserDefaults.standard // for UserDefaults method
    
    let encoder = PropertyListEncoder() //NSCoder
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist") //NSCoder
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadItems()
        print(dataFilePath) // print
        
    }

    func addNewItem(itemName: String) {
        let newItem = Item()
        newItem.title = itemName
        self.itemArray.append(newItem)
        //self.defaults.set(self.itemArray, forKey: "ToDoListArray") // for UserDefaults
        self.saveItems()
    }
    
    func saveItems() {
        do {
            let data = try encoder.encode(self.itemArray)
            try data.write(to: self.dataFilePath!)
        } catch {
            print("Error in encoding item array\(error)")
        }
    }
    
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error in encoding item array\(error)")
            }
        }
    }
    
    @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New TO DO Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            print("item added")
            if let itemToAppend = textField.text {
                self.addNewItem(itemName: itemToAppend)
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
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none

        return cell
    }
    
    //MARK: Tabbleview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        self.saveItems()
        self.tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
