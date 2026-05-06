import SwiftUI

struct StreakView: View {
    @StateObject var viewModel = StreakViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Streak Header
                HStack {
                    VStack(alignment: .leading) {
                        Text("Tu Racha")
                            .font(.title2.bold())
                        Text("\(viewModel.currentStreak) días")
                            .font(.system(size: 48, weight: .bold))
                            .foregroundColor(.streakFlame)
                    }
                    Spacer()
                    StreakBadge(streak: viewModel.currentStreak, size: 80)
                }
                .padding()
                .background(Color.appSurface)
                .cornerRadius(16)
                
                // Streak Shields
                HStack {
                    Image(systemName: "shield.fill")
                        .foregroundColor(.blue)
                    Text("\(viewModel.streakShields) Streak Shields disponibles")
                        .font(.subheadline)
                    Spacer()
                }
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(12)
                
                // Flame Animation based on streak
                if viewModel.currentStreak >= 7 {
                    VStack {
                        Text(flameEmoji)
                            .font(.system(size: 60))
                        Text(flameMessage)
                            .font(.headline)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                }
                
                // Longest Streak
                HStack {
                    Image(systemName: "trophy.fill")
                        .foregroundColor(.yellow)
                    Text("Mejor racha: \(viewModel.longestStreak) días")
                    Spacer()
                }
                .padding()
                .background(Color.appSurface)
                .cornerRadius(12)
                
                // Progress to next badge
                VStack(alignment: .leading, spacing: 8) {
                    Text("Próximo badge: \(viewModel.nextBadge)")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    ProgressView(value: viewModel.progressToNextBadge)
                        .tint(.streakFlame)
                    Text("\(viewModel.daysToNextBadge) días para desbloquear")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color.appSurface)
                .cornerRadius(12)
                
                // How to protect your streak
                VStack(alignment: .leading, spacing: 12) {
                    Text("¿Cómo proteger tu racha?")
                        .font(.headline)
                    HStack {
                        Image(systemName: "shield.lefthalf.filled")
                            .foregroundColor(.appPrimary)
                        Text("Usa un Streak Shield si no puedes completar un día")
                            .font(.subheadline)
                    }
                    HStack {
                        Image(systemName: "flame.fill")
                            .foregroundColor(.appSecondary)
                        Text("Completa al menos una lección al día")
                            .font(.subheadline)
                    }
                }
                .padding()
                .background(Color.appSurface)
                .cornerRadius(12)
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Racha")
        .background(Color.appBackground)
        .onAppear { viewModel.loadStreak() }
    }
    
    var flameEmoji: String {
        if viewModel.currentStreak >= 21 { return "🐉🔥" }
        if viewModel.currentStreak >= 14 { return "🔥🔥" }
        if viewModel.currentStreak >= 7 { return "🔥" }
        return "🉑"
    }
    
    var flameMessage: String {
        if viewModel.currentStreak >= 21 { return "¡DRAGÓN DE FUEGO! Eres legendario" }
        if viewModel.currentStreak >= 14 { return "¡Imparable! Sigue así" }
        if viewModel.currentStreak >= 7 { return "¡En llamas! No pares" }
        return "¡Sigue así!"
    }
}