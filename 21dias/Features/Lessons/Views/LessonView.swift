import SwiftUI
import AVKit

struct LessonView: View {
    @StateObject private var viewModel: LessonViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var player: AVPlayer?
    
    init(lesson: Lesson) {
        _viewModel = StateObject(wrappedValue: LessonViewModel(lesson: lesson))
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Día \(viewModel.lesson.dayNumber)")
                            .font(.appCaption)
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.appPrimary)
                            .cornerRadius(12)
                        
                        Spacer()
                        
                        if viewModel.isCompleted {
                            HStack(spacing: 4) {
                                Image(systemName: "checkmark.circle.fill")
                                Text("Completado")
                            }
                            .font(.appCaption)
                            .foregroundColor(.appSuccess)
                        }
                    }
                    
                    Text(viewModel.lesson.title)
                        .font(.appTitleBold)
                        .foregroundColor(.appTextPrimary)
                    
                    HStack(spacing: 12) {
                        Label("+\(viewModel.lesson.xpValue) XP", systemImage: "star.fill")
                            .font(.appCaption)
                            .foregroundColor(.appSecondary)
                        
                        if viewModel.lesson.isPremium {
                            Label("Premium", systemImage: "crown.fill")
                                .font(.appCaption)
                                .foregroundColor(.appSecondary)
                        }
                    }
                }
                
                // Video Player
                if let videoUrl = viewModel.lesson.videoUrl, let url = URL(string: videoUrl) {
                    VideoPlayer(player: AVPlayer(url: url))
                        .frame(height: 220)
                        .cornerRadius(16)
                }
                
                // Content
                Text(viewModel.lesson.content)
                    .font(.appBody)
                    .foregroundColor(.appTextPrimary)
                    .lineSpacing(6)
                
                // Audio Player
                if let audioUrl = viewModel.lesson.audioUrl, let url = URL(string: audioUrl) {
                    AudioPlayerView(audioUrl: url)
                        .padding(.vertical)
                }
                
                // Exercise
                if let exercise = viewModel.lesson.exerciseInstructions {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "pencil.line")
                                .foregroundColor(.appPrimary)
                            Text("Ejercicio")
                                .font(.appHeadline)
                                .foregroundColor(.appTextPrimary)
                        }
                        
                        Text(exercise)
                            .font(.appBody)
                            .foregroundColor(.appTextSecondary)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.appPrimary.opacity(0.05))
                            .cornerRadius(12)
                        
                        TextEditor(text: $viewModel.exerciseText)
                            .font(.appBody)
                            .frame(height: 120)
                            .padding(8)
                            .background(Color.appSurface)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                    }
                }
                
                // Complete Button
                if !viewModel.isCompleted {
                    PrimaryButton(
                        title: "Completar Lección",
                        action: {
                            Task {
                                await viewModel.completeLesson()
                            }
                        },
                        isLoading: viewModel.isCompleting,
                        isDisabled: viewModel.lesson.exerciseInstructions != nil && viewModel.exerciseText.isEmpty
                    )
                }
                
                if let error = viewModel.errorMessage {
                    Text(error)
                        .font(.appCaption)
                        .foregroundColor(.appError)
                }
                
                Spacer(minLength: 40)
            }
            .padding()
        }
        .background(Color.appBackground)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.appTextPrimary)
                }
            }
        }
        .overlay {
            if viewModel.showConfetti {
                ConfettiView()
                    .ignoresSafeArea()
            }
        }
    }
}

struct AudioPlayerView: View {
    let audioUrl: URL
    @State private var isPlaying = false
    @State private var player: AVPlayer?
    
    var body: some View {
        HStack(spacing: 16) {
            Button {
                if isPlaying {
                    player?.pause()
                } else {
                    player?.play()
                }
                isPlaying.toggle()
            } label: {
                Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                    .font(.system(size: 44))
                    .foregroundColor(.appPrimary)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Audio de Meditación")
                    .font(.appBody)
                    .foregroundColor(.appTextPrimary)
                Text("Presiona para reproducir")
                    .font(.appCaption)
                    .foregroundColor(.appTextSecondary)
            }
        }
        .padding()
        .background(Color.appSurface)
        .cornerRadius(12)
        .onAppear {
            player = AVPlayer(url: audioUrl)
        }
    }
}

struct LessonCardView: View {
    let lesson: Lesson
    let isCompleted: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(isCompleted ? Color.appPrimary : Color.gray.opacity(0.15))
                    .frame(width: 50, height: 50)
                
                if isCompleted {
                    Image(systemName: "checkmark")
                        .foregroundColor(.white)
                        .font(.system(size: 20, weight: .bold))
                } else {
                    Text("\(lesson.dayNumber)")
                        .font(.appBody)
                        .fontWeight(.semibold)
                        .foregroundColor(.appTextSecondary)
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(lesson.title)
                    .font(.appBody)
                    .fontWeight(.medium)
                    .foregroundColor(.appTextPrimary)
                    .lineLimit(1)
                
                HStack(spacing: 8) {
                    Text("Semana \(lesson.week)")
                        .font(.appSmall)
                        .foregroundColor(.appTextSecondary)
                    
                    Text("•")
                        .foregroundColor(.appTextSecondary)
                    
                    Text("+\(lesson.xpValue) XP")
                        .font(.appSmall)
                        .foregroundColor(.appSecondary)
                }
            }
            
            Spacer()
            
            if lesson.isPremium {
                Image(systemName: "crown.fill")
                    .foregroundColor(.appSecondary)
            }
            
            Image(systemName: "chevron.right")
                .foregroundColor(.appTextSecondary)
        }
        .padding(16)
        .background(Color.appSurface)
        .cornerRadius(16)
    }
}

struct ConfettiView: View {
    @State private var particles: [ConfettiParticle] = []
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(particles) { particle in
                    Circle()
                        .fill(particle.color)
                        .frame(width: particle.size, height: particle.size)
                        .position(particle.position)
                }
            }
            .onAppear {
                createParticles(in: geometry.size)
            }
        }
    }
    
    private func createParticles(in size: CGSize) {
        let colors: [Color] = [.appPrimary, .appSecondary, .appAccent, .purple, .pink]
        
        for _ in 0..<50 {
            let particle = ConfettiParticle(
                position: CGPoint(x: size.width / 2, y: size.height / 2),
                color: colors.randomElement()!,
                size: CGFloat.random(in: 6...12)
            )
            particles.append(particle)
            
            withAnimation(.easeOut(duration: 2)) {
                if let index = particles.firstIndex(where: { $0.id == particle.id }) {
                    particles[index].position = CGPoint(
                        x: CGFloat.random(in: 0...size.width),
                        y: CGFloat.random(in: -50...size.height)
                    )
                }
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            particles.removeAll()
        }
    }
}

struct ConfettiParticle: Identifiable {
    let id = UUID()
    var position: CGPoint
    let color: Color
    let size: CGFloat
}

#Preview {
    NavigationStack {
        LessonView(lesson: Lesson(
            id: "1",
            dayNumber: 1,
            week: 1,
            title: "Bienvenida al Programa",
            content: "En esta lección aprenderás los fundamentos del cambio sostenible...",
            videoUrl: nil,
            audioUrl: nil,
            exerciseInstructions: "Escribe en tu diario tres hábitos que te gustaría cambiar.",
            badgeReward: "🌟",
            xpValue: 50,
            isPremium: false
        ))
    }
}
