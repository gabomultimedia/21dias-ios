import SwiftUI

@MainActor
class ProfileViewModel: ObservableObject {
    @Published var isPremium = false
    @Published var isLoading = false
    @Published var showLogoutAlert = false
    
    private let userDefaults = UserDefaultsManager.shared
    private let keychain = KeychainHelper.shared
    
    var userName: String {
        userDefaults.userName ?? "Usuario"
    }
    
    var userEmail: String {
        userDefaults.userEmail ?? ""
    }
    
    var completedLessons: Int {
        userDefaults.completedLessons.count
    }
    
    func logout() {
        keychain.clearAll()
        userDefaults.clearAll()
    }
}
