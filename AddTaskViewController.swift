//
//  AddTaskViewController.swift
//  trueToDo
//
//  Created by Carly Palicz on 8/11/19.
//  Copyright © 2019 Carly Palicz. All rights reserved.
//

import UIKit

class AddTaskViewController: UIViewController {

    var previousView = TableViewController()
    
    @IBOutlet weak var taskNameTextField: UITextField!
    @IBOutlet weak var importantSwitch: UISwitch!
    
    @IBAction func addTask(_ sender: Any) {
/*        let toDo = ToDoItem()
        
        if let taskText = taskNameTextField.text {
            toDo.name = taskText
            previousView.toDos.append(toDo)
            previousView.tableView.reloadData()
            navigationController?.popViewController(animated: true)
        }
 */
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            let toDo = ToDoData(entity: ToDoData.entity(), insertInto: context)
            //makes new object in core data
            if let taskText = taskNameTextField.text {
                toDo.name = taskText
                toDo.important = importantSwitch.isOn
            }
            try? context.save()
            navigationController?.popViewController(animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

}
