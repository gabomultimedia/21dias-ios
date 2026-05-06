import SwiftUI

@MainActor
class ToolsViewModel: ObservableObject {
    @Published var wheelOfLife: WheelOfLife = WheelOfLife()
    @Published var goals: [Goal] = []
    @Published var eisenhowerTasks: [EisenhowerTask] = []
    @Published var isLoading = false
    @Published var isSaving = false
    
    func loadWheelOfLife() async {
        isLoading = true
        do {
            let wheel: WheelOfLife = try await APIClient.shared.request(.wheelOfLife)
            wheelOfLife = wheel
        } catch {
            // Use default values
        }
        isLoading = false
    }
    
    func saveWheelOfLife() async {
        isSaving = true
        let data: [String: Int] = [
            "health": wheelOfLife.health,
            "relationships": wheelOfLife.relationships,
            "finances": wheelOfLife.finances,
            "career": wheelOfLife.career,
            "personalDev": wheelOfLife.personalDev,
            "spirituality": wheelOfLife.spirituality
        ]
        do {
            try await APIClient.shared.requestVoid(.saveWheelOfLife(data: data))
        } catch {
            // Handle error
        }
        isSaving = false
    }
    
    func loadGoals() async {
        isLoading = true
        do {
            let response: GoalsResponse = try await APIClient.shared.request(.goals)
            goals = response.goals
        } catch {
            // Handle error
        }
        isLoading = false
    }
    
    func createGoal(title: String) async {
        let goal: [String: Any] = ["title": title, "status": "active"]
        do {
            try await APIClient.shared.requestVoid(.createGoal(goal: goal))
            await loadGoals()
        } catch {
            // Handle error
        }
    }
    
    func loadEisenhowerTasks() async {
        isLoading = true
        do {
            let response: EisenhowerResponse = try await APIClient.shared.request(.eisenhowerTasks)
            eisenhowerTasks = response.tasks
        } catch {
            // Handle error
        }
        isLoading = false
    }
    
    func createTask(title: String, quadrant: Int) async {
        let task: [String: Any] = ["title": title, "quadrant": quadrant, "completed": false]
        do {
            try await APIClient.shared.requestVoid(.createTask(task: task))
            await loadEisenhowerTasks()
        } catch {
            // Handle error
        }
    }
}
