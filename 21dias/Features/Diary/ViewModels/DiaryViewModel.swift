import SwiftUI

@MainActor
class DiaryViewModel: ObservableObject {
    @Published var entries: [DiaryEntry] = []
    @Published var newEntryText = ""
    @Published var newEntryTags = ""
    @Published var isLoading = false
    @Published var isSaving = false
    @Published var errorMessage: String?
    
    func loadEntries() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let response: DiaryResponse = try await APIClient.shared.request(.diary)
            entries = response.entries
        } catch {
            errorMessage = "Error al cargar entradas"
        }
        
        isLoading = false
    }
    
    func createEntry() async {
        guard !newEntryText.isEmpty else { return }
        
        isSaving = true
        errorMessage = nil
        
        let tags = newEntryTags.split(separator: ",").map { String($0.trimmingCharacters(in: .whitespaces)) }
        
        do {
            try await APIClient.shared.requestVoid(.createDiaryEntry(content: newEntryText, lessonId: nil))
            newEntryText = ""
            newEntryTags = ""
            await loadEntries()
        } catch {
            errorMessage = "Error al guardar la entrada"
        }
        
        isSaving = false
    }
    
    func formattedDate(_ dateString: String) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        guard let date = formatter.date(from: dateString) else {
            return dateString
        }
        
        let displayFormatter = DateFormatter()
        displayFormatter.dateStyle = .medium
        displayFormatter.timeStyle = .short
        displayFormatter.locale = Locale(identifier: "es_MX")
        
        return displayFormatter.string(from: date)
    }
}
