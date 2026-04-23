//  MainTabView.swift
//  Hackathon

import SwiftUI

struct MainTabView: View {

    @Binding var currentTab: Int

    var body: some View {
        TabView(selection: $currentTab) {

            HomeDashboard(onContinue: {
                currentTab = 2
            })
            .tabItem {
                Label("Stats", systemImage: "chart.pie")
            }
            .tag(1)

            InsightScreen(onAction: {
                currentTab = 2
            })
            .tabItem {
                Label("Home", systemImage: "house")
            }
            .tag(2)

            ProfileScreen()  // Sin argumentos, solo llamada al inicializador
                .tabItem {
                    Label("Perfil", systemImage: "person")
                }
                .tag(3)
        }
    }
}
