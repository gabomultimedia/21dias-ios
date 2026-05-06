import Foundation

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    private let defaults = UserDefaults.standard
    
    private enum Keys {
        static let isLoggedIn = "isLoggedIn"
        static let userId = "userId"
        static let userName = "userName"
        static let userEmail = "userEmail"
        static let isPremium = "isPremium"
        static let completedLessons = "completedLessons"
        static let lastActiveDate = "lastActiveDate"
    }
    
    private init() {}
    
    var isLoggedIn: Bool {
        get { defaults.bool(forKey: Keys.isLoggedIn) }
        set { defaults.set(newValue, forKey: Keys.isLoggedIn) }
    }
    
    var userId: String? {
        get { defaults.string(forKey: Keys.userId) }
        set { defaults.set(newValue, forKey: Keys.userId) }
    }
    
    var userName: String? {
        get { defaults.string(forKey: Keys.userName) }
        set { defaults.set(newValue, forKey: Keys.userName) }
    }
    
    var userEmail: String? {
        get { defaults.string(forKey: Keys.userEmail) }
        set { defaults.set(newValue, forKey: Keys.userEmail) }
    }
    
    var isPremium: Bool {
        get { defaults.bool(forKey: Keys.isPremium) }
        set { defaults.set(newValue, forKey: Keys.isPremium) }
    }
    
    var completedLessons: [Int] {
        get { defaults.array(forKey: Keys.completedLessons) as? [Int] ?? [] }
        set { defaults.set(newValue, forKey: Keys.completedLessons) }
    }
    
    var lastActiveDate: Date? {
        get { defaults.object(forKey: Keys.lastActiveDate) as? Date }
        set { defaults.set(newValue, forKey: Keys.lastActiveDate) }
    }
    
    func clearAll() {
        let domain = BundleIdentifier
        defaults.removePersistentDomain(forName: domain)
    }
    
    private var BundleIdentifier: String {
        Bundle.main.bundleIdentifier ?? "com.21dias.app"
    }
}
