import SwiftUI

struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    var isLoading: Bool = false
    var isDisabled: Bool = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(0.8)
                }
                Text(title)
                    .font(.appSubheadline)
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(isDisabled ? Color.gray : Color.appPrimary)
            .foregroundColor(.white)
            .cornerRadius(12)
        }
        .disabled(isDisabled || isLoading)
    }
}

struct SecondaryButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.appSubheadline)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(Color.appSurface)
                .foregroundColor(.appPrimary)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.appPrimary, lineWidth: 2)
                )
                .cornerRadius(12)
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        PrimaryButton(title: "Continuar", action: {})
        PrimaryButton(title: "Cargando...", action: {}, isLoading: true)
        SecondaryButton(title: "Cancelar", action: {})
    }
    .padding()
}
