import SwiftUI

struct BadgeView: View {
    let badge: Badge
    var size: CGFloat = 80
    
    enum Size {
        case small, medium, large
        
        var value: CGFloat {
            switch self {
            case .small: return 60
            case .medium: return 80
            case .large: return 100
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(isUnlocked ? Color.appSecondary.opacity(0.2) : Color.gray.opacity(0.1))
                    .frame(width: size, height: size)
                
                Text(badge.icon)
                    .font(.system(size: size * 0.5))
                    .opacity(isUnlocked ? 1.0 : 0.5)
            }
            .overlay(
                Circle()
                    .stroke(isUnlocked ? Color.appSecondary : Color.gray.opacity(0.3), lineWidth: 2)
            )
            
            Text(badge.name)
                .font(.appSmall)
                .foregroundColor(isUnlocked ? .appTextPrimary : .appTextSecondary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .frame(width: size + 20)
    }
    
    var isUnlocked: Bool {
        badge.isUnlocked || badge.earnedAt != nil
    }
}

struct StreakBadge: View {
    let streak: Int
    @State private var isAnimating = false
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: "flame.fill")
                .font(.title2)
                .foregroundColor(.appSecondary)
                .scaleEffect(isAnimating ? 1.1 : 1.0)
                .animation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true), value: isAnimating)
            
            Text("\(streak)")
                .font(.appHeadlineBold)
                .foregroundColor(.appTextPrimary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(Color.appSecondary.opacity(0.15))
        .cornerRadius(20)
        .onAppear {
            isAnimating = true
        }
    }
}

#Preview {
    VStack(spacing: 24) {
        BadgeView(badge: Badge(
            id: "1",
            name: "Primer Día",
            description: "Completa tu primer día",
            icon: "🌟",
            earnedAt: "2024-01-01"
        ))
        
        BadgeView(badge: Badge(
            id: "2",
            name: "Reto Pendiente",
            description: "No has completado este reto",
            icon: "🔒",
            earnedAt: nil
        ))
        
        StreakBadge(streak: 7)
    }
}
