//
//  NSManagedObjectContext.swift
//  SwiftfulCrypto
//
//  Created by Kwabena Berko on 1/1/24.
//


import Combine
import CoreData

extension NSManagedObjectContext {
    
    func publisher<Entity: NSManagedObject>(
        for fetchRequest: NSFetchRequest<Entity>
    ) -> AnyPublisher<[Entity], Never> {
        FetchedResultsPublisher(request: fetchRequest, context: self)
            .replaceError(with: [])
            .eraseToAnyPublisher()
    }
    
    func deleteAll(type: NSManagedObject.Type) {
        /*
         I am iterating over each item and deleting them as Batch Deletion
         fails on an NSInMemoryStoreType, used in unit tests.
         More info can be found here:
         https://developer.apple.com/library/archive/featuredarticles/CoreData_Batch_Guide/BatchDeletes/BatchDeletes.html
         */
        let fetchRequest: NSFetchRequest = type.fetchRequest()
        fetchRequest.includesPropertyValues = false
        
        do {
            let objects = try self.fetch(fetchRequest)
            for case let object as NSManagedObject in objects {
                self.delete(object)
            }
            print("Entities deleted. Count: \(objects.count)")
        } catch let error {
            print("Error deleting entities: \(error)")
        }
    }
    
    func applyChanges() {
        if self.hasChanges {
            do {
                try self.save()
            } catch let error {
                print("Error Applying Changes. \(error.localizedDescription)")
            }
        }
    }
}
