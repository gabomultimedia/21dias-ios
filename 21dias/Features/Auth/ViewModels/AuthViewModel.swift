import SwiftUI

@MainActor
class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var currentUser: User?
    @Published var isPremium = false
    
    private let userDefaults = UserDefaultsManager.shared
    private let keychain = KeychainHelper.shared
    
    func checkAuthStatus() {
        if let token = keychain.getToken(), !token.isEmpty {
            isAuthenticated = true
            loadUserFromStorage()
        } else {
            isAuthenticated = false
        }
    }
    
    private func loadUserFromStorage() {
        isPremium = userDefaults.isPremium
    }
    
    func login(email: String, password: String) async {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Por favor completa todos los campos"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let body: [String: Any] = ["email": email, "password": password]
            let response: AuthResponse = try await APIClient.shared.request(.login(email: email, password: password), body: body)
            
            keychain.saveToken(response.token)
            userDefaults.isLoggedIn = true
            userDefaults.userId = response.user.id
            userDefaults.userName = response.user.name
            userDefaults.userEmail = response.user.email
            userDefaults.isPremium = response.user.isPremium
            
            currentUser = response.user
            isPremium = response.user.isPremium
            isAuthenticated = true
        } catch let error as NetworkError {
            errorMessage = error.localizedDescription
        } catch {
            errorMessage = "Error de conexión"
        }
        
        isLoading = false
    }
    
    func register(name: String, email: String, password: String) async {
        guard !name.isEmpty, !email.isEmpty, !password.isEmpty else {
            errorMessage = "Por favor completa todos los campos"
            return
        }
        
        guard password.count >= 6 else {
            errorMessage = "La contraseña debe tener al menos 6 caracteres"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let body: [String: Any] = ["name": name, "email": email, "password": password]
            let response: AuthResponse = try await APIClient.shared.request(.register(name: name, email: email, password: password), body: body)
            
            keychain.saveToken(response.token)
            userDefaults.isLoggedIn = true
            userDefaults.userId = response.user.id
            userDefaults.userName = response.user.name
            userDefaults.userEmail = response.user.email
            userDefaults.isPremium = response.user.isPremium
            
            currentUser = response.user
            isPremium = response.user.isPremium
            isAuthenticated = true
        } catch let error as NetworkError {
            errorMessage = error.localizedDescription
        } catch {
            errorMessage = "Error de conexión"
        }
        
        isLoading = false
    }
    
    func logout() {
        keychain.clearAll()
        userDefaults.clearAll()
        currentUser = nil
        isAuthenticated = false
        isPremium = false
    }
}
