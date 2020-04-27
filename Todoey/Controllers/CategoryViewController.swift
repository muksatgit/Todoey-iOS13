//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Mukesh Kumar on 2020-04-25.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class CategoryViewController: UITableViewController  {

    let realm = try! Realm()
    var categoryArray:Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       loadCategories()

    }
    
    //MARK: - TableView Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No categories added yet."
        return cell
    }
    
    
    //MARK: - TableView Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "goToItems", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "goToItems")
        {
            let itemViewController:ToDoListViewController = segue.destination as! ToDoListViewController
            
            if let indexPath = tableView.indexPathForSelectedRow{
                itemViewController.selectedCategory = categoryArray?[indexPath.row]
            }
            else{
                print("error in finding index path")
            }
 
        }
    }
    
    //MARK: - Data Manuplation
    
    
    
    

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
       
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        
        var tField = UITextField()
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            // add all teh code to do things when user press add button
            let category = Category()//Category(context: self.context)
            
            category.name = tField.text!
            self.save(category: category)
            self.tableView.reloadData()
        }
        alert.addAction(action)
        alert.addTextField { (textField) in
            textField.placeholder = "Category Name"
            tField = textField
        }
        present(alert, animated: true, completion: nil)
    }
    
    func save(category:Category)
    {
        do{
            try realm.write{
                realm.add(category)
            }
            
                
        }catch{
            print("Error saving category data\(error)")
        }
    }
    
    func delete(category:Category)
    {
        do{
            try realm.write{
                realm.delete(category)
            }
        }catch{
            print("Error saving category data\(error)")
        }
    }
    
    func loadCategories(){
        categoryArray = realm.objects(Category.self)
        tableView.reloadData()
    }
}

//MARK: - Swipe Cell delegate Methods
extension CategoryViewController:SwipeTableViewCellDelegate{
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        guard orientation == .right else {return nil}
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { (action,indexPath ) in
            
           if let category = self.categoryArray?[indexPath.row]{
            
                self.delete(category: category)
            }
            tableView.reloadData()
        }
        deleteAction.image = UIImage(systemName: "trash")!
        return [deleteAction]
    }
}
