import SwiftUI

struct ShareCardView: View {
    let type: CardType
    let userName: String
    let dayNumber: Int?
    let streak: Int?
    let badge: String?
    let level: Int?
    
    enum CardType {
        case badge, streak, completion, levelUp, referral
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header con gradient
            LinearGradient(
                colors: [.appPrimary, .appPrimaryDark],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .frame(height: 120)
            .overlay(
                VStack {
                    Text(cardTitle)
                        .font(.title.bold())
                        .foregroundColor(.white)
                    Text(cardSubtitle)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.9))
                }
            )
            
            // Content
            VStack(spacing: 16) {
                if let day = dayNumber {
                    Text("Día \(day)")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.appPrimary)
                }
                
                if let streak = streak {
                    HStack {
                        Text("🔥")
                            .font(.title)
                        Text("\(streak) días de racha")
                            .font(.title2.bold())
                    }
                }
                
                if let badge = badge {
                    Text("🎉 \(badge)")
                        .font(.headline)
                }
                
                if let level = level {
                    HStack {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.title)
                            .foregroundColor(.appSecondary)
                        Text("Nivel \(level)")
                            .font(.title2.bold())
                            .foregroundColor(.appSecondary)
                    }
                }
                
                if type == .referral {
                    Text("🎁")
                        .font(.system(size: 60))
                    Text("¡Invita y gana!")
                        .font(.headline)
                }
            }
            .padding()
            
            Spacer()
            
            // Footer con branding
            HStack {
                Image(systemName: "flame.fill")
                    .foregroundColor(.appSecondary)
                Text("21 DÍAS")
                    .font(.caption.bold())
                Spacer()
                Text("#ImpulsoSostenible")
                    .font(.caption)
            }
            .padding()
            .background(Color.appBackground)
        }
        .frame(width: 300, height: 400)
        .background(Color.appSurface)
        .cornerRadius(20)
        .shadow(radius: 10)
        .padding()
    }
    
    var cardTitle: String {
        switch type {
        case .badge: return "Nuevo Logro"
        case .streak: return "¡Racha!"
        case .completion: return "¡Completado!"
        case .levelUp: return "¡Subiste de nivel!"
        case .referral: return "¡Invita!"
        }
    }
    
    var cardSubtitle: String {
        switch type {
        case .badge: return badge ?? "Badge desbloqueado"
        case .streak: return "\(streak ?? 0) días seguidos"
        case .completion: return "21 días de transformación"
        case .levelUp: return "Nivel \(level ?? 1)"
        case .referral: return "Comparte y gana"
        }
    }
}