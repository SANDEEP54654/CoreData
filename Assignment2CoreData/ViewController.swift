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
        
        
    }
    
}

extension ViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowData = listModel[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        return cell
    }
    
}

