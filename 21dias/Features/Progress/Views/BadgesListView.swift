import SwiftUI

struct BadgesListView: View {
    @StateObject private var viewModel = BadgesListViewModel()
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 20) {
                ForEach(viewModel.badges) { badge in
                    BadgeView(badge: badge, size: .large)
                }
            }
            .padding()
        }
        .navigationTitle("Insignias")
        .background(Color.appBackground)
        .task {
            await viewModel.loadBadges()
        }
    }
}

@MainActor
class BadgesListViewModel: ObservableObject {
    @Published var badges: [Badge] = []
    
    func loadBadges() async {
        do {
            let response: BadgesResponse = try await APIClient.shared.request(.badges)
            badges = response.badges
        } catch {
            print("Error loading badges: \(error)")
        }
    }
}