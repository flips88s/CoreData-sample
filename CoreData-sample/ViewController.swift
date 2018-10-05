//
//  ViewController.swift
//  CoreData-sample
//
//  Created by Shota on 2018/10/03.
//  Copyright © 2018 Shota. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    var data: [Entity] = []
    
    override func loadView() {
        let table = UITableView()
        table.dataSource = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view = table
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let plusButton = UIBarButtonItem(
            title: "+", style: .plain, target: self, action: #selector(addItem(_:)))
        
        navigationItem.rightBarButtonItem = plusButton
        navigationItem.leftBarButtonItem = editButtonItem
        
        reloadData()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        (view as! UITableView).isEditing = editing
    }
    
    @objc
    func addItem(_ sender: UIBarButtonItem) -> Void {
        let appDelegete = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegete.persistentContainer.viewContext
        
        let entity = NSEntityDescription.insertNewObject(forEntityName: "Entity", into: context) as! Entity
        entity.setValue(Date(), forKey: "date")
        
        do { try context.save() }
        catch { fatalError(error.localizedDescription) }
        
        reloadData()
    }
    
    func reloadData() -> Void {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Entity")
        
        do { data = try context.fetch(request) as! [Entity] }
        catch { fatalError(error.localizedDescription) }
        
        (view as! UITableView).reloadData()
    }
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = "\(data[indexPath.row].date!)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            context.delete(data[indexPath.row])
            do { try context.save() }
            catch { fatalError(error.localizedDescription) }
            
            data.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
