import SwiftUI

@MainActor
class ProgressViewModel: ObservableObject {
    @Published var streak: Streak?
    @Published var badges: [Badge] = []
    @Published var progress: Progress?
    @Published var isLoading = false
    
    func loadProgress() async {
        isLoading = true
        
        do {
            async let streakTask: Streak = APIClient.shared.request(.streak)
            async let badgesTask: BadgesResponse = APIClient.shared.request(.badges)
            async let progressTask: Progress = APIClient.shared.request(.progress)
            
            let (streakResult, badgesResult, progressResult) = try await (streakTask, badgesTask, progressTask)
            streak = streakResult
            badges = badgesResult.badges
            progress = progressResult
        } catch {
            // Handle error - show empty state
        }
        
        isLoading = false
    }
}
