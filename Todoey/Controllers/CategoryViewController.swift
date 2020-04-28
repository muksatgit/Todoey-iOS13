//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Mukesh Kumar on 2020-04-25.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: SwipeTableViewController  {

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
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
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
     
    func loadCategories(){
        categoryArray = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    override func updateModel(at indexpath: IndexPath) {
        if let categotyForDelete = self.categoryArray?[indexpath.row]{
            do{
            try self.realm.write{
                self.realm.delete(categotyForDelete)
                }
            }
            catch{
                print("Error in deleteing caetgory\(error)")
            }
        }
    }
}
