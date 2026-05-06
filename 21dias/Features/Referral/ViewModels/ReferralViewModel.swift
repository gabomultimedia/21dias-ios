import Foundation
import Combine

class ReferralViewModel: ObservableObject {
    @Published var referralCode = ""
    @Published var totalReferrals = 0
    @Published var activeReferrals = 0
    @Published var rewardsEarned = 0
    
    var shareText: String {
        "¡Únete a 21 Días conmigo! Usa mi código \(referralCode) y ambos ganamos recompensas 🔥\n\nDescarga aquí: arielbrailovsky.com/21dias"
    }
    
    func loadReferralData() {
        Task {
            do {
                let data = try await APIClient.shared.getReferralInfo()
                await MainActor.run {
                    self.referralCode = data.referralCode
                    self.totalReferrals = data.totalReferrals
                    self.activeReferrals = data.activeReferrals
                    self.rewardsEarned = data.rewardsEarned
                }
            } catch {
                print("Error loading referral: \(error)")
            }
        }
    }
}