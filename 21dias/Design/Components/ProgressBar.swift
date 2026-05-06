import SwiftUI

struct ProgressBar: View {
    let progress: Double
    var height: CGFloat = 8
    var backgroundColor: Color = Color.gray.opacity(0.2)
    var foregroundColor: Color = Color.appPrimary
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: height / 2)
                    .fill(backgroundColor)
                    .frame(height: height)
                
                RoundedRectangle(cornerRadius: height / 2)
                    .fill(foregroundColor)
                    .frame(width: max(0, min(CGFloat(progress) * geometry.size.width, geometry.size.width)), height: height)
                    .animation(.easeInOut(duration: 0.3), value: progress)
            }
        }
        .frame(height: height)
    }
}

struct CircularProgressBar: View {
    let progress: Double
    var lineWidth: CGFloat = 8
    var backgroundColor: Color = Color.gray.opacity(0.2)
    var foregroundColor: Color = Color.appPrimary
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(backgroundColor, lineWidth: lineWidth)
            
            Circle()
                .trim(from: 0, to: CGFloat(min(progress, 1.0)))
                .stroke(foregroundColor, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 0.5), value: progress)
        }
    }
}

#Preview {
    VStack(spacing: 32) {
        ProgressBar(progress: 0.65)
            .padding(.horizontal)
        
        CircularProgressBar(progress: 0.75)
            .frame(width: 100, height: 100)
            .padding()
    }
}
