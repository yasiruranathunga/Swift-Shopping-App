// testing the total property of the CartMealItem

import XCTest
import CoreData
@testable import ShoppingApp

class CartMealItemTests: XCTestCase {
    var managedObjectContext: NSManagedObjectContext!

    override func setUpWithError() throws {
        try super.setUpWithError()
        managedObjectContext = createTestManagedObjectContext()
    }

    override func tearDownWithError() throws {
        managedObjectContext = nil
        try super.tearDownWithError()
    }
//Creating a test-specific managed object context
    
    func createTestManagedObjectContext() -> NSManagedObjectContext {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        let modelURL = Bundle.main.url(forResource: "ShoppingApp", withExtension: "momd")!
        let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL)!
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        
        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
        } catch {
            fatalError("Failed to create test managed object context: \(error)")
        }
        
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        return managedObjectContext
    }

    
//Testing the total property calculation:
    func testTotal_WithValidMealAndQuantity_CalculatesCorrectTotal() {
        // Given
        let cartItem = CartMealItem(context: managedObjectContext)
        let meal = createMeal()
        cartItem.meal = meal
        cartItem.quantity = 2

        // When
        let total = cartItem.total

        // Then
        XCTAssertEqual(total, meal.price * 2)
    }
// Test meal object
    func createMeal() -> Meal {
        let meal = Meal(context: managedObjectContext)
        meal.id = UUID().uuidString
        meal.price = 10.99
        // Set other properties as needed
        try? managedObjectContext.save()
        return meal
    }

  
}
