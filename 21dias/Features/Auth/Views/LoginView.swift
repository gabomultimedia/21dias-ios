import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var showRegister = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 32) {
                    // Logo & Title
                    VStack(spacing: 16) {
                        Image(systemName: "leaf.circle.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.appPrimary)
                        
                        Text("21 Días")
                            .font(.appTitleBold)
                            .foregroundColor(.appTextPrimary)
                        
                        Text("Impulso Sostenible")
                            .font(.appSubheadline)
                            .foregroundColor(.appTextSecondary)
                    }
                    .padding(.top, 60)
                    
                    // Form
                    VStack(spacing: 20) {
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
                                .textContentType(.password)
                                .padding()
                                .background(Color.appSurface)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
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
                    
                    // Login button
                    PrimaryButton(
                        title: "Iniciar Sesión",
                        action: {
                            Task {
                                await authViewModel.login(email: email, password: password)
                            }
                        },
                        isLoading: authViewModel.isLoading,
                        isDisabled: email.isEmpty || password.isEmpty
                    )
                    
                    // Register link
                    Button {
                        showRegister = true
                    } label: {
                        HStack(spacing: 4) {
                            Text("¿No tienes cuenta?")
                                .font(.appCaption)
                                .foregroundColor(.appTextSecondary)
                            Text("Regístrate")
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
            .navigationDestination(isPresented: $showRegister) {
                RegisterView()
            }
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
}
