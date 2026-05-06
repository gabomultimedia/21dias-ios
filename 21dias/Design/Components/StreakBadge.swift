import SwiftUI

struct StreakBadge: View {
    let streak: Int
    let size: CGFloat
    
    var body: some View {
        ZStack {
            Circle()
                .fill(streak >= 21 ? Color.streakFlame : Color.orange)
                .frame(width: size, height: size)
            if streak >= 21 {
                Image(systemName: "flame.fill")
                    .font(.system(size: size * 0.5))
                    .foregroundColor(.white)
                Image(systemName: "sparkles")
                    .font(.system(size: size * 0.2))
                    .foregroundColor(.yellow)
                    .offset(x: size * 0.3, y: -size * 0.3)
            } else {
                Text("\(streak)")
                    .font(.system(size: size * 0.4, weight: .bold))
                    .foregroundColor(.white)
            }
        }
    }
}