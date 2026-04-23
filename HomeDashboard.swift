//  HomeDashboard.swift
//  Hackathon

import SwiftUI
import Charts

struct HomeDashboard: View {
    var onContinue: () -> Void

    @Environment(WellnessStore.self) private var store

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {

                // Encabezado
                Text(store.finalScore > 60
                     ? "Your energy is\nwell balanced"
                     : "Your energy today was\nnot balanced")
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundColor(.white.opacity(0.95))
                    .multilineTextAlignment(.center)
                    .padding(.top, 60)
                    .padding(.bottom, 8)

                if store.isLoading {
                    ProgressView()
                        .tint(.white)
                        .padding(.top, 40)
                } else {

                    // ── Datos crudos ───────────────────────────────────────
                    VStack(spacing: 0) {
                        Text("Today's data")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.white.opacity(0.4))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.bottom, 12)

                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {

                            rawMetricCard(
                                icon: "figure.walk",
                                value: "\(Int(store.steps))",
                                unit: "steps",
                                color: Color(red: 17/255, green: 138/255, blue: 178/255)
                            )

                            rawMetricCard(
                                icon: "bed.double.fill",
                                value: String(format: "%.1f", store.sleepHours),
                                unit: "hrs sleep",
                                color: Color(red: 187/255, green: 173/255, blue: 255/255)
                            )

                            rawMetricCard(
                                icon: "iphone",
                                value: String(format: "%.1f", store.screenTimeHours),
                                unit: "hrs screen",
                                color: Color(red: 255/255, green: 209/255, blue: 102/255)
                            )

                            rawMetricCard(
                                icon: "mappin.and.ellipse",
                                value: "\(Int(store.locationsVisited))",
                                unit: "locations",
                                color: Color(red: 100/255, green: 220/255, blue: 160/255)
                            )
                        }
                    }
                    .padding(.horizontal, 24)

                    // ── Scores de categoría ────────────────────────────────
                    VStack(spacing: 0) {
                        Text("Wellness scores")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.white.opacity(0.4))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.bottom, 12)

                        VStack(spacing: 12) {
                            scoreCard(
                                icon: "figure.walk",
                                label: "Physical",
                                score: store.physical,
                                color: Color(red: 17/255, green: 138/255, blue: 178/255)
                            )
                            scoreCard(
                                icon: "brain.head.profile",
                                label: "Mental",
                                score: store.mental,
                                color: Color(red: 255/255, green: 209/255, blue: 102/255)
                            )
                            scoreCard(
                                icon: "sparkles",
                                label: "Mindfulness",
                                score: store.mindfulness,
                                color: Color(red: 187/255, green: 173/255, blue: 255/255)
                            )
                        }
                    }
                    .padding(.horizontal, 24)
                }

                Spacer(minLength: 100)
            }
        }
        .background(Color(red: 28/255, green: 28/255, blue: 30/255))
        .ignoresSafeArea()
    }

    // ── Raw metric card (2 columnas) ───────────────────────────────────────
    func rawMetricCard(icon: String, value: String, unit: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 22))
                .foregroundColor(color)
                .padding(8)
                .background(color.opacity(0.15))
                .cornerRadius(10)

            Text(value)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)

            Text(unit)
                .font(.system(size: 13))
                .foregroundColor(.white.opacity(0.5))
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(color.opacity(0.3), lineWidth: 1)
                )
        )
    }

    // ── Score card con barra de progreso ───────────────────────────────────
    func scoreCard(icon: String, label: String, score: Double, color: Color) -> some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(color)
                .frame(width: 36, height: 36)
                .background(color.opacity(0.15))
                .cornerRadius(10)

            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(label)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.white.opacity(0.9))
                    Spacer()
                    Text("\(Int(score))%")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(color)
                }

                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color.white.opacity(0.1))
                            .frame(height: 6)
                        Capsule()
                            .fill(color)
                            .frame(width: geo.size.width * (score / 100), height: 6)
                    }
                }
                .frame(height: 6)
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.05))
        )
    }
}

#Preview {
    HomeDashboard {
        print("Continuar")
    }
    .environment(WellnessStore.shared)
    .preferredColorScheme(.dark)
}
