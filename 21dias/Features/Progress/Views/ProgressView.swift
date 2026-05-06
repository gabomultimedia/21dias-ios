import SwiftUI

struct ProgressView: View {
    @StateObject private var viewModel = ProgressViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Streak Card
                    if let streak = viewModel.streak {
                        StreakCard(streak: streak)
                            .padding(.horizontal)
                    }
                    
                    // XP Progress
                    if let progress = viewModel.progress {
                        XPDetailCard(progress: progress)
                            .padding(.horizontal)
                    }
                    
                    // Badges
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("Insignias")
                                .font(.appHeadline)
                                .foregroundColor(.appTextPrimary)
                            Spacer()
                            NavigationLink {
                                BadgesListView()
                            } label: {
                                Text("Ver todas")
                                    .font(.appSmall)
                                    .foregroundColor(.appPrimary)
                            }
                        }
                        .padding(.horizontal)
                        
                        if viewModel.badges.isEmpty {
                            EmptyBadgesView()
                                .padding(.horizontal)
                        } else {
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible()),
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 20) {
                                ForEach(viewModel.badges) { badge in
                                    BadgeView(badge: badge)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    Spacer(minLength: 40)
                }
                .padding(.top)
            }
            .background(Color.appBackground)
            .navigationTitle("Mi Progreso")
            .task {
                await viewModel.loadProgress()
            }
            .refreshable {
                await viewModel.loadProgress()
            }
        }
    }
}

struct StreakCard: View {
    let streak: Streak
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Racha Actual")
                    .font(.appSubheadline)
                    .foregroundColor(.appTextSecondary)
                Spacer()
            }
            
            HStack(alignment: .bottom, spacing: 8) {
                Image(systemName: "flame.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.appSecondary)
                    .scaleEffect(isAnimating ? 1.1 : 1.0)
                    .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: isAnimating)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(streak.currentStreak)")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.appTextPrimary)
                    
                    Text("días consecutivos")
                        .font(.appCaption)
                        .foregroundColor(.appTextSecondary)
                }
                
                Spacer()
            }
            
            HStack {
                StatBox(title: "Mejor racha", value: "\(streak.longestStreak)")
                Spacer()
                StatBox(title: "Última actividad", value: streak.lastActivityDate ?? "—")
            }
        }
        .padding(20)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.appSecondary.opacity(0.1), Color.appSurface]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(16)
        .onAppear {
            isAnimating = true
        }
    }
}

struct StatBox: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.appSmall)
                .foregroundColor(.appTextSecondary)
            Text(value)
                .font(.appBody)
                .fontWeight(.semibold)
                .foregroundColor(.appTextPrimary)
        }
        .padding(12)
        .background(Color.appSurface)
        .cornerRadius(12)
    }
}

struct XPDetailCard: View {
    let progress: Progress
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Experiencia Total")
                    .font(.appSubheadline)
                    .foregroundColor(.appTextSecondary)
                Spacer()
                
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.appSecondary)
                    Text("\(progress.xpTotal) XP")
                        .font(.appHeadlineBold)
                        .foregroundColor(.appSecondary)
                }
            }
            
            VStack(spacing: 8) {
                ProgressBar(
                    progress: progress.percentage,
                    height: 16,
                    foregroundColor: .appPrimary
                )
                
                HStack {
                    Text("\(progress.completedDays)/\(progress.totalDays) días")
                        .font(.appCaption)
                        .foregroundColor(.appTextSecondary)
                    Spacer()
                    Text("\(Int(progress.percentage * 100))%")
                        .font(.appCaption)
                        .fontWeight(.semibold)
                        .foregroundColor(.appPrimary)
                }
            }
        }
        .padding(20)
        .background(Color.appSurface)
        .cornerRadius(16)
    }
}

struct EmptyBadgesView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "trophy")
                .font(.system(size: 48))
                .foregroundColor(.gray.opacity(0.5))
            
            Text("Aún no has desbloqueado insignias")
                .font(.appBody)
                .foregroundColor(.appTextSecondary)
            
            Text("Completa lecciones para ganar insignias")
                .font(.appCaption)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }
}

struct StreakView: View {
    let streak: Streak
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "flame.fill")
                .font(.title)
                .foregroundColor(.appSecondary)
            
            VStack(alignment: .leading, spacing: 2) {
                Text("\(streak.currentStreak) días")
                    .font(.appBody)
                    .fontWeight(.semibold)
                    .foregroundColor(.appTextPrimary)
                
                Text("de racha")
                    .font(.appSmall)
                    .foregroundColor(.appTextSecondary)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.appSecondary.opacity(0.15))
        .cornerRadius(20)
    }
}

#Preview {
    ProgressView()
}
