import SwiftUI
import UserNotifications

// MARK: - Model

struct ProfileStat: Identifiable {
    let id = UUID()
    let value: String
    let label: String
    let color: Color
    let icon: String
}

struct ProfileOption: Identifiable {
    let id = UUID()
    let icon: String
    let label: String
    let sublabel: String
    let color: Color
}

// MARK: - Screen

struct ProfileScreen: View {
    
    var onBack: (() -> Void)?
        
        // Añade este inicializador explícito
        init(onBack: (() -> Void)? = nil) {
            self.onBack = onBack
        }
    
    @State private var animateAvatar = false
    @State private var showingPrivacyAlert = false
    
    @State private var userName: String = UserDefaults.standard.string(forKey: "userName") ?? "Your Name"
    @State private var isEditingName = false
    
    @Environment(WellnessStore.self) private var store
    
    var stats: [ProfileStat] {
        [
            ProfileStat(
                value: "\(Int(store.physical))%",
                label: "Physical",
                color: .blue,
                icon: "figure.walk"
            ),
            ProfileStat(
                value: "\(Int(store.mental))%",
                label: "Mental",
                color: .yellow,
                icon: "brain.head.profile"
            ),
            ProfileStat(
                value: "\(Int(store.mindfulness))%",
                label: "Spirit",
                color: .purple,
                icon: "sparkles"
            )
        ]
    }
    
    let options: [ProfileOption] = [
        ProfileOption(icon: "bell", label: "Notifications", sublabel: "Manage your alerts", color: .blue),
        ProfileOption(icon: "lock.shield", label: "Privacy", sublabel: "Control your data", color: .purple),
        ProfileOption(icon: "person", label: "Share", sublabel: "Share with your close ones", color: .yellow)
    ]
    
    var body: some View {
        ScrollView {
            
            VStack(spacing: 24) {
                
                // MARK: Avatar
                
                VStack(spacing: 14) {
                    
                    ZStack {
                        
                        Circle()
                            .fill(
                                AngularGradient(
                                    colors: [
                                        Color.yellow.opacity(0.6),
                                        Color.blue.opacity(0.6),
                                        Color.purple.opacity(0.6),
                                        Color.yellow.opacity(0.6)
                                    ],
                                    center: .center
                                )
                            )
                            .blur(radius: 12)
                            .frame(width: 130, height: 130)
                            .rotationEffect(.degrees(animateAvatar ? 360 : 0))
                            .animation(.linear(duration: 10).repeatForever(autoreverses: false), value: animateAvatar)
                        
                        Circle()
                            .fill(Color(red: 28/255, green: 28/255, blue: 30/255))
                            .frame(width: 120, height: 120)
                        
                        Image(systemName: "person.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .onAppear {
                        animateAvatar = true
                    }
                    
                    VStack(spacing: 6) {
                        HStack(spacing: 8) {
                            if isEditingName {
                                TextField("Your name", text: $userName)
                                    .font(.system(size: 28, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.95))
                                    .multilineTextAlignment(.center)
                                    .onSubmit {
                                        UserDefaults.standard.set(userName, forKey: "userName")
                                        isEditingName = false
                                    }
                            } else {
                                Text(userName)
                                    .font(.system(size: 28, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.95))
                            }
                            
                            // Ícono siempre visible y fijo
                            Image(systemName: "pencil.circle.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.gray.opacity(0.8))
                                .onTapGesture {
                                    isEditingName = true
                                }
                        }

                        Text("Mindful since April 2026")
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.5))
                    }
                }
                .padding(.top, 65)
                
                // MARK: Stats
                
                HStack(spacing: 12) {
                    ForEach(stats) { stat in
                        VStack(spacing: 8) {
                            
                            Image(systemName: stat.icon)
                                .foregroundColor(stat.color)
                            
                            Text(stat.value)
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(stat.color)
                            
                            Text(stat.label)
                                .font(.system(size: 12))
                                .foregroundColor(.white.opacity(0.6))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(14)
                        .background(Color.white.opacity(0.05))
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.white.opacity(0.08))
                        )
                    }
                }
                .padding(.horizontal, 20)
                
                // MARK: Settings
                
                VStack(alignment: .leading, spacing: 12) {
                    
                    Text("Configuración")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white.opacity(0.7))
                        .padding(.horizontal, 20)
                    
                    ForEach(options) { option in
                        
                        Button(action: {
                            handleOptionTap(option: option)
                        }) {
                            HStack(spacing: 14) {
                                
                                Image(systemName: option.icon)
                                    .foregroundColor(option.color)
                                    .frame(width: 44, height: 44)
                                    .background(option.color.opacity(0.15))
                                    .cornerRadius(14)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(option.label)
                                        .foregroundColor(.white.opacity(0.95))
                                        .font(.system(size: 16, weight: .medium))
                                    
                                    Text(option.sublabel)
                                        .foregroundColor(.white.opacity(0.5))
                                        .font(.system(size: 13))
                                }
                                
                                Spacer()
                                
                                Text("›")
                                    .foregroundColor(.white.opacity(0.3))
                                    .font(.system(size: 24))
                            }
                            .padding()
                            .background(Color.white.opacity(0.05))
                            .cornerRadius(22)
                            .overlay(
                                RoundedRectangle(cornerRadius: 22)
                                    .stroke(Color.white.opacity(0.08))
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                        .padding(.horizontal, 20)
                    }
                }
                
                // MARK: Back button
                
                if let onBack = onBack {
                    Button(action: onBack) {
                        Text("Volver")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .foregroundColor(.white.opacity(0.6))
                            .overlay(
                                RoundedRectangle(cornerRadius: 24)
                                    .stroke(Color.white.opacity(0.15))
                            )
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                }
                
                Spacer(minLength: 40)
            }
        }
        .background(Color.black.opacity(0.3))
        .background(Color(red: 28/255, green: 28/255, blue: 30/255))
        .ignoresSafeArea()
        .alert("Privacy", isPresented: $showingPrivacyAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Your data is securely stored and never shared with third parties. We only use your information to personalize your wellness journey.")
        }
    }
    
    // MARK: - Handlers
    
    func handleOptionTap(option: ProfileOption) {
        switch option.label {
        case "Notifications":
            requestNotificationPermission()
        case "Privacy":
            showingPrivacyAlert = true
        default:
            break
        }
    }
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Notifications authorized")
                DispatchQueue.main.async {
                    // Opcional: mostrar un mensaje de éxito
                    print("Notifications enabled")
                }
            } else {
                print("Notifications denied")
                DispatchQueue.main.async {
                    // Opcional: mostrar un mensaje de que las notificaciones están deshabilitadas
                    print("Please enable notifications in Settings")
                }
            }
        }
    }
}

#Preview {
    ProfileScreen()
        .environment(WellnessStore.shared)
}
