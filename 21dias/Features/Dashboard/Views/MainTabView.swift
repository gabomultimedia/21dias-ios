import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            DashboardView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Inicio")
                }
                .tag(0)
            
            LessonsListView()
                .tabItem {
                    Image(systemName: "book.fill")
                    Text("Lecciones")
                }
                .tag(1)
            
            ProgressView()
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("Progreso")
                }
                .tag(2)
            
            ToolsMenuView()
                .tabItem {
                    Image(systemName: "wrench.and.screwdriver.fill")
                    Text("Herramientas")
                }
                .tag(3)
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Perfil")
                }
                .tag(4)
        }
        .tint(.appPrimary)
    }
}

struct LessonsListView: View {
    @StateObject private var viewModel = LessonListViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(viewModel.lessons) { lesson in
                        NavigationLink {
                            LessonView(lesson: lesson)
                        } label: {
                            LessonCardView(lesson: lesson, isCompleted: viewModel.isCompleted(lesson.dayNumber))
                        }
                    }
                }
                .padding()
            }
            .background(Color.appBackground)
            .navigationTitle("Lecciones")
            .task {
                await viewModel.loadLessons()
            }
        }
    }
}

@MainActor
class LessonListViewModel: ObservableObject {
    @Published var lessons: [Lesson] = []
    @Published var isLoading = false
    
    private let userDefaults = UserDefaultsManager.shared
    
    func isCompleted(_ day: Int) -> Bool {
        userDefaults.completedLessons.contains(day)
    }
    
    func loadLessons() async {
        isLoading = true
        do {
            let response: LessonsResponse = try await APIClient.shared.request(.lessons)
            lessons = response.lessons
        } catch {
            // Handle error
        }
        isLoading = false
    }
}

struct ToolsMenuView: View {
    @State private var showWheelOfLife = false
    @State private var showEisenhower = false
    @State private var showGoals = false
    @State private var showDiary = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    ToolCard(icon: "circle.hexagongrid", title: "Rueda de la Vida", color: .appPrimary) {
                        showWheelOfLife = true
                    }
                    
                    ToolCard(icon: "square.grid.2x2", title: "Matriz de Eisenhower", color: .appSecondary) {
                        showEisenhower = true
                    }
                    
                    ToolCard(icon: "target", title: "Metas SMARTER", color: .appAccent) {
                        showGoals = true
                    }
                    
                    ToolCard(icon: "book.closed", title: "Diario", color: .purple) {
                        showDiary = true
                    }
                }
                .padding()
            }
            .background(Color.appBackground)
            .navigationTitle("Herramientas")
            .navigationDestination(isPresented: $showWheelOfLife) { WheelOfLifeView() }
            .navigationDestination(isPresented: $showEisenhower) { EisenhowerView() }
            .navigationDestination(isPresented: $showGoals) { SmarterGoalView() }
            .navigationDestination(isPresented: $showDiary) { DiaryView() }
        }
    }
}

struct ToolCard: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.largeTitle)
                    .foregroundColor(color)
                
                Text(title)
                    .font(.appBody)
                    .fontWeight(.medium)
                    .foregroundColor(.appTextPrimary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 32)
            .background(Color.appSurface)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
        }
    }
}

#Preview {
    MainTabView()
}
