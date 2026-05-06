import Foundation

// MARK: - User
struct User: Codable {
    let id: String
    let name: String
    let email: String
    let isPremium: Bool
    let createdAt: String
}

// MARK: - Lesson
struct Lesson: Codable, Identifiable {
    let id: String
    let dayNumber: Int
    let week: Int
    let title: String
    let content: String
    let videoUrl: String?
    let audioUrl: String?
    let exerciseInstructions: String?
    let badgeReward: String?
    let xpValue: Int
    let isPremium: Bool
}

// MARK: - Progress
struct Progress: Codable {
    let completedDays: Int
    let totalDays: Int
    let currentStreak: Int
    let xpTotal: Int
    let percentage: Double
}

// MARK: - Streak
struct Streak: Codable {
    let currentStreak: Int
    let longestStreak: Int
    let lastActivityDate: String?
    let streakShields: Int
    let streakFreezesUsed: Int
}

// MARK: - Leaderboard
struct LeaderboardUser: Codable, Identifiable {
    let id: String
    let displayName: String
    let xp: Int
    let streak: Int
    let rank: Int
    let level: Int
}

// MARK: - Referral
struct ReferralInfo: Codable {
    let referralCode: String
    let totalReferrals: Int
    let activeReferrals: Int
    let rewardsEarned: Int
}

// MARK: - Live Feed
struct LiveFeedItem: Codable, Identifiable {
    let id: String
    let dayCompleted: Int
    let streak: Int
    let timeAgo: String
    let isAnonymous: Bool
}

// MARK: - Sprint Challenge
struct SprintChallenge: Codable, Identifiable {
    let id: String
    let title: String
    let description: String
    let startDate: String
    let endDate: String
    let xpReward: Int
    let participants: Int
    let userJoined: Bool
}

// MARK: - Badge
struct Badge: Codable, Identifiable {
    let id: String
    let name: String
    let description: String
    let icon: String
    let earnedAt: String?
    let isUnlocked: Bool
}

// MARK: - Diary
struct DiaryEntry: Codable, Identifiable {
    let id: String
    let lessonId: Int?
    let content: String
    let createdAt: String
    let tags: [String]?
}

// MARK: - Goals
struct Goal: Codable, Identifiable {
    let id: String
    let title: String
    let status: String
    let createdAt: String
}

// MARK: - Eisenhower Tasks
struct EisenhowerTask: Codable, Identifiable {
    let id: String
    let title: String
    let quadrant: Int
    let completed: Bool
}

// MARK: - Wheel of Life
struct WheelOfLife: Codable {
    let health: Int
    let relationships: Int
    let finances: Int
    let career: Int
    let personalDev: Int
    let spirituality: Int

    init(health: Int = 5, relationships: Int = 5, finances: Int = 5,
         career: Int = 5, personalDev: Int = 5, spirituality: Int = 5) {
        self.health = health
        self.relationships = relationships
        self.finances = finances
        self.career = career
        self.personalDev = personalDev
        self.spirituality = spirituality
    }
}

// MARK: - API Responses
struct AuthResponse: Codable {
    let token: String
    let user: User
}

struct LessonsResponse: Codable {
    let lessons: [Lesson]
}

struct BadgesResponse: Codable {
    let badges: [Badge]
}

struct DiaryResponse: Codable {
    let entries: [DiaryEntry]
}

struct GoalsResponse: Codable {
    let goals: [Goal]
}

struct EisenhowerResponse: Codable {
    let tasks: [EisenhowerTask]
}

// MARK: - Partners / Accountability
struct AccountabilityPartner: Codable, Identifiable {
    let id: String
    let partnerId: String
    let partnerName: String
    let partnerStreak: Int
    let partnerActiveToday: Bool
    let status: String
    let createdAt: String
}

struct PartnersResponse: Codable {
    let partners: [AccountabilityPartner]
}