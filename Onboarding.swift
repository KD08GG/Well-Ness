//
//  Onboarding.swift
//  Hackathon
//
//  Created by Uni on 18/04/26.
//


import SwiftUI

struct Onboarding: View {
    var onStart: (Bool) -> Void  // Bool = permisosOk
    
    @State private var animate = false
    @State private var isRequestingPermissions = false
    @State private var permissionsGranted = false
    
    var body: some View {
        VStack {
            
            Spacer()
            
            // Círculo animado
            ZStack {
                
                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [
                                Color.yellow.opacity(0.4),
                                Color.blue.opacity(0.3),
                                Color.purple.opacity(0.3)
                            ]),
                            center: .center,
                            startRadius: 0,
                            endRadius: 120
                        )
                    )
                    .blur(radius: 20)
                
                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [
                                Color.yellow.opacity(0.6),
                                Color.blue.opacity(0.5),
                                Color.purple.opacity(0.5)
                            ]),
                            center: .center,
                            startRadius: 0,
                            endRadius: 100
                        )
                    )
                    .blur(radius: 30)
                    .padding(32)
                
                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [
                                Color.yellow,
                                Color.blue,
                                Color.purple
                            ]),
                            center: .center,
                            startRadius: 0,
                            endRadius: 80
                        )
                    )
                    .blur(radius: 15)
                    .padding(64)
            }
            .frame(width: 260, height: 260)
            .scaleEffect(animate ? 1.05 : 1.0)
            .animation(
                .easeInOut(duration: 3)
                .repeatForever(autoreverses: true),
                value: animate
            )
            
            Spacer()
            
            VStack(spacing: 40) {
                
                // Texto
                Text("Your energy needs a break...\nand so do you")
                    .font(.system(size: 22))
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                
                // Botón
                Button(action: {
                    isRequestingPermissions = true
                    PermissionsManager.shared.requestHealthKitPermissions { healthGranted in
                        PermissionsManager.shared.requestLocationPermissions()
                        PermissionsManager.shared.requestNotificationPermissions { notifGranted in
                            DispatchQueue.main.async {
                                isRequestingPermissions = false
                                onStart(healthGranted || notifGranted)
                            }
                        }
                    }
                    
                }) {
                    Group {
                        if isRequestingPermissions {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Text("Start")
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .font(.system(size: 20, weight: .semibold))
                    .background(Color(red: 17/255, green: 138/255, blue: 178/255))
                    .foregroundColor(.white)
                    .cornerRadius(24)
                    .shadow(color: Color.blue.opacity(0.4), radius: 15)
                }
                .disabled(isRequestingPermissions)
                .padding(.horizontal, 24)
                
            }
            .padding(.bottom, 40)
        }
        .background(Color(red: 28/255, green: 28/255, blue: 30/255))
        .ignoresSafeArea()
        .onAppear {
            animate = true
        }
    }
}
#Preview {
    Onboarding { _ in }
}
