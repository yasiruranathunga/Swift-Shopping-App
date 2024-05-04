import Foundation

enum Language: String {
    case English = "en"
    case Sinhala = "si-LK"

    var icon: String {
        switch self {
        case .English:
            return "ic_english"
        case .Sinhala:
            return "ic_sinhala"
        }
    }
}

class LocalizationService {

    static let shared = LocalizationService()
    static let changedLanguage = Notification.Name("changedLanguage")

    private init() {}
    private let languageKey = "language"
    
    var language: Language {
        get {
            let languageString = UserDefaults.standard.string(forKey: languageKey) ?? ""
            return Language(rawValue: languageString) ?? .English
        } set {
            if newValue != language {
                UserDefaults.standard.setValue(newValue.rawValue, forKey: languageKey)
                NotificationCenter.default.post(name: LocalizationService.changedLanguage, object: nil)
            }
        }
    }

    func toggleLanguage() {
        if language == .English {
            language = .Sinhala
        } else {
            language = .English
        }
    }
}
