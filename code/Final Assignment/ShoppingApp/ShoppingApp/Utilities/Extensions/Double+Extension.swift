import Foundation

extension Double {
    var currency: String {
        self.formatted(.currency(code: "USD"))
    }
}
