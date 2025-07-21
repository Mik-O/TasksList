//
//  TaskListViewController.swift
//  TasksList
//
//  Created by Таня Кожевникова on 17.07.2025.
//

import UIKit

class ViewController: UITableViewController {
    
    private let cellID = "cellID"
    private var tasks = StorageManager.shared.fetchData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        setupView()
    }
    
    // Setup View
    private func setupView() {
        view.backgroundColor = .white
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        
        
        
        
        navigationItem.title = "Task List"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Navigation Bar Apperance
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        navBarAppearance.backgroundColor = UIColor(
            red: 21/255,
            green: 101/255,
            blue: 192/255,
            alpha: 194/255
        )
        
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        
        //Add button to navigation bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addNewTask)
        )
        
        navigationController?.navigationBar.tintColor = .white
    }
    
    
    @objc private func addNewTask() {
        showAlert()
        // почему не завялось с другими аргументами?
    }
    
    
    
    
    private func save(task: String) {
        StorageManager.shared.save(task) { task in
            self.tasks.append(task)
            self.tableView.insertRows(
                at: [IndexPath(row: self.tasks.count - 1, section: 0)],
                with: .automatic
            )
        }
        
        
        
    }
}

    // MARK: - UITableViewDataSourse
extension ViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
        let task = tasks[indexPath.row]
        cell.textLabel?.text = task.name
        
        return cell
    }
}

    // MARK: - UITableViewDelegate
extension UIViewController {
    // Edit task
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let task = tasks[indexPath.row]
        showAlert(task: task) {
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    // Delete task
    override func tableView(_ tableView: UITableView, comit editingStyle: UITableViewCell.EditingStyle, forRowAt IndexPath: IndexPath) {
        let task = tasks[IndexPath.row]
        
        if editingStyle == .delete {
            tasks.remove(at: IndexPath.row)
            tableView.deleteRows(at: [IndexPath], with: .automatic)
            StorageManager.shared.deleted(task)
        }
    }
    
}

    // MARK: - Alert Controller
extension UIViewController {
    
    private func showAlert(task: Task? = nil, completion: (() -> Void)? = nil) {
        
        let title = task != nil ? "Update Task" : "New Task"
        
        let alert = AlertController(
            title: title,
            message: "What do you want to do?",
            preferredStyle: .alert
        )
        
        alert.actiom(task: task) { taskName in
            if let task = task, let completion = completion {
                StorageManager.shared.edit(task, newName: taskName)
                completion()
            } else {
                self.save(task: taskName)
            }
        }
        
        present(alert, animated: true)
    }
}
