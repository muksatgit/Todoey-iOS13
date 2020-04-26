//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Mukesh Kumar on 2020-04-25.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()

    }
    
    //MARK: - TableView Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categoryArray[indexPath.row].name
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
                itemViewController.selectedCategory = categoryArray[indexPath.row]
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
            let category = Category(context: self.context)
            category.name = tField.text!
            self.categoryArray.append(category)
            self.saveCategory()
            self.tableView.reloadData()
        }
        alert.addAction(action)
        alert.addTextField { (textField) in
            textField.placeholder = "Category Name"
            tField = textField
        }
        present(alert, animated: true, completion: nil)
    }
    
    func saveCategory()
    {
        do{
            try context.save()
        }catch{
            print("Error saving category data\(error)")
        }
    }
    
    func loadCategories(with request:NSFetchRequest<Category> = Category.fetchRequest()){
        
        do {
            categoryArray = try context.fetch(request)
        } catch  {
            print("Error fetching category request\(error)")
        }
        tableView.reloadData()
    }
}
