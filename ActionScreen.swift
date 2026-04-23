//  ActionScreen.swift
//  Hackathon

import SwiftUI

struct ActionScreen: View {
    var onDone: () -> Void        // 👍 → InsightScreen
    var onOtherOption: () -> Void // "Other option" → rechaza y queda en ActionScreen

    @State private var isBreathing  = false
    @State private var animate      = false
    @State private var showFeedback = false
    @Environment(WellnessStore.self) private var store

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            // ── Círculo de respiración ─────────────────────────────────────
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [
                                Color.white.opacity(0.8),
                                Color.blue.opacity(0.6),
                                Color.blue.opacity(0.2)
                            ]),
                            center: .center,
                            startRadius: 0,
                            endRadius: 160
                        )
                    )
                    .blur(radius: 30)
                    .shadow(color: Color.blue.opacity(0.6), radius: 40)
                    .scaleEffect(isBreathing ? (animate ? 1.3 : 1.0) : 1.0)

                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [
                                Color.white.opacity(0.9),
                                Color.blue.opacity(0.7)
                            ]),
                            center: .center,
                            startRadius: 0,
                            endRadius: 100
                        )
                    )
                    .blur(radius: 20)
                    .padding(48)
                    .opacity(isBreathing ? (animate ? 1.0 : 0.6) : 0.8)
            }
            .frame(width: 300, height: 300)
            .onTapGesture {
                isBreathing.toggle()
                startAnimation()
            }

            Text(isBreathing ? (animate ? "Enjoy your activity" : "Reset your mind") : "Tap to start")
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.top, 16)
                .animation(.easeInOut(duration: 0.3), value: animate)

            // ── Recomendación DEBAJO del círculo ──────────────────────────
            if let rec = store.currentRecommendation {
                VStack(spacing: 10) {
                    Text("Your activity")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white.opacity(0.4))

                    Text(rec.title)
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(.white.opacity(0.95))
                        .multilineTextAlignment(.center)

                    Text(rec.description)
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.55))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)

                    HStack(spacing: 6) {
                        Image(systemName: "clock")
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.4))
                        Text("\(Int(rec.taskTime)) min")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.white.opacity(0.4))
                    }
                }
                .padding(20)
                .background(Color.white.opacity(0.05))
                .cornerRadius(20)
                .padding(.horizontal, 28)
                .padding(.top, 28)
            }

            Spacer()

            // ── Botones ────────────────────────────────────────────────────
            VStack(spacing: 14) {
                Button(action: {
                    showFeedback = true
                }) {
                    Text("Done")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .font(.system(size: 20, weight: .semibold))
                        .background(Color.green.opacity(0.9))
                        .foregroundColor(.white)
                        .cornerRadius(24)
                        .shadow(color: Color.green.opacity(0.3), radius: 10)
                }

                Button(action: {
                    onOtherOption()
                }) {
                    Text("Other option")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))
                        .overlay(
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        )
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 130)
        }
        // FeedbackScreen como sheet: el 👎 solo hace dismiss del sheet
        // y ActionScreen permanece visible con la nueva recomendación.
        .sheet(isPresented: $showFeedback) {
            FeedbackScreen { liked in
                showFeedback = false
                if liked {
                    // 👍 → salir de ActionScreen también
                    onDone()
                }
                // 👎 → sheet se cierra, ActionScreen se ve con nueva rec
            }
            .environment(store)
        }
        .background(Color(red: 28/255, green: 28/255, blue: 30/255))
        .ignoresSafeArea()
    }

    func startAnimation() {
        guard isBreathing else { return }
        withAnimation(
            .easeInOut(duration: 3)
            .repeatForever(autoreverses: true)
        ) {
            animate.toggle()
        }
    }
}

#Preview("ActionScreen") {
    ActionScreen(
        onDone: { print("Done pressed") },
        onOtherOption: { print("Other option pressed") }
    )
    .environment(WellnessStore.shared)
}
