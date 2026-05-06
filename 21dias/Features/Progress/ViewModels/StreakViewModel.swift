import Foundation
import Combine

class StreakViewModel: ObservableObject {
    @Published var currentStreak = 0
    @Published var longestStreak = 0
    @Published var streakShields = 3
    @Published var nextBadge = "Racha 7"
    @Published var daysToNextBadge = 7
    @Published var progressToNextBadge = 0.0
    @Published var streakFreezesUsed = 0
    
    private var cancellables = Set<AnyCancellable>()
    
    func loadStreak() {
        Task {
            do {
                let streak = try await APIClient.shared.getStreak()
                await MainActor.run {
                    self.currentStreak = streak.currentStreak
                    self.longestStreak = streak.longestStreak
                    self.streakShields = streak.streakShields
                    self.streakFreezesUsed = streak.streakFreezesUsed
                    self.calculateNextBadge()
                }
            } catch {
                print("Error loading streak: \(error)")
            }
        }
    }
    
    private func calculateNextBadge() {
        if currentStreak < 7 {
            nextBadge = "Racha 7"
            daysToNextBadge = 7 - currentStreak
            progressToNextBadge = Double(currentStreak) / 7.0
        } else if currentStreak < 14 {
            nextBadge = "Racha 14"
            daysToNextBadge = 14 - currentStreak
            progressToNextBadge = Double(currentStreak - 7) / 7.0
        } else if currentStreak < 21 {
            nextBadge = "Dragón de Fuego"
            daysToNextBadge = 21 - currentStreak
            progressToNextBadge = Double(currentStreak - 14) / 7.0
        } else {
            nextBadge = "¡Máximo nivel!"
            daysToNextBadge = 0
            progressToNextBadge = 1.0
        }
    }
}