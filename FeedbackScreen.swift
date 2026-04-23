//  FeedbackScreen.swift
//  Hackathon

import SwiftUI

struct FeedbackScreen: View {

    /// `true` = 👍 liked (complete), `false` = 👎 disliked (reject)
    var onFeedback: (Bool) -> Void

    @Environment(WellnessStore.self) private var store
    @Environment(\.dismiss) private var dismiss

    @State private var animateLike    = false
    @State private var animateDislike = false
    @State private var isProcessing   = false

    // ── Boost animation state ──────────────────────────────────────────────
    @State private var boostResult: WellnessStore.BoostResult? = nil
    @State private var showBoost = false

    // Backend para actualizar pesos y rechazar recomendación
    private let backend = WellnessBackend()

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                VStack(spacing: 64) {

                    Spacer()

                    Text(showBoost ? "Great job!" : "Feeling better?")
                        .font(.system(size: 34, weight: .semibold))
                        .foregroundColor(.white.opacity(0.95))
                        .multilineTextAlignment(.center)
                        .animation(.easeInOut(duration: 0.3), value: showBoost)

                    if showBoost, let boost = boostResult {
                        // ── Boost cards ────────────────────────────────────
                        VStack(spacing: 14) {
                            if boost.physicalDelta > 0 {
                                boostCard(
                                    icon: "figure.walk",
                                    label: "Physical",
                                    delta: boost.physicalDelta,
                                    color: Color(red: 17/255, green: 138/255, blue: 178/255)
                                )
                            }
                            if boost.mentalDelta > 0 {
                                boostCard(
                                    icon: "brain.head.profile",
                                    label: "Mental",
                                    delta: boost.mentalDelta,
                                    color: Color(red: 255/255, green: 209/255, blue: 102/255)
                                )
                            }
                            if boost.mindfulnessDelta > 0 {
                                boostCard(
                                    icon: "sparkles",
                                    label: "Spirit",
                                    delta: boost.mindfulnessDelta,
                                    color: Color(red: 187/255, green: 173/255, blue: 255/255)
                                )
                            }
                        }
                        .transition(.asymmetric(
                            insertion: .move(edge: .bottom).combined(with: .opacity),
                            removal: .opacity
                        ))
                        .padding(.horizontal, 2)

                    } else {
                        HStack(spacing: 32) {

                            // ── 👍 Like ────────────────────────────────────
                            Button(action: {
                                guard !isProcessing else { return }
                                isProcessing = true

                                if let rec = store.currentRecommendation {
                                    backend.handleRecommendationAction(.complete, for: rec)

                                    // Aplicar boost inmediato y guardar resultado
                                    let result = store.applyActivityBoost(from: rec)
                                    boostResult = result
                                }

                                backend.submitMoodFeedback(score: 80)

                                withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                                    showBoost = true
                                }

                                // Esperar un momento para que el usuario vea el boost
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
                                    onFeedback(true)
                                }
                            }) {
                                Image(systemName: "hand.thumbsup.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(Color(red: 17/255, green: 138/255, blue: 178/255))
                                    .frame(width: 120, height: 120)
                                    .background(Circle().fill(Color.blue.opacity(0.15)))
                                    .overlay(Circle().stroke(Color.blue.opacity(0.3), lineWidth: 2))
                                    .shadow(color: Color.blue.opacity(0.3), radius: 15)
                                    .scaleEffect(animateLike ? 0.9 : 1.0)
                            }
                            .disabled(isProcessing)
                            .simultaneousGesture(
                                TapGesture().onEnded {
                                    animatePress(setState: { animateLike = $0 })
                                }
                            )

                            // ── 👎 Dislike ─────────────────────────────────
                            Button(action: {
                                guard !isProcessing else { return }
                                isProcessing = true

                                if let current = store.currentRecommendation {
                                    backend.rejectAndFetchNext(current: current) { _ in
                                        DispatchQueue.main.async {
                                            dismiss()
                                            onFeedback(false)
                                        }
                                    }
                                } else {
                                    dismiss()
                                    onFeedback(false)
                                }
                            }) {
                                Image(systemName: "hand.thumbsdown.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(Color(red: 255/255, green: 209/255, blue: 102/255))
                                    .frame(width: 120, height: 120)
                                    .background(Circle().fill(Color.yellow.opacity(0.15)))
                                    .overlay(Circle().stroke(Color.yellow.opacity(0.3), lineWidth: 2))
                                    .shadow(color: Color.yellow.opacity(0.3), radius: 15)
                                    .scaleEffect(animateDislike ? 0.9 : 1.0)
                            }
                            .disabled(isProcessing)
                            .simultaneousGesture(
                                TapGesture().onEnded {
                                    animatePress(setState: { animateDislike = $0 })
                                }
                            )
                        }
                        .transition(.opacity)
                    }

                    if !showBoost {
                        Text("How did this exercise make you feel?")
                            .font(.system(size: 18))
                            .foregroundColor(.white.opacity(0.5))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                            .transition(.opacity)
                    }

                    Spacer()
                }
                .padding(.horizontal, 64)
                .padding(.bottom, 24)
                .background(Color.black.opacity(0.3))
            }
            .background(Color(red: 28/255, green: 28/255, blue: 30/255))
            .ignoresSafeArea()
        }
    }

    // ── Boost card ─────────────────────────────────────────────────────────
    func boostCard(icon: String, label: String, delta: Double, color: Color) -> some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(color)
                .frame(width: 36, height: 36)
                .background(color.opacity(0.2))
                .cornerRadius(10)

            Text(label)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white.opacity(0.85))

            Spacer()

            Text("+\(Int(delta.rounded())) pts")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(color)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(color.opacity(0.15))
                .cornerRadius(12)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(color.opacity(0.4), lineWidth: 1.5)
                )
        )
    }

    func animatePress(setState: @escaping (Bool) -> Void) {
        withAnimation(.easeInOut(duration: 0.1)) { setState(true) }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.easeInOut(duration: 0.1)) { setState(false) }
        }
    }
}

#Preview {
    FeedbackScreen { liked in
        print(liked ? "👍" : "👎")
    }
    .environment(WellnessStore.shared)
}

#Preview {
    FeedbackScreen { liked in
        print(liked ? "👍" : "👎")
    }
    .environment(WellnessStore.shared)
}
