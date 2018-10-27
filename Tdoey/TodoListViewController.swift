//
//  ViewController.swift
//  Tdoey
//
//  Created by Hidekazu Sato on 2018/10/22.
//  Copyright © 2018 Hidekazu Sato. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = ["アイウエオ","abcdef","位fdsじゃいふぁsだ"]
    
    let defaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let items = defaults.array(forKey: "TodoListArray")as? [String]  {
            itemArray = items
        }
        
    }
    
    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    //MARK - TableView Delegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(itemArray[indexPath.row])
        
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    //MARK - Add New Item
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
//        アラートの型は、中央部に出るか（alert）か、下部に出るか？（actionsheet）アラートの出し方は、まずは箱を作って、ボタンをくっつけて表示する命令を追加する
        let alert = UIAlertController(title: "新しいItemの追加", message: "リストに新しいItemを追加します。", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // What will happpen once the clicks the Add Item button onoer UIAlert
            
            self.itemArray.append(textField.text!)
            
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            self.tableView.reloadData()
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
    

}



