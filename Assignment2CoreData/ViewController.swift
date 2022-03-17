//
//  ViewController.swift
//  Assignment2CoreData
//
//  Created by Pawandeep Singh on 16/03/22.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: Outlet's
    
    @IBOutlet weak var todoListTableView : UITableView!
    
    //MARK: Constants , Variables
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var listModel = [TodoListItem]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "TO DO List"
        getAllItems()
        todoListTableView.delegate = self
        todoListTableView.dataSource = self
        
        //Nav BAr Button
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
        
        
    }
    
    
    //MARK: Nav BAr Button Action
    @objc func didTapAdd(){
        //open Alert to add new item with text filed
        let alert = UIAlertController(title: "New Item", message: "Enter new Item", preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "Submit", style: .cancel, handler: { [weak self] _ in
            guard let fieled = alert.textFields?.first,let text = fieled.text,!text.isEmpty else {
                                  return
            }
        self?.createItem(name: text)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: Custom Functions
    
    func getAllItems(){
        do {
            listModel = try context.fetch(TodoListItem.fetchRequest())
            DispatchQueue.main.async {
                self.todoListTableView.reloadData()
            }
            
        } catch {
            //error
        }
    }
    
    
    
    func createItem(name: String) {
       let newItem = TodoListItem(context: context)
        newItem.name = name
        newItem.createdAt = Date()
        
        do {
            try context.save()
            getAllItems()
        } catch {
            //error
        }
    }
    
    
    func deleteItem(item: TodoListItem) {
        context.delete(item)
        
        do {
            try context.save()
            getAllItems()
        } catch {
            //error
        }
    }
    
    func updateItem(item: TodoListItem,newName : String) {
        item.name = newName
        
        do {
            try context.save()
            getAllItems()
        } catch {
            //error
        }
    }
}

extension ViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowData = listModel[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = rowData.name
        cell.accessoryType = rowData.completed ? .checkmark : .none
        return cell
    }
    
   
    
    func tableView(_ tableView: UITableView,
                   editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView,
                       trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let rowData = listModel[indexPath.row]
        // edit action
        let editAction = UIContextualAction(style: .normal,
                                            title: "Edit") { _,_,_  in
            let alert = UIAlertController(title: "Edit Item", message: "Edit new Item", preferredStyle: .alert)
            alert.addTextField(configurationHandler: nil)
            alert.textFields?.first?.text = rowData.name
            alert.addAction(UIAlertAction(title: "Save", style: .cancel, handler: { [weak self] _ in
                guard let fieled = alert.textFields?.first,let newName = fieled.text,!newName.isEmpty else {
                                      return
                }
            self?.updateItem(item: rowData, newName: newName)
            }))
            self.present(alert, animated: true, completion: nil)
        }
        editAction.backgroundColor = .systemOrange

        // delete action
        let deleteAction = UIContextualAction(style: .destructive,
                                              title: "Delete") { [weak self] _,_,_  in
            self?.deleteItem(item: rowData)
        }
        
        deleteAction.backgroundColor = .systemRed

        let configuration = UISwipeActionsConfiguration(actions: [deleteAction,editAction])

        return configuration
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let rowData = listModel[indexPath.row]
        rowData.completed = !rowData.completed
        getAllItems()
    }
    
}

