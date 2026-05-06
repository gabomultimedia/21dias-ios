import SwiftUI

struct SmarterGoalView: View {
    @StateObject private var viewModel = ToolsViewModel()
    @State private var newGoalTitle = ""
    @State private var expandedGoalId: String?
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Info Card
                    InfoCard()
                        .padding(.horizontal)
                    
                    // Add Goal
                    AddGoalView(text: $newGoalTitle) {
                        Task {
                            await viewModel.createGoal(title: newGoalTitle)
                            newGoalTitle = ""
                        }
                    }
                    .padding(.horizontal)
                    
                    // Goals List
                    if viewModel.goals.isEmpty {
                        EmptyGoalsView()
                            .padding(.horizontal)
                    } else {
                        VStack(spacing: 12) {
                            ForEach(viewModel.goals) { goal in
                                GoalCard(goal: goal, isExpanded: expandedGoalId == goal.id) {
                                    withAnimation {
                                        expandedGoalId = expandedGoalId == goal.id ? nil : goal.id
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    Spacer(minLength: 40)
                }
                .padding(.top)
            }
            .background(Color.appBackground)
            .navigationTitle("Metas SMARTER")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                await viewModel.loadGoals()
            }
        }
    }
}

struct InfoCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "lightbulb.fill")
                    .foregroundColor(.appSecondary)
                Text("Metas SMARTER")
                    .font(.appHeadline)
                    .foregroundColor(.appTextPrimary)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                SMARTERItem(letter: "S", meaning: "Específica")
                SMARTERItem(letter: "M", meaning: "Medible")
                SMARTERItem(letter: "A", meaning: "Alcanzable")
                SMARTERItem(letter: "R", meaning: "Relevante")
                SMARTERItem(letter: "T", meaning: "Limitada en tiempo")
                SMARTERItem(letter: "E", meaning: "Evaluable")
                SMARTERItem(letter: "R", meaning: "Recompensable")
            }
        }
        .padding()
        .background(Color.appSurface)
        .cornerRadius(16)
    }
}

struct SMARTERItem: View {
    let letter: String
    let meaning: String
    
    var body: some View {
        HStack(spacing: 8) {
            Text(letter)
                .font(.appCaption)
                .fontWeight(.bold)
                .foregroundColor(.appPrimary)
                .frame(width: 20)
            
            Text(meaning)
                .font(.appCaption)
                .foregroundColor(.appTextSecondary)
        }
    }
}

struct AddGoalView: View {
    @Binding var text: String
    let onAdd: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            TextField("Escribe tu meta...", text: $text)
                .textFieldStyle(.plain)
                .padding()
                .background(Color.appSurface)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
            
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
}

struct GoalCard: View {
    let goal: Goal
    let isExpanded: Bool
    let onTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Button(action: onTap) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(goal.title)
                            .font(.appBody)
                            .fontWeight(.medium)
                            .foregroundColor(.appTextPrimary)
                            .multilineTextAlignment(.leading)
                        
                        Text(statusText)
                            .font(.appSmall)
                            .foregroundColor(statusColor)
                    }
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.appTextSecondary)
                }
            }
            
            if isExpanded {
                VStack(alignment: .leading, spacing: 8) {
                    Divider()
                    
                    HStack {
                        Text("Creada:")
                            .font(.appSmall)
                            .foregroundColor(.appTextSecondary)
                        Spacer()
                        Text(goal.createdAt)
                            .font(.appSmall)
                            .foregroundColor(.appTextSecondary)
                    }
                    
                    HStack {
                        Text("Estado:")
                            .font(.appSmall)
                            .foregroundColor(.appTextSecondary)
                        Spacer()
                        Text(goal.status.capitalized)
                            .font(.appSmall)
                            .fontWeight(.medium)
                            .foregroundColor(statusColor)
                    }
                }
            }
        }
        .padding()
        .background(Color.appSurface)
        .cornerRadius(16)
    }
    
    var statusText: String {
        switch goal.status {
        case "active": return "En progreso"
        case "completed": return "Completada"
        case "paused": return "Pausada"
        default: return goal.status
        }
    }
    
    var statusColor: Color {
        switch goal.status {
        case "active": return .appPrimary
        case "completed": return .appSuccess
        case "paused": return .appSecondary
        default: return .gray
        }
    }
}

struct EmptyGoalsView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "target")
                .font(.system(size: 48))
                .foregroundColor(.gray.opacity(0.5))
            
            Text("Aún no has creado metas")
                .font(.appBody)
                .foregroundColor(.appTextSecondary)
            
            Text("Agrega tu primera meta SMARTER")
                .font(.appCaption)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }
}

#Preview {
    NavigationStack {
        SmarterGoalView()
    }
}
