import SwiftUI

@MainActor
class LessonViewModel: ObservableObject {
    @Published var lesson: Lesson
    @Published var exerciseText = ""
    @Published var isLoading = false
    @Published var isCompleting = false
    @Published var showConfetti = false
    @Published var errorMessage: String?
    @Published var xpEarned: Int = 0
    
    private let userDefaults = UserDefaultsManager.shared
    
    var isCompleted: Bool {
        userDefaults.completedLessons.contains(lesson.dayNumber)
    }
    
    init(lesson: Lesson) {
        self.lesson = lesson
    }
    
    func completeLesson() async {
        isCompleting = true
        errorMessage = nil
        
        do {
            try await APIClient.shared.requestVoid(.completeLesson(day: lesson.dayNumber))
            
            var completed = userDefaults.completedLessons
            if !completed.contains(lesson.dayNumber) {
                completed.append(lesson.dayNumber)
                completed.sort()
                userDefaults.completedLessons = completed
            }
            userDefaults.lastActiveDate = Date()
            
            xpEarned = lesson.xpValue
            showConfetti = true
            
        } catch let error as NetworkError {
            errorMessage = error.localizedDescription
        } catch {
            errorMessage = "Error al completar la lección"
        }
        
        isCompleting = false
    }
}
