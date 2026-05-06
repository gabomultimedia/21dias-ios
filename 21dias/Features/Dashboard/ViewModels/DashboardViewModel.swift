import SwiftUI

@MainActor
class DashboardViewModel: ObservableObject {
    @Published var progress: Progress?
    @Published var streak: Streak?
    @Published var todayLesson: Lesson?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var xpTotal: Int = 0
    
    private let userDefaults = UserDefaultsManager.shared
    
    var greeting: String {
        Date().timeGreeting()
    }
    
    var userName: String {
        userDefaults.userName ?? "Amigo"
    }
    
    var completedLessonsCount: Int {
        progress?.completedDays ?? userDefaults.completedLessons.count
    }
    
    var weekProgress: [Bool] {
        var result = [Bool]()
        let completed = Set(userDefaults.completedLessons)
        for day in 1...7 {
            result.append(completed.contains(day))
        }
        return result
    }
    
    func loadDashboard() async {
        isLoading = true
        errorMessage = nil
        
        do {
            async let progressTask: Progress = APIClient.shared.request(.progress)
            async let streakTask: Streak = APIClient.shared.request(.streak)
            
            let (progressResult, streakResult) = try await (progressTask, streakTask)
            progress = progressResult
            streak = streakResult
            xpTotal = progressResult.xpTotal
        } catch {
            // Fallback to local data
            streak = Streak(currentStreak: calculateLocalStreak(), longestStreak: 0, lastActivityDate: nil)
        }
        
        do {
            todayLesson = try await APIClient.shared.request(.lesson(day: completedLessonsCount + 1))
        } catch {
            // No lesson available yet
        }
        
        isLoading = false
    }
    
    private func calculateLocalStreak() -> Int {
        guard let lastActive = userDefaults.lastActiveDate else { return 0 }
        let calendar = Calendar.current
        let today = Date()
        
        if calendar.isDateInToday(lastActive) {
            return 1
        } else if calendar.isDateInYesterday(lastActive) {
            return 1
        }
        return 0
    }
}
