//
//  StageManager.swift
//  TasksList
//
//  Created by Таня Кожевникова on 18.07.2025.
//

import CoreData

class StorgeManager {
    
    static let shared = StorgeManager()

    // MARK: - Core Data stack (в домашнем задании вынести это в storge manager)
     private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TasksList")
        container.loadPersistentStores(completionHandler: { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private var viewContext: NSManagedObjectContext {
         persistentContainer.viewContext
    }
    
    private init() {}
 
    // MARK: - Public Methods
    private func fetchData() -> [Task] {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        do {
           return try viewContext.fetch(fetchRequest)
        } catch let error {
            print("Failed to fetch data", error)
            return []
        }
    }
    
    
    // Save data
    private func save(_ taskName: String, completion: (Task) -> Void) {
        let task = Task(context: viewContext)
        task.name = taskName
        
        completion(task)
        saveContext()
    }
    
    func edit(_ task: Task, newName: String) {
        task.name = newName
        saveContext()
    }
    
    func deleted(_ task: Task) {
        viewContext.delete(task)
        saveContext()
    }
    
    //MARK: - Core Data Saving support
    func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}


