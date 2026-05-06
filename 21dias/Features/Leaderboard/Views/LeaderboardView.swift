import SwiftUI

struct LeaderboardView: View {
    @StateObject var viewModel = LeaderboardViewModel()
    @State private var selectedPeriod = 0
    
    var body: some View {
        VStack(spacing: 0) {
            // Period Selector
            Picker("Periodo", selection: $selectedPeriod) {
                Text("Semanal").tag(0)
                Text("Global").tag(1)
                Text("Amigos").tag(2)
            }
            .pickerStyle(.segmented)
            .padding()
            .onChange(of: selectedPeriod) { _, newValue in
                viewModel.loadLeaderboard(period: LeaderboardPeriod.allCases[newValue])
            }
            
            // Top 3
            if viewModel.ranks.count >= 3 {
                HStack(spacing: -10) {
                    TopRankCard(rank: 2, user: viewModel.ranks[1])
                    TopRankCard(rank: 1, user: viewModel.ranks[0])
                    TopRankCard(rank: 3, user: viewModel.ranks[2])
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            
            // Rest of leaderboard
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(Array(viewModel.ranks.enumerated().dropFirst(3)), id: \.element.id) { index, user in
                        LeaderboardRowView(rank: index + 4, user: user, isYou: user.id == viewModel.currentUserId)
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Rankings")
        .background(Color.appBackground)
        .onAppear { viewModel.loadLeaderboard(period: .weekly) }
    }
}

struct TopRankCard: View {
    let rank: Int
    let user: LeaderboardUser
    
    var rankColor: Color {
        switch rank {
        case 1: return .yellow
        case 2: return .gray
        case 3: return .orange
        default: return .gray
        }
    }
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .fill(rankColor.opacity(0.2))
                    .frame(width: rank == 1 ? 90 : 70, height: rank == 1 ? 90 : 70)
                Text(String(user.displayName.prefix(2)).uppercased())
                    .font(.title2.bold())
                    .foregroundColor(rankColor)
            }
            Text(user.displayName)
                .font(.caption)
                .lineLimit(1)
            Text("\(user.xp) XP")
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(width: 100)
    }
}

struct LeaderboardRowView: View {
    let rank: Int
    let user: LeaderboardUser
    let isYou: Bool
    
    var body: some View {
        HStack {
            Text("#\(rank)")
                .font(.headline)
                .frame(width: 40)
            
            Circle()
                .fill(Color.appPrimary.opacity(0.2))
                .frame(width: 40, height: 40)
                .overlay(
                    Text(String(user.displayName.prefix(2)).uppercased())
                        .font(.caption.bold())
                        .foregroundColor(.appPrimary)
                )
            
            VStack(alignment: .leading) {
                Text(user.displayName)
                    .font(.subheadline)
                if isYou {
                    Text("Tú")
                        .font(.caption)
                        .foregroundColor(.appPrimary)
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text("\(user.xp) XP")
                    .font(.subheadline.bold())
                    .foregroundColor(.appPrimary)
                Text("🔥 \(user.streak)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(isYou ? Color.appPrimary.opacity(0.1) : Color.appSurface)
        .cornerRadius(12)
    }
}