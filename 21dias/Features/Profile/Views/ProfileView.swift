import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var viewModel = ProfileViewModel()
    @State private var showLogoutAlert = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Profile Header
                    VStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(Color.appPrimary.opacity(0.1))
                                .frame(width: 100, height: 100)
                            
                            Text(String(viewModel.userName.prefix(1)).uppercased())
                                .font(.system(size: 40, weight: .bold))
                                .foregroundColor(.appPrimary)
                        }
                        
                        VStack(spacing: 4) {
                            Text(viewModel.userName)
                                .font(.appHeadline)
                                .foregroundColor(.appTextPrimary)
                            
                            Text(viewModel.userEmail)
                                .font(.appCaption)
                                .foregroundColor(.appTextSecondary)
                        }
                        
                        if authViewModel.isPremium {
                            HStack(spacing: 6) {
                                Image(systemName: "crown.fill")
                                    .foregroundColor(.appSecondary)
                                Text("Premium")
                                    .font(.appCaption)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.appSecondary)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.appSecondary.opacity(0.15))
                            .cornerRadius(20)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.appSurface)
                    .cornerRadius(16)
                    
                    // Stats
                    HStack(spacing: 16) {
                        StatCard(title: "Lecciones", value: "\(viewModel.completedLessons)", icon: "book.fill", color: .appPrimary)
                        StatCard(title: "Días", value: "21", icon: "calendar", color: .appAccent)
                    }
                    
                    // Settings
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Configuración")
                            .font(.appHeadline)
                            .foregroundColor(.appTextPrimary)
                        
                        SettingsRow(icon: "bell", title: "Notificaciones", hasChevron: true) {
                            // Navigate to notifications settings
                        }
                        
                        SettingsRow(icon: "lock", title: "Privacidad", hasChevron: true) {
                            // Navigate to privacy settings
                        }
                        
                        SettingsRow(icon: "questionmark.circle", title: "Ayuda", hasChevron: true) {
                            // Navigate to help
                        }
                        
                        SettingsRow(icon: "info.circle", title: "Acerca de", hasChevron: true) {
                            // Show about
                        }
                    }
                    .padding()
                    .background(Color.appSurface)
                    .cornerRadius(16)
                    
                    // Logout Button
                    Button {
                        showLogoutAlert = true
                    } label: {
                        HStack {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                            Text("Cerrar Sesión")
                        }
                        .font(.appBody)
                        .foregroundColor(.appError)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.appError.opacity(0.1))
                        .cornerRadius(12)
                    }
                    
                    Spacer(minLength: 40)
                }
                .padding()
            }
            .background(Color.appBackground)
            .navigationTitle("Perfil")
            .alert("Cerrar Sesión", isPresented: $showLogoutAlert) {
                Button("Cancelar", role: .cancel) { }
                Button("Cerrar Sesión", role: .destructive) {
                    viewModel.logout()
                    authViewModel.logout()
                }
            } message: {
                Text("¿Estás seguro de que quieres cerrar sesión?")
            }
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(color)
            
            Text(value)
                .font(.appTitleBold)
                .foregroundColor(.appTextPrimary)
            
            Text(title)
                .font(.appCaption)
                .foregroundColor(.appTextSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.appSurface)
        .cornerRadius(16)
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    var hasChevron: Bool = false
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.body)
                    .foregroundColor(.appPrimary)
                    .frame(width: 24)
                
                Text(title)
                    .font(.appBody)
                    .foregroundColor(.appTextPrimary)
                
                Spacer()
                
                if hasChevron {
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.appTextSecondary)
                }
            }
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthViewModel())
}
