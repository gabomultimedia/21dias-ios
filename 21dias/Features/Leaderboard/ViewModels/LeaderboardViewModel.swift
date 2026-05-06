import Foundation

enum LeaderboardPeriod: String, CaseIterable {
    case weekly = "weekly"
    case global = "all_time"
    case friends = "friends"
}

struct LeaderboardUser: Identifiable {
    let id: String
    let displayName: String
    let xp: Int
    let streak: Int
    let rank: Int
}

class LeaderboardViewModel: ObservableObject {
    @Published var ranks: [LeaderboardUser] = []
    @Published var currentUserId: String?
    
    func loadLeaderboard(period: LeaderboardPeriod) {
        Task {
            do {
                let users = try await APIClient.shared.getLeaderboard(period: period.rawValue)
                await MainActor.run {
                    self.ranks = users
                    self.currentUserId = UserDefaultsManager.shared.currentUserId
                }
            } catch {
                print("Error loading leaderboard: \(error)")
            }
        }
    }
}