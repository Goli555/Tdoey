//
//  CategoryViewController.swift
//  Tdoey
//
//  Created by Hidekazu Sato on 2018/11/07.
//  Copyright © 2018 Hidekazu Sato. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categoryArray = [Category]()

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategory()

        
    }
    
    
    //MARK: -TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categoryArray[indexPath.row].name

        return cell
    }

    
    //MARK: -TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        print("データ受け渡し前")
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categoryArray[indexPath.row]
            print("カテゴリ名：\(categoryArray[indexPath.row].name!)")
        }
    }
    
    //MARK: -Add New Category
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "新しいCategoryの追加", message: "新しいCategoryを追加します。", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            // What will happpen once the clicks the Add Item button onoer UIAlert
            
            let newAddCategory = Category(context: self.context)
            newAddCategory.name = textField.text!
//
            print(newAddCategory)
            self.categoryArray.append(newAddCategory)
            
            self.saveCategory()
        }
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Category名を入れてください。"
            textField = alertTextField

            
        }
        

        present(alert, animated: true, completion: nil )
        
    }
    


    
    //MARK: -Data Manipulation Methods
    
    func saveCategory() {
        do {
            try context.save()
        } catch {
            print("Error saving contet\(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategory(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        //        let request : NSFetchRequest<Item> = Item.fetchRequest()

        do {
            categoryArray = try context.fetch(request)

        }catch {
            print("Error fetching data from context \(error)")
        }

        tableView.reloadData()
    }
    
    
}
