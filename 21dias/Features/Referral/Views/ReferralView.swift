import SwiftUI

struct ReferralView: View {
    @StateObject var viewModel = ReferralViewModel()
    @State private var showShareSheet = false
    @State private var selectedCardType: ShareCardView.CardType = .referral
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 8) {
                    Text("🎁 Invita a tus amigos")
                        .font(.title.bold())
                    Text("Ambos ganan recompensas")
                        .foregroundColor(.secondary)
                }
                .padding(.top)
                
                // Your Code
                VStack(spacing: 12) {
                    Text("Tu código")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    HStack {
                        Text(viewModel.referralCode.isEmpty ? "CARGANDO..." : viewModel.referralCode)
                            .font(.system(size: 28, weight: .bold, design: .monospaced))
                            .foregroundColor(.appPrimary)
                        
                        Button(action: {
                            if !viewModel.referralCode.isEmpty {
                                UIPasteboard.general.string = viewModel.referralCode
                            }
                        }) {
                            Image(systemName: "doc.on.doc")
                                .foregroundColor(.appPrimary)
                        }
                    }
                    .padding()
                    .background(Color.appPrimary.opacity(0.1))
                    .cornerRadius(12)
                }
                .padding()
                .background(Color.appSurface)
                .cornerRadius(16)
                .padding(.horizontal)
                
                // Rewards Tiers
                VStack(alignment: .leading, spacing: 16) {
                    Text("Recompensas")
                        .font(.headline)
                    
                    RewardTierView(step: 1, description: "Tu amigo completa Día 3", reward: "+100 XP + Streak Shield")
                    RewardTierView(step: 2, description: "Tu amigo completa Día 7", reward: "+250 XP + 7 días Premium")
                    RewardTierView(step: 3, description: "Tu amigo se suscribe", reward: "$5 crédito para tu suscripción")
                }
                .padding()
                .background(Color.appSurface)
                .cornerRadius(16)
                .padding(.horizontal)
                
                // Stats
                VStack(spacing: 12) {
                    Text("Tus referrals")
                        .font(.headline)
                    
                    HStack(spacing: 20) {
                        StatBox(value: "\(viewModel.totalReferrals)", label: "Invitados")
                        StatBox(value: "\(viewModel.activeReferrals)", label: "Activos")
                        StatBox(value: "\(viewModel.rewardsEarned)", label: "Recompensas")
                    }
                }
                .padding()
                .background(Color.appSurface)
                .cornerRadius(16)
                .padding(.horizontal)
                
                // Share Button
                Button(action: { showShareSheet = true }) {
                    HStack {
                        Image(systemName: "square.and.arrow.up")
                        Text("Compartir código")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.appPrimary)
                    .cornerRadius(12)
                }
                .padding(.horizontal)
                
                // Transformation Cards Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("📸 Genera tu tarjeta para compartir")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ShareCardPreviewButton(
                                title: "Racha",
                                icon: "🔥",
                                action: { selectedCardType = .streak }
                            )
                            ShareCardPreviewButton(
                                title: "Logro",
                                icon: "🏆",
                                action: { selectedCardType = .badge }
                            )
                            ShareCardPreviewButton(
                                title: "Nivel",
                                icon: "⬆️",
                                action: { selectedCardType = .levelUp }
                            )
                            ShareCardPreviewButton(
                                title: "Día 21",
                                icon: "✨",
                                action: { selectedCardType = .completion }
                            )
                        }
                        .padding(.horizontal)
                    }
                }
                
                Spacer()
            }
        }
        .navigationTitle("Invitar")
        .background(Color.appBackground)
        .sheet(isPresented: $showShareSheet) {
            ShareSheet(items: [viewModel.shareText])
        }
        .fullScreenCover(isPresented: .constant(selectedCardType != .referral)) {
            ShareCardView(
                type: selectedCardType,
                userName: "Usuario",
                dayNumber: selectedCardType == .completion ? 21 : nil,
                streak: selectedCardType == .streak ? 7 : nil,
                badge: selectedCardType == .badge ? "Racha 7" : nil,
                level: selectedCardType == .levelUp ? 5 : nil
            )
        }
        .onAppear { viewModel.loadReferralData() }
    }
}

struct RewardTierView: View {
    let step: Int
    let description: String
    let reward: String
    
    var body: some View {
        HStack {
            ZStack {
                Circle()
                    .fill(step <= 2 ? Color.appPrimary : Color.gray.opacity(0.3))
                    .frame(width: 32, height: 32)
                Text("\(step)")
                    .foregroundColor(.white)
                    .font(.bold)
            }
            VStack(alignment: .leading) {
                Text(description)
                    .font(.subheadline)
                Text(reward)
                    .font(.caption)
                    .foregroundColor(.appPrimary)
            }
            Spacer()
        }
    }
}

struct StatBox: View {
    let value: String
    let label: String
    
    var body: some View {
        VStack {
            Text(value)
                .font(.title.bold())
                .foregroundColor(.appPrimary)
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

struct ShareCardPreviewButton: View {
    let title: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Text(icon)
                    .font(.title)
                Text(title)
                    .font(.caption)
                    .foregroundColor(.appTextPrimary)
            }
            .frame(width: 80, height: 80)
            .background(Color.appSurface)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.1), radius: 4)
        }
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}