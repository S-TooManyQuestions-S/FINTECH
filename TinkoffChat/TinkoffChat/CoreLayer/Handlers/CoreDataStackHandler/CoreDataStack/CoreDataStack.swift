//
//  CoreDataStack.swift
//  TinkoffChat
//
//  Created by Андрей Самаренко on 31.03.2021.
//

import UIKit
import CoreData

class CoreDataStack: CoreDataStackProtocol {
    
    init() {
        enableObservers()
    }
    
    var didUpadateDataBase: ((CoreDataStack) -> Void)?
    
    private var storeUrl: URL = {
        // получаем доступ к файлу с нашей схемы базы данных
        guard let documentUrl = FileManager.default.urls(for: .documentDirectory,
                                                         in: .userDomainMask).last
        else {
            fatalError("document path not found")
        }
        return documentUrl.appendingPathComponent("ChatDataModel.sqlite")
    }()
    
    private let dataModelName = "ChatDataModel"
    // default разрешение CoreData
    private let dataModelExtension = "momd"
    
    /**
     Из Bundle достаем файл для создания instance'a NSManagedObjectModel
     Достаем схему и готовим ее для координатора.
     */
    private(set) lazy var managedObject: NSManagedObjectModel = {
        guard let modelUrl = Bundle.main.url(forResource: self.dataModelName,
                                             withExtension: self.dataModelExtension) else {
            fatalError("model not found")
        }
        
        // инстанс нашей схемы, с которой будем проделывать манипуляции
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelUrl) else {
            fatalError("managedObjectModel cannot be created")
        }
        
        return managedObjectModel
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // создание координатора для работы с SQLite базой данных
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObject)
        
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                               configurationName: nil,
                                               at: self.storeUrl,
                                               options: nil)
        } catch {
            fatalError(error.localizedDescription)
        }
        
        return coordinator
    }()
    
    // создаем контекст для записи данных в базу данных с помощью координатора
    private lazy var writterContext: NSManagedObjectContext = {
        // приватная очередь исполнения
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        // инициализируем ответственный за контекст координатор
        context.persistentStoreCoordinator = self.persistentStoreCoordinator
        // настраиваем политику разрешения конфликтов переписыванием конфликтных данных на новые
        context.mergePolicy = NSOverwriteMergePolicy
        
        return context
    }()
    
    // контекст для работы с UI, выполняется в main очереди
    private(set) lazy var mainContext: NSManagedObjectContext = {
        // т.к для работы с UI элементами (обновления визуальной составляющей приложения)
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        // передаем данные из него в контекст записи - поэтому данный контекст - ребенок writter
        context.parent = self.writterContext
        
        context.automaticallyMergesChangesFromParent = true
        /**
         Политика, которая объединяет конфликты между версией
         объекта в постоянном хранилище и текущей версией в памяти по отдельному свойству,
         при этом изменения в памяти имеют приоритет над внешними изменениями.
         */
        context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        
        return context
    }()
    
    // функция, т.к. каждый раз при вызове - возвращает новый контекст
    private func saveContext() -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        
        context.parent = mainContext
        context.automaticallyMergesChangesFromParent = true
        
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        return context
    }
    
    func performSave(_ block: (NSManagedObjectContext) -> Void) {
        let context = saveContext()
        context.performAndWait {
            block(context)
            if context.hasChanges {
                performSave(in: context)
            }
        }
    }
    
    func performSave(in context: NSManagedObjectContext) {
        context.performAndWait {
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
        
        if let parent = context.parent {
            performSave(in: parent)
        }
    }
    
    private func enableObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(managedObjectDidChage(notification:)),
                                       name: Notification.Name.NSManagedObjectContextObjectsDidChange,
                                       object: mainContext)
    }
    
    @objc
    private func managedObjectDidChage(notification: NSNotification) {
        guard let userInfo = notification.userInfo else {return}
        
        didUpadateDataBase?(self)
        
        if let inserts = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject>,
           inserts.count > 0 {
            Logger.logCoreDataProcess(fullDescription: "Добавлено объектов: \(inserts.count)")
        }
        
        if let updates = userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject>,
           updates.count > 0 {
            Logger.logCoreDataProcess(fullDescription: "Обновлено объектов: \(updates.count)")
        }
        
        if let deletes = userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject>,
           deletes.count > 0 {
            Logger.logCoreDataProcess(fullDescription: "Удалено объектов: \(deletes.count)")
        }
    }
    
    func printDataBaseStatisticsForChannels() {
        mainContext.perform {
            do {
                let count = try self.mainContext.count(for: Channel.fetchRequest())
                Logger.logCoreDataProcess(fullDescription: "Количество каналов в базе данных: \(count)")
                let messageCount = try self.mainContext.count(for: Message.fetchRequest())
                Logger.logCoreDataProcess(fullDescription: "Количество сообщений в базе данных: \(messageCount)")
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func getFetchedResultController<T: NSFetchRequestResult>(with fetchRequest: NSFetchRequest<T>) -> NSFetchedResultsController<T> {
        return NSFetchedResultsController(fetchRequest: fetchRequest,
                                          managedObjectContext: mainContext,
                                          sectionNameKeyPath: nil,
                                          cacheName: nil)
    }
}
