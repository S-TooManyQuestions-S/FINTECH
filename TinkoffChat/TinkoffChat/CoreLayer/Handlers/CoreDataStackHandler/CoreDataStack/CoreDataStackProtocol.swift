//
//  CoreDataStackProtocol.swift
//  TinkoffChat
//
//  Created by Андрей Самаренко on 13.04.2021.
//

import Foundation
import CoreData

protocol CoreDataStackProtocol {
    func performSave(_ block: (NSManagedObjectContext) -> Void)
    func performSave(in context: NSManagedObjectContext)
    func getFetchedResultController<T: NSFetchRequestResult>(with fetchRequest: NSFetchRequest<T>) -> NSFetchedResultsController<T>
    func printDataBaseStatisticsForChannels()
}
