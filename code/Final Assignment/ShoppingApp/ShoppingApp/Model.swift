import Foundation
//
extension Meal {
    var priceString: String {
        price.formatted(.currency(code: "USD"))
    }
}

extension CartMealItem {
    var total: Double {
        return (meal?.price ?? 0) * Double(quantity)
    }
}
