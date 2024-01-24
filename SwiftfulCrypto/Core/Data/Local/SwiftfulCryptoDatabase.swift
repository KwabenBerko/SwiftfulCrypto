//
//  SwiftfulCryptoDatabase.swift
//  SwiftfulCrypto
//
//  Created by Kwabena Berko on 1/1/24.
//

import Foundation
import CoreData

class SwiftfulCryptoDatabase {
    private let name = "SwiftfulCryptoDatabase"
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: name)
        
        if inMemory {
            let description = NSPersistentStoreDescription()
            description.type = NSInMemoryStoreType
            
            container.persistentStoreDescriptions = [description]
        }
        
        container.loadPersistentStores { [weak self] _, error in
            if let error = error {
                print("Error loading Core Data. \(error.localizedDescription)")
            } else {
                if let self = self {
                    self.container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
                }
            }
        }
    }
}
