//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController{
    
    @IBOutlet weak var searchBar: UISearchBar!
    let realm = try! Realm()
    var selectedCategory:Category?
    {
        didSet{
            loadItems()
        }
    }
    
    var todoItems:Results<Item>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        //loadItems()
        //print(selectedCategory!)
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        if let item = todoItems?[indexPath.row]
        {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.selected ? .checkmark : .none
        }
        else
        {
            cell.textLabel?.text = "No items added yet."
        }
        return cell
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var tfItem = UITextField()
        
        let alert = UIAlertController(title: "Add new ToTo Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen if the user press the add button
            if let currentCategory = self.selectedCategory{
                do {
                    try self.realm.write{
                        let item = Item()
                        item.title = tfItem.text!
                        item.dateCreated = Date()
                        currentCategory.items.append(item)
                    }
                } catch  {
                    print("Error in adding item to \(currentCategory.name): \(error)")
                }
                
                
            }
            
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
        
        if let item = todoItems?[indexPath.row]
        {
            do{
                try realm.write{
                item.selected = !item.selected
                }
            }
            catch
            {
                print("Error updating item: \(error)")
            }
            tableView.deselectRow(at: indexPath, animated: true)
            tableView.reloadData()
        }
    }
    
    func save(item:Item){
        
        do {
            try
                realm.write{
                    realm.add(item)
            }
        } catch  {
            print("error saving item\(error)")
        }
        
    }
    
    func loadItems() {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        /*
         let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES%@", selectedCategory!.name!)
         
         if let additionalPredicate = predicate{
         request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
         }else{
         request.predicate = categoryPredicate
         }
         
         do{
         itemArray = try context.fetch(request)
         }
         catch{
         print("Error fetching request\(error)")
         }
         */
        tableView.reloadData()
    }

}



//MARK: - Search Bar Methods

extension ToDoListViewController:UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        updateResults(txt:searchBar.text! )
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
            loadItems()
            updateResults(txt:searchBar.text! )
        }
    }
    
    func updateResults(txt value:String)
    {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", value).sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
}


