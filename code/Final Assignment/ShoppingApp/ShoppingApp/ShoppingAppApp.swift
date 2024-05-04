import SwiftUI

@main
struct ShoppingAppApp: App {
    @StateObject var persistenceController = PersistenceController.shared
    @State(initialValue: LocalizationService.shared.language.rawValue) var lang: String

    init() {
        // Add Meal data to the app initally to populate the list with dummy data
        if (!UserDefaults.standard.bool(forKey: "isCoreDataAdded")) {
            let viewContext = persistenceController.container.viewContext
            for i in 1..<10 {
                let newItem = Meal(context: viewContext)
                newItem.id = UUID().uuidString
                newItem.mealName = "Meal \(i)"
                newItem.image = "meal_\(i)"
                newItem.price = Double.random(in: 10...100)
                try? viewContext.save()
            }

            UserDefaults.standard.set(true, forKey: "isCoreDataAdded")
        }
    }

//
    var body: some Scene {
        WindowGroup {
            HomeView(lang: $lang)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environment(\.locale, .init(identifier: lang))
        }
    }
}
