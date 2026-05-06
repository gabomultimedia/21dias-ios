import SwiftUI

struct DiaryView: View {
    @StateObject private var viewModel = DiaryViewModel()
    @State private var showNewEntry = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if showNewEntry {
                    NewEntryView(viewModel: viewModel, showNewEntry: $showNewEntry)
                        .transition(.move(edge: .top))
                }
                
                ScrollView {
                    LazyVStack(spacing: 16) {
                        if viewModel.entries.isEmpty && !viewModel.isLoading {
                            EmptyDiaryView()
                        } else {
                            ForEach(viewModel.entries) { entry in
                                DiaryEntryCard(entry: entry, formattedDate: viewModel.formattedDate(entry.createdAt))
                            }
                        }
                    }
                    .padding()
                }
            }
            .background(Color.appBackground)
            .navigationTitle("Mi Diario")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        withAnimation {
                            showNewEntry.toggle()
                        }
                    } label: {
                        Image(systemName: showNewEntry ? "xmark" : "plus")
                            .foregroundColor(.appPrimary)
                    }
                }
            }
            .task {
                await viewModel.loadEntries()
            }
            .refreshable {
                await viewModel.loadEntries()
            }
        }
    }
}

struct NewEntryView: View {
    @ObservedObject var viewModel: DiaryViewModel
    @Binding var showNewEntry: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Nueva Entrada")
                .font(.appHeadline)
                .foregroundColor(.appTextPrimary)
            
            TextEditor(text: $viewModel.newEntryText)
                .font(.appBody)
                .frame(height: 150)
                .padding(8)
                .background(Color.appSurface)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
            
            TextField("Etiquetas (separadas por coma)", text: $viewModel.newEntryTags)
                .font(.appCaption)
                .padding()
                .background(Color.appSurface)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
            
            if let error = viewModel.errorMessage {
                Text(error)
                    .font(.appCaption)
                    .foregroundColor(.appError)
            }
            
            PrimaryButton(
                title: "Guardar Entrada",
                action: {
                    Task {
                        await viewModel.createEntry()
                        if viewModel.errorMessage == nil {
                            withAnimation {
                                showNewEntry = false
                            }
                        }
                    }
                },
                isLoading: viewModel.isSaving,
                isDisabled: viewModel.newEntryText.isEmpty
            )
        }
        .padding()
        .background(Color.appSurface)
    }
}

struct DiaryEntryCard: View {
    let entry: DiaryEntry
    let formattedDate: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(formattedDate)
                    .font(.appSmall)
                    .foregroundColor(.appTextSecondary)
                
                Spacer()
            }
            
            Text(entry.content)
                .font(.appBody)
                .foregroundColor(.appTextPrimary)
                .lineSpacing(4)
            
            if let tags = entry.tags, !tags.isEmpty {
                HStack(spacing: 8) {
                    ForEach(tags, id: \.self) { tag in
                        Text("#\(tag)")
                            .font(.appSmall)
                            .foregroundColor(.appPrimary)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.appPrimary.opacity(0.1))
                            .cornerRadius(8)
                    }
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.appSurface)
        .cornerRadius(16)
    }
}

struct EmptyDiaryView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "book.closed")
                .font(.system(size: 56))
                .foregroundColor(.gray.opacity(0.5))
            
            Text("Tu diario está vacío")
                .font(.appHeadline)
                .foregroundColor(.appTextSecondary)
            
            Text("Presiona + para escribir tu primera entrada")
                .font(.appBody)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
    }
}

#Preview {
    DiaryView()
}
