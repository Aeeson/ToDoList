import Foundation
import ToDoItemModel
import CocoaLumberjack
import CoreData

protocol FileCacheProtocol {
    func add(_ item: ToDoItem)
    
    func delete(with id: String)
    
    func load() throws -> [ToDoItem]
    
    func edit(_ item: ToDoItem)
    
    func replaceItems(with items: [ToDoItem])
}

final class FileCache: FileCacheProtocol {
    
    // MARK: - Properties
    
    private(set) var toDoItems: [ToDoItem] = []
    fileprivate let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // MARK: - <FileCacheProtocol>
    
    func add(_ item: ToDoItem) {
        toDoItems.append(item)
        let coreDataItem = ToDoItemCD(context: context)
        coreDataItem.id = item.id
        coreDataItem.text = item.text
        coreDataItem.isDone = item.isDone
        coreDataItem.deadline = item.deadline
        coreDataItem.priority = Int64(item.priority.rawValue)
        coreDataItem.creationDate = item.creationDate
        coreDataItem.modificatonDate = item.modificationDate
        do {
            try context.save()
        } catch {
            DDLogError("Save all failed")
        }
    }
    
    func delete(with id: String) {
        toDoItems = toDoItems.filter{ $0.id != id }
        do {
            let request = ToDoItemCD.fetchRequest() as NSFetchRequest<ToDoItemCD>
            let predicate = NSPredicate(format: "id CONTAINS %@", id)
            request.predicate = predicate
            let fetchedItems = try context.fetch(request)
            guard let deletingItem = fetchedItems.first else {
                DDLogError("Didn't find item")
                return
            }
            context.delete(deletingItem)
            do {
                try context.save()
            } catch {
                DDLogError("Delete one failed")
            }
        } catch {
            DDLogError("Deliting request failed")
        }
    }
    
    func load() throws -> [ToDoItem] {
        do {
            let items = try context.fetch(ToDoItemCD.fetchRequest())
            for element in items {
                toDoItems.append(element.asLocal)
            }
        } catch {
            DDLogError("Loading all request failed")
        }
        return toDoItems
    }
    
    func edit(_ item: ToDoItem) {
        toDoItems = toDoItems.filter{ $0.id != item.id }
        do {
            let request = ToDoItemCD.fetchRequest() as NSFetchRequest<ToDoItemCD>
            let predicate = NSPredicate(format: "id CONTAINS %@", item.id)
            request.predicate = predicate
            let fetchedItems = try context.fetch(request)
            guard let editingItem = fetchedItems.first else {
                DDLogError("Didn't find item")
                return
            }
            editingItem.id = item.id
            editingItem.text = item.text
            editingItem.isDone = item.isDone
            editingItem.deadline = item.deadline
            editingItem.priority = Int64(item.priority.rawValue)
            editingItem.creationDate = item.creationDate
            editingItem.modificatonDate = item.modificationDate
            toDoItems.append(editingItem.asLocal)
            do {
                try context.save()
            } catch {
                DDLogError("Save one failed")
            }
        } catch {
            DDLogError("Get one item request failed")
        }
    }
    
    func replaceItems(with items: [ToDoItem]) {
        toDoItems = []
        for item in items {
            add(item)
        }
    }
    
}
