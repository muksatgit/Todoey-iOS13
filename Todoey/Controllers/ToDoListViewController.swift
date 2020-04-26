//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var itemArray = [Item]()
    var uDefults = UserDefaults.standard
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        loadItems()
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        let item = itemArray[indexPath.row]
        
        cell.accessoryType = item.selected ? .checkmark : .none
        return cell
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var tfItem = UITextField()
        
        let alert = UIAlertController(title: "Add new ToTo Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen if the user press the add button
            
            let itemTitle = tfItem.text!
            let item = Item(context: self.context)
            item.title = itemTitle
            item.selected = false
            self.itemArray.append(item)
            self.saveItems()
            self.tableView.reloadData()
            }
        alert.addAction(action)
        alert.addTextField { (alertTextFiled) in
            alertTextFiled.placeholder = "Add a new item..."
            tfItem = alertTextFiled
        }
        present(alert, animated: true, completion: nil)
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //context.delete(itemArray[indexPath.row])
        // itemArray.remove(at: indexPath.row)
        
        tableView.deselectRow(at: indexPath, animated: true)
        itemArray[indexPath.row].selected = !itemArray[indexPath.row].selected
        tableView.cellForRow(at: indexPath)?.accessoryType = itemArray[indexPath.row].selected ? .checkmark : .none
        
        saveItems()
        tableView.reloadData()
    }
    
    func saveItems(){
        do {
            try context.save()
        } catch  {
            print("error saving contect\(error)")
        }
    }
    
    func loadItems(with request:NSFetchRequest<Item> = Item.fetchRequest()) {
        do{
            itemArray = try context.fetch(request)
        }
        catch{
            print("Error fetching request\(error)")
        }
        tableView.reloadData()
    }
    
    
}

//MARK: - Search Bar Methods
extension ToDoListViewController:UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request:NSFetchRequest<Item> = Item.fetchRequest()
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadItems(with: request)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
        else
        {
            
        }
    }
}

