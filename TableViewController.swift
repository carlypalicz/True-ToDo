//
//  TableViewController.swift
//  trueToDo
//
//  Created by Carly Palicz on 8/9/19.
//  Copyright © 2019 Carly Palicz. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    var toDos : [ToDoData] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        //toDos = createTasks()
        getTasks()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func getTasks(){
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            
            if let coreDataTasks = try? context.fetch(ToDoData.fetchRequest()) as? [ToDoData] {
                let tasks = coreDataTasks
                toDos = tasks
                tableView.reloadData()
            }
        }
    }
    
    func createTasks() -> [ToDoItem]{
        let item_1 = ToDoItem()
        item_1.name = "buy milk"
        
        let item_2 = ToDoItem()
        item_2.name = "water plants"
        
        let item_3 = ToDoItem()
        item_3.name = "homework"
        
        return [item_1, item_2, item_3]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getTasks()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return toDos.count
        }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        let task = toDos[indexPath.row]
        // Configure the cell...
        cell.textLabel?.text = task.name
        cell.accessoryType = task.completed ? .checkmark: .none
        if task.important {
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false) //dont highlight the row
        toDos[indexPath.row].completed = !toDos[indexPath.row].completed

        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            do {
                try context.save()
            } catch {
                print("couldnt save item update")
            }
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete{
            
            if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
                let deleteMe = toDos[indexPath.row]
                toDos.remove(at: indexPath.row)
                context.delete(deleteMe)
                
                do {
                   try context.save()
                } catch {
                    print("error deleting")
                }
                
                tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
                
            }
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let addTaskView = segue.destination as? AddTaskViewController{
            addTaskView.previousView = self
        }
    }
}
