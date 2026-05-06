import SwiftUI

struct EisenhowerView: View {
    @StateObject private var viewModel = ToolsViewModel()
    @State private var newTaskText = ""
    @State private var selectedQuadrant = 1
    
    var tasksQ1: [EisenhowerTask] { viewModel.eisenhowerTasks.filter { $0.quadrant == 1 } }
    var tasksQ2: [EisenhowerTask] { viewModel.eisenhowerTasks.filter { $0.quadrant == 2 } }
    var tasksQ3: [EisenhowerTask] { viewModel.eisenhowerTasks.filter { $0.quadrant == 3 } }
    var tasksQ4: [EisenhowerTask] { viewModel.eisenhowerTasks.filter { $0.quadrant == 4 } }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Add Task
                AddTaskView(text: $newTaskText, selectedQuadrant: $selectedQuadrant) {
                    Task {
                        await viewModel.createTask(title: newTaskText, quadrant: selectedQuadrant)
                        newTaskText = ""
                    }
                }
                .padding(.horizontal)
                
                // Quadrants Grid
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    QuadrantCard(
                        title: "🔥 Urgente e Importante",
                        subtitle: "Hacer ahora",
                        tasks: tasksQ1,
                        color: .red
                    )
                    
                    QuadrantCard(
                        title: "📅 No Urgente Importante",
                        subtitle: "Planificar",
                        tasks: tasksQ2,
                        color: .appPrimary
                    )
                    
                    QuadrantCard(
                        title: "🙋 Urgente No Importante",
                        subtitle: "Delegar",
                        tasks: tasksQ3,
                        color: .appSecondary
                    )
                    
                    QuadrantCard(
                        title: "🗑️ No Urgente No Importante",
                        subtitle: "Eliminar",
                        tasks: tasksQ4,
                        color: .gray
                    )
                }
                .padding(.horizontal)
                
                Spacer(minLength: 40)
            }
            .padding(.top)
        }
        .background(Color.appBackground)
        .navigationTitle("Matriz de Eisenhower")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadEisenhowerTasks()
        }
    }
}

struct AddTaskView: View {
    @Binding var text: String
    @Binding var selectedQuadrant: Int
    let onAdd: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            TextField("Nueva tarea...", text: $text)
                .textFieldStyle(.plain)
                .padding()
                .background(Color.appSurface)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
            
            HStack {
                Picker("Cuadrante", selection: $selectedQuadrant) {
                    Text("Q1").tag(1)
                    Text("Q2").tag(2)
                    Text("Q3").tag(3)
                    Text("Q4").tag(4)
                }
                .pickerStyle(.segmented)
                
                Button {
                    onAdd()
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.appPrimary)
                }
                .disabled(text.isEmpty)
            }
        }
        .padding()
        .background(Color.appSurface)
        .cornerRadius(16)
    }
}

struct QuadrantCard: View {
    let title: String
    let subtitle: String
    let tasks: [EisenhowerTask]
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.appCaption)
                    .fontWeight(.semibold)
                    .foregroundColor(color)
                
                Text(subtitle)
                    .font(.appSmall)
                    .foregroundColor(.appTextSecondary)
            }
            
            if tasks.isEmpty {
                Text("Sin tareas")
                    .font(.appCaption)
                    .foregroundColor(.appTextSecondary)
                    .padding(.vertical, 8)
            } else {
                ForEach(tasks) { task in
                    TaskRow(task: task)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.appSurface)
        .cornerRadius(16)
    }
}

struct TaskRow: View {
    let task: EisenhowerTask
    @State private var isCompleted = false
    
    var body: some View {
        HStack(spacing: 10) {
            Button {
                isCompleted.toggle()
            } label: {
                Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isCompleted ? .appSuccess : .gray)
            }
            
            Text(task.title)
                .font(.appCaption)
                .foregroundColor(isCompleted ? .appTextSecondary : .appTextPrimary)
                .strikethrough(isCompleted)
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    NavigationStack {
        EisenhowerView()
    }
}
