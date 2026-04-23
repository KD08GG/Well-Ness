// InsightScreen.swift

import SwiftUI

// MARK: - Model

struct Insight: Identifiable {
    let id = UUID()
    let icon: String
    let color: Color
    let title: String
    let progress: Double
}

// MARK: - Navigation destination enum

enum InsightRoute: Hashable {
    case action
    case feedback
}

// MARK: - Screen

struct InsightScreen: View {
    var onAction: (() -> Void)?

    @Environment(WellnessStore.self) private var store

    @State private var animateBars = false
    @State private var appear = [false, false, false]
    @State private var backend = WellnessBackend()
    @State private var path: [InsightRoute] = []

    init(onAction: (() -> Void)? = nil) {
        self.onAction = onAction
    }

    var insights: [Insight] {
        [
            Insight(icon: "figure.walk",
                    color: Color(red: 17/255, green: 138/255, blue: 178/255),
                    title: store.physical < 50 ? "Low physical activity" : "Good physical activity",
                    progress: store.physical / 100),

            Insight(icon: "iphone",
                    color: Color(red: 255/255, green: 209/255, blue: 102/255),
                    title: store.mental < 50 ? "Too much screen time" : "Healthy screen time",
                    progress: store.mental / 100),

            Insight(icon: "brain.head.profile",
                    color: Color(red: 187/255, green: 173/255, blue: 255/255),
                    title: store.mindfulness < 50 ? "Limited mental breaks" : "Good mindfulness",
                    progress: store.mindfulness / 100)
        ]
    }

    var body: some View {
        NavigationStack(path: $path) {
            VStack(spacing: 0) {

                VStack(spacing: 24) {

                    LiquidEnergyCircle(
                        mental: store.mental / 100,
                        physical: store.physical / 100,
                        emotional: store.mindfulness / 100
                    )
                    .padding(.top, 75)

                    VStack(spacing: 20) {
                        ForEach(Array(insights.enumerated()), id: \.element.id) { index, item in
                            insightCard(item: item)
                                .opacity(appear[index] ? 1 : 0)
                                .offset(y: appear[index] ? 0 : 20)
                                .animation(.easeOut.delay(Double(index) * 0.15), value: appear[index])
                        }
                    }
                    .padding(.horizontal, 20)
                }

                Spacer()



                Button(action: {
                    path.append(.action)
                }) {
                    Text("I need a break")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .font(.system(size: 20, weight: .semibold))
                        .background(Color(red: 255/255, green: 209/255, blue: 102/255))
                        .foregroundColor(Color(red: 28/255, green: 28/255, blue: 30/255))
                        .cornerRadius(24)
                        .shadow(color: Color.yellow.opacity(0.4), radius: 15)
                }
                .padding(.horizontal, 24)
                .padding(.top, 12)
                .padding(.bottom, 100)
            }
            .background(Color.black.opacity(0.3))
            .background(Color(red: 28/255, green: 28/255, blue: 30/255))
            .ignoresSafeArea()
            .onAppear {
                startAnimations()
            }
            // ── Rutas de navegación ────────────────────────────────────────
            .navigationDestination(for: InsightRoute.self) { route in
                switch route {
                case .action:
                    ActionScreen(
                        onDone: {
                            // 👍 flujo: volver a InsightScreen
                            path.removeAll()
                        },
                        onOtherOption: {
                            // "Other option" desde ActionScreen: rechazar y traer nueva
                            if let current = store.currentRecommendation {
                                backend.rejectAndFetchNext(current: current) { _ in
                                    // store ya fue actualizado; ActionScreen se redibuja
                                }
                            }
                        }
                    )
                    .navigationBarBackButtonHidden(true)

                case .feedback:
                    // FeedbackScreen se pushea desde ActionScreen vía su propio navigationDestination
                    EmptyView()
                }
            }
        }
    }

    // MARK: - Card

    func insightCard(item: Insight) -> some View {
        VStack(alignment: .leading, spacing: 16) {

            HStack(alignment: .top, spacing: 12) {

                Image(systemName: item.icon)
                    .font(.system(size: 26))
                    .foregroundColor(item.color)
                    .padding(10)
                    .background(item.color.opacity(0.2))
                    .cornerRadius(14)

                Text(item.title)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white.opacity(0.95))
                    .padding(.top, 4)

                Spacer()
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {

                    Capsule()
                        .fill(Color.white.opacity(0.1))
                        .frame(height: 8)

                    Capsule()
                        .fill(item.color)
                        .frame(
                            width: animateBars ? geo.size.width * item.progress : 0,
                            height: 8
                        )
                        .shadow(color: item.color.opacity(0.6), radius: 6)
                        .animation(
                            .easeOut(duration: 0.8)
                            .delay(0.3),
                            value: animateBars
                        )
                }
            }
            .frame(height: 8)
        }
        .padding(18)
        .background(Color.white.opacity(0.05))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(item.color, lineWidth: 2)
        )
        .shadow(color: item.color.opacity(0.3), radius: 10)
        .cornerRadius(20)
    }

    // MARK: - Animaciones

    func startAnimations() {
        for i in 0..<appear.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.15) {
                appear[i] = true
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            animateBars = true
        }
    }
}

// MARK: - Círculo dinámico inteligente
struct LiquidEnergyCircle: View {

    let mental: Double
    let physical: Double
    let emotional: Double

    @State private var move1 = false
    @State private var move2 = false
    @State private var move3 = false

    var body: some View {
        ZStack {

            Circle()
                .fill(Color.black.opacity(0.3))

            ZStack {

                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [
                                Color.yellow.opacity(0.9 * mental),
                                Color.yellow.opacity(0.4 * mental),
                                Color.clear
                            ]),
                            center: .center,
                            startRadius: 0,
                            endRadius: 120
                        )
                    )
                    .blur(radius: 25)
                    .offset(
                        x: move1 ? -40 : -10,
                        y: move1 ? -30 : -60
                    )

                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [
                                Color.blue.opacity(0.9 * physical),
                                Color.blue.opacity(0.4 * physical),
                                Color.clear
                            ]),
                            center: .center,
                            startRadius: 0,
                            endRadius: 120
                        )
                    )
                    .blur(radius: 25)
                    .offset(
                        x: move2 ? 30 : -20,
                        y: move2 ? 50 : 10
                    )

                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [
                                Color.purple.opacity(0.9 * emotional),
                                Color.purple.opacity(0.4 * emotional),
                                Color.clear
                            ]),
                            center: .center,
                            startRadius: 0,
                            endRadius: 120
                        )
                    )
                    .blur(radius: 25)
                    .offset(
                        x: move3 ? 40 : 10,
                        y: move3 ? -20 : 40
                    )
            }
            .blendMode(.plusLighter)
            .clipShape(Circle())

            Circle()
                .stroke(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.4),
                            Color.white.opacity(0.1)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 2
                )
        }
        .frame(width: 220, height: 220)
        .shadow(color: Color.black.opacity(0.5), radius: 20)
        .onAppear {
            withAnimation(.easeInOut(duration: 4).repeatForever(autoreverses: true)) {
                move1.toggle()
            }
            withAnimation(.easeInOut(duration: 5).repeatForever(autoreverses: true)) {
                move2.toggle()
            }
            withAnimation(.easeInOut(duration: 6).repeatForever(autoreverses: true)) {
                move3.toggle()
            }
        }
    }
}

#Preview("iPhone 15 - Dark") {
    InsightScreen()
        .environment(WellnessStore.shared)
        .preferredColorScheme(.dark)
}
