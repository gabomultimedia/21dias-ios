import Foundation

enum APIEndpoint {
    case login(email: String, password: String)
    case register(name: String, email: String, password: String)
    case lessons
    case lesson(day: Int)
    case completeLesson(day: Int)
    case progress
    case streak
    case badges
    case diary
    case createDiaryEntry(content: String, lessonId: Int?)
    case wheelOfLife
    case saveWheelOfLife(data: [String: Int])
    case goals
    case createGoal(goal: [String: Any])
    case eisenhowerTasks
    case createTask(task: [String: Any])
    case subscribe
    case getReferralInfo
    case useReferralCode(code: String)
    case getLeaderboard(period: String)
    case getLiveFeed
    case getPartners
    case invitePartner
    case removePartner(id: String)
    case getActiveSprints
    case joinSprint(id: String)
    case getSettings
    case updateSettings
    
    var path: String {
        switch self {
        case .login: return "/api/auth/login"
        case .register: return "/api/auth/register"
        case .lessons: return "/api/lessons"
        case .lesson(let day): return "/api/lessons/\(day)"
        case .completeLesson(let day): return "/api/lessons/\(day)/complete"
        case .progress: return "/api/progress"
        case .streak: return "/api/progress/streak"
        case .badges: return "/api/progress/badges"
        case .diary: return "/api/diary"
        case .createDiaryEntry: return "/api/diary"
        case .wheelOfLife: return "/api/wheel-of-life"
        case .saveWheelOfLife: return "/api/wheel-of-life"
        case .goals: return "/api/goals"
        case .createGoal: return "/api/goals"
        case .eisenhowerTasks: return "/api/eisenhower/tasks"
        case .createTask: return "/api/eisenhower/tasks"
        case .subscribe: return "/api/subscribe"
        case .getReferralInfo: return "/api/referral"
        case .useReferralCode(let code): return "/api/referral/use/\(code)"
        case .getLeaderboard(let period): return "/api/leaderboard/\(period)"
        case .getLiveFeed: return "/api/live-feed"
        case .getPartners: return "/api/partners"
        case .invitePartner: return "/api/partners/invite"
        case .removePartner(let id): return "/api/partners/\(id)"
        case .getActiveSprints: return "/api/sprints/active"
        case .joinSprint(let id): return "/api/sprints/\(id)/join"
        case .getSettings: return "/api/settings"
        case .updateSettings: return "/api/settings"
        }
    }
    
    var method: String {
        switch self {
        case .login, .register, .completeLesson, .createDiaryEntry, .saveWheelOfLife, .createGoal, .createTask, .subscribe, .invitePartner, .joinSprint, .updateSettings:
            return "POST"
        case .removePartner:
            return "DELETE"
        default:
            return "GET"
        }
    }
}
