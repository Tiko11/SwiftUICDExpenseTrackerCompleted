//
//  CoreDataStack.swift
//  ExpenseTracker
//
//  Created by Alfian Losari on 19/04/20.
//  Copyright © 2020 Alfian Losari. All rights reserved.
//

import CoreData
import Combine

class CoreDataStack {
    
    enum Constants: String {
        case queue = "coredata"
        case stack = "ExpenseTracker"
        
        var name: String {
            self.rawValue
        }
    }
    
    private let containerName: String
    private let persistentContainer: NSPersistentContainer
    private let queue = DispatchQueue(label: Constants.queue.name)
    
    private let isLoaded = CurrentValueSubject<Bool, Error>(false) // may not need
    
    var viewContext: NSManagedObjectContext { persistentContainer.viewContext }
    
    init(containerName: String) {
        self.containerName = containerName
        persistentContainer = NSPersistentContainer(name: containerName)
        queue.async { [weak isLoaded, weak persistentContainer] in
            persistentContainer?.loadPersistentStores { storeDescription, error in
                DispatchQueue.main.async {
                    if let error = error {
                        isLoaded?.send(completion: .failure(error))
                    } else {
                        isLoaded?.value = true
                    }
                }
            }
        }
    }
}

extension NSManagedObjectContext {
    
    func saveContext() throws {
        guard hasChanges else { return }
        try save()
    }
}
