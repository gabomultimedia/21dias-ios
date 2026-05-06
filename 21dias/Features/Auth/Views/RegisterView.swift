import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    
    var passwordsMatch: Bool {
        password == confirmPassword && !password.isEmpty
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                // Header
                VStack(spacing: 16) {
                    Image(systemName: "person.badge.plus")
                        .font(.system(size: 60))
                        .foregroundColor(.appPrimary)
                    
                    Text("Crear Cuenta")
                        .font(.appTitleBold)
                        .foregroundColor(.appTextPrimary)
                    
                    Text("Únete al programa de 21 días")
                        .font(.appBody)
                        .foregroundColor(.appTextSecondary)
                }
                .padding(.top, 40)
                
                // Form
                VStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Nombre completo")
                            .font(.appCaption)
                            .foregroundColor(.appTextSecondary)
                        
                        TextField("", text: $name)
                            .textFieldStyle(.plain)
                            .textContentType(.name)
                            .padding()
                            .background(Color.appSurface)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Correo electrónico")
                            .font(.appCaption)
                            .foregroundColor(.appTextSecondary)
                        
                        TextField("", text: $email)
                            .textFieldStyle(.plain)
                            .keyboardType(.emailAddress)
                            .textContentType(.emailAddress)
                            .autocapitalization(.none)
                            .padding()
                            .background(Color.appSurface)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Contraseña")
                            .font(.appCaption)
                            .foregroundColor(.appTextSecondary)
                        
                        SecureField("", text: $password)
                            .textFieldStyle(.plain)
                            .textContentType(.newPassword)
                            .padding()
                            .background(Color.appSurface)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                        
                        Text("Mínimo 6 caracteres")
                            .font(.appSmall)
                            .foregroundColor(.appTextSecondary)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Confirmar contraseña")
                            .font(.appCaption)
                            .foregroundColor(.appTextSecondary)
                        
                        SecureField("", text: $confirmPassword)
                            .textFieldStyle(.plain)
                            .textContentType(.newPassword)
                            .padding()
                            .background(Color.appSurface)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(
                                        confirmPassword.isEmpty ? Color.gray.opacity(0.3) : (passwordsMatch ? Color.appSuccess : Color.appError),
                                        lineWidth: 1
                                    )
                            )
                    }
                }
                
                // Error message
                if let error = authViewModel.errorMessage {
                    Text(error)
                        .font(.appCaption)
                        .foregroundColor(.appError)
                        .multilineTextAlignment(.center)
                }
                
                // Register button
                PrimaryButton(
                    title: "Crear Cuenta",
                    action: {
                        Task {
                            await authViewModel.register(name: name, email: email, password: password)
                        }
                    },
                    isLoading: authViewModel.isLoading,
                    isDisabled: name.isEmpty || email.isEmpty || !passwordsMatch
                )
                
                // Back to login
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 4) {
                        Text("¿Ya tienes cuenta?")
                            .font(.appCaption)
                            .foregroundColor(.appTextSecondary)
                        Text("Inicia Sesión")
                            .font(.appCaption)
                            .foregroundColor(.appPrimary)
                            .fontWeight(.semibold)
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal, 24)
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
    }
}

#Preview {
    NavigationStack {
        RegisterView()
            .environmentObject(AuthViewModel())
    }
}
