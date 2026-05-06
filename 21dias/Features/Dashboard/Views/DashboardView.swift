import SwiftUI

struct DashboardView: View {
    @StateObject private var viewModel = DashboardViewModel()
    @State private var showLesson = false
    @State private var showWheelOfLife = false
    @State private var showDiary = false
    @State private var showGoals = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Greeting
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(viewModel.greeting)
                                .font(.appSubheadline)
                                .foregroundColor(.appTextSecondary)
                            
                            Text(viewModel.userName)
                                .font(.appTitleBold)
                                .foregroundColor(.appTextPrimary)
                        }
                        Spacer()
                        
                        if let streak = viewModel.streak {
                            StreakBadge(streak: streak.currentStreak)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Today's Lesson Card
                    if let lesson = viewModel.todayLesson {
                        TodayLessonCard(lesson: lesson) {
                            showLesson = true
                        }
                        .padding(.horizontal)
                    }
                    
                    // Weekly Progress
                    WeeklyProgressView(days: viewModel.weekProgress)
                        .padding(.horizontal)
                    
                    // XP Progress
                    if let progress = viewModel.progress {
                        XPProgressView(progress: progress)
                            .padding(.horizontal)
                    }
                    
                    // Quick Access
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Herramientas")
                            .font(.appHeadline)
                            .foregroundColor(.appTextPrimary)
                            .padding(.horizontal)
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 16) {
                            QuickAccessButton(
                                icon: "circle.hexagongrid",
                                title: "Rueda de la Vida",
                                color: .appPrimary
                            ) {
                                showWheelOfLife = true
                            }
                            
                            QuickAccessButton(
                                icon: "book.closed",
                                title: "Diario",
                                color: .appAccent
                            ) {
                                showDiary = true
                            }
                            
                            QuickAccessButton(
                                icon: "target",
                                title: "Metas",
                                color: .appSecondary
                            ) {
                                showGoals = true
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    Spacer(minLength: 100)
                }
                .padding(.top)
            }
            .background(Color.appBackground)
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(isPresented: $showLesson) {
                if let lesson = viewModel.todayLesson {
                    LessonView(lesson: lesson)
                }
            }
            .navigationDestination(isPresented: $showWheelOfLife) {
                WheelOfLifeView()
            }
            .navigationDestination(isPresented: $showDiary) {
                DiaryView()
            }
            .navigationDestination(isPresented: $showGoals) {
                SmarterGoalView()
            }
            .task {
                await viewModel.loadDashboard()
            }
            .refreshable {
                await viewModel.loadDashboard()
            }
        }
    }
}

struct TodayLessonCard: View {
    let lesson: Lesson
    let action: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Lección del Día")
                        .font(.appCaption)
                        .foregroundColor(.appTextSecondary)
                    
                    Text("Día \(lesson.dayNumber)")
                        .font(.appHeadlineBold)
                        .foregroundColor(.appTextPrimary)
                }
                Spacer()
                
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.appSecondary)
                    Text("+\(lesson.xpValue) XP")
                        .font(.appCaption)
                        .fontWeight(.semibold)
                        .foregroundColor(.appSecondary)
                }
            }
            
            Text(lesson.title)
                .font(.appBody)
                .foregroundColor(.appTextPrimary)
                .lineLimit(2)
            
            PrimaryButton(title: "Comenzar", action: action)
        }
        .padding(20)
        .background(Color.appSurface)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
    }
}

struct WeeklyProgressView: View {
    let days: [Bool]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Esta Semana")
                .font(.appHeadline)
                .foregroundColor(.appTextPrimary)
            
            HStack(spacing: 8) {
                ForEach(0..<7, id: \.self) { index in
                    VStack(spacing: 6) {
                        ZStack {
                            Circle()
                                .fill(days[index] ? Color.appPrimary : Color.gray.opacity(0.15))
                                .frame(width: 40, height: 40)
                            
                            if days[index] {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.white)
                                    .font(.system(size: 16, weight: .bold))
                            } else {
                                Text("\(index + 1)")
                                    .font(.appCaption)
                                    .foregroundColor(.appTextSecondary)
                            }
                        }
                    }
                }
            }
        }
        .padding(20)
        .background(Color.appSurface)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
    }
}

struct XPProgressView: View {
    let progress: Progress
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Tu Progreso")
                    .font(.appHeadline)
                    .foregroundColor(.appTextPrimary)
                Spacer()
                Text("\(progress.xpTotal) XP")
                    .font(.appSubheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.appSecondary)
            }
            
            ProgressBar(
                progress: progress.percentage,
                height: 12,
                foregroundColor: .appPrimary
            )
            
            Text("\(progress.completedDays)/\(progress.totalDays) días completados")
                .font(.appCaption)
                .foregroundColor(.appTextSecondary)
        }
        .padding(20)
        .background(Color.appSurface)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
    }
}

struct QuickAccessButton: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.title)
                    .foregroundColor(color)
                
                Text(title)
                    .font(.appSmall)
                    .foregroundColor(.appTextPrimary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(Color.appSurface)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
        }
    }
}

#Preview {
    DashboardView()
}
