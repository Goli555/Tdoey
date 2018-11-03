//
//  ViewController.swift
//  Tdoey
//
//  Created by Hidekazu Sato on 2018/10/22.
//  Copyright © 2018 Hidekazu Sato. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(dataFilePath)

        
        loadItems()
        
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
            
            let newAddItem = Item()
            newAddItem.title = textField.text!
            
            self.itemArray.append(newAddItem)
            
            self.saveItems()


        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "追加するItemの文章を入れてください。"
            textField = alertTextField
            
            print(alertTextField.text)
            print("今だよ")
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil )
        
    }
    //Mark - Model Manuplation Methods
    
    func saveItems() {
        let encoder = PropertyListEncoder()
    
    
        do {
        let data = try encoder.encode(itemArray)
        try data.write(to: dataFilePath!)
        
        } catch {
        print("Error encoding item array, \(error)")
        
        }
        self.tableView.reloadData()
    }
    
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error decoding item array, \(error)")
            }

        }
    }
    
    

}



