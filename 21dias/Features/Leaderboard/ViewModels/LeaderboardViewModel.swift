import Foundation

enum LeaderboardPeriod: String, CaseIterable {
    case weekly = "weekly"
    case allTime = "all_time"
    case friends = "friends"
    
    var displayName: String {
        switch self {
        case .weekly: return "Semanal"
        case .allTime: return "Global"
        case .friends: return "Amigos"
        }
    }
}

class LeaderboardViewModel: ObservableObject {
    @Published var ranks: [LeaderboardUser] = []
    @Published var currentUserRank: Int?
    @Published var selectedPeriod: LeaderboardPeriod = .weekly
    @Published var isLoading = false
    
    private let userDefaults = UserDefaultsManager.shared
    
    var currentUserId: String? {
        userDefaults.currentUserId
    }
    
    func loadLeaderboard(period: LeaderboardPeriod) {
        selectedPeriod = period
        isLoading = true
        
        Task {
            do {
                let users = try await APIClient.shared.getLeaderboard(period: period.rawValue)
                await MainActor.run {
                    self.ranks = users
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.isLoading = false
                    print("Error loading leaderboard: \(error)")
                }
            }
        }
    }
    
    func getPeriodDisplayName(_ period: LeaderboardPeriod) -> String {
        return period.displayName
    }
}