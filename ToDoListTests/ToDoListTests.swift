import XCTest
import ToDoItemModel
@testable import ToDoList
// swiftlint:disable all

class ToDoListTests: XCTestCase {

    //MARK: - FileCache testing
    
    func testThatTaskIsAdded() throws {
        let fileCache = FileCache()
        
        let task = ToDoItem(id: "1", text: "1", priority: .regular, deadline: nil, isDone: true, creationDate: Date(), modificationDate: nil)
        fileCache.add(task)
        
        XCTAssert(!fileCache.toDoItems.isEmpty)
    }
    
    func testThatTaskWithSameIdNotAddedAndDeleteOldOne() throws {
        let fileCache = FileCache()
        let taskFirst = ToDoItem(id: "1", text: "1", priority: .regular, deadline: nil, isDone: true, creationDate: Date(), modificationDate: nil)
        let taskSecond = ToDoItem(id: "1", text: "1", priority: .regular, deadline: nil, isDone: true, creationDate: Date(), modificationDate: nil)
        fileCache.add(taskFirst)
        
        fileCache.add(taskSecond)
        
        XCTAssert(fileCache.toDoItems.count == 1)
    }
    
}
