//
//  ViewController.swift
//  Tdoey
//
//  Created by Hidekazu Sato on 2018/10/22.
//  Copyright © 2018 Hidekazu Sato. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentationDirectory, in: .userDomainMask))

        
//        if let items = defaults.array(forKey: "TodoListArray")as? [Item]  {
//            itemArray = items
//        }
        
    }
    
//    MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]

        cell.textLabel?.text = item.title
 
        //Ternary operator ===>
        // value = condition ? valueIfTrue : valueIFflse
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        //下の五行と上一行は同じ
//        if item.done == true {
//            cell.accessoryType = .checkmark
//        }else {
//            cell.accessoryType = .none
//        }
//
        return cell
    }
    
    //MARK - TableView Delegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(itemArray[indexPath.row])

//        下は、直接値を変更する例
//        itemArray[indexPath.row].setValue("Completed", forKey: "title")
  
//        タップでデータを削除する場合の例
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
//        上の一行と下四行は同一
//        if itemArray[indexPath.row].done == false {
//            itemArray[indexPath.row].done = true
//        }else {
//            itemArray[indexPath.row].done = false
//        }
        
        
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        } else {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
        
        saveItems()
//        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    //MARK - Add New Item
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
//        アラートの型は、中央部に出るか（alert）か、下部に出るか？（actionsheet）アラートの出し方は、まずは箱を作って、ボタンをくっつけて表示する命令を追加する
        let alert = UIAlertController(title: "新しいItemの追加", message: "リストに新しいItemを追加します。", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // What will happpen once the clicks the Add Item button onoer UIAlert
            
            
            let newAddItem = Item(context: self.context)
            newAddItem.title = textField.text!
            newAddItem.done = false
            newAddItem.parentCategory = self.selectedCategory
            
            self.itemArray.append(newAddItem)
            
            self.saveItems()


        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (cancel) in
            print("cancelボタンタップ")
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "追加するItemの文章を入れてください。"
            textField = alertTextField
            
//            print(alertTextField.text)
            print("今だよ")
        }
        
        alert.addAction(action)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil )
        
    }
    
    //Mark - Model Manuplation Methods
    
    func saveItems() {
    
        do {
            try context.save()
        } catch {
            print("Error saving contet\(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        

        
        do {
            itemArray = try context.fetch(request)

        }catch {
            print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
    }
    
    

}

 //MARK: - Search bar methods

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
  
//        このPredicateを取得してもOK：(title CONTAINS[CD] %@) and (parentCategory.name MATCHES %@)
        
        let predicate = NSPredicate(format: "(title CONTAINS[CD] %@)", searchBar.text!,selectedCategory!.name!)
 
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]

//        do {
//            itemArray = try context.fetch(request)
//
//        }catch {
//            print("Error fetching data from context \(error)")
//        }
//
//        tableView.reloadData()
        
        loadItems(with: request, predicate: predicate)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
    
}


