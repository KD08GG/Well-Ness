//  ContentView.swift
//  Hackathon

import SwiftUI
import CoreLocation


struct ContentView: View {

    @State private var showApp = false
    @State private var permissionsDenied = false
    @State private var currentTab = 2  // Arranca en Home

    // Backend guardado en @State para que no se destruya antes de terminar el fetch
    @State private var backend = WellnessBackend()

    // ¿Ya completó el onboarding alguna vez?
    private var hasSeenOnboarding: Bool {
        UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
    }

    var body: some View {
        Group {
            if permissionsDenied {
                GenericWellnessTipsView {
                    permissionsDenied = false
                }
            } else if showApp || hasSeenOnboarding {
                MainTabView(currentTab: $currentTab)
                    .onAppear {
                        // Correr análisis usando la instancia guardada en @State
                        backend.runDailyAnalysis()
                    }
            } else {
                Onboarding { permissionsOk in
                    if permissionsOk {
                        // Marcar que ya vio el onboarding
                        UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
                        showApp = true
                        backend.runDailyAnalysis()
                    } else {
                        permissionsDenied = true
                    }
                }
            }
        }
    }
}
