//
//  GenericWellnessTipsView.swift
//  Hackathon
//
//  Created by Dev Jr. 13 on 19/04/26.
//


import SwiftUI

struct GenericWellnessTipsView: View {
    var onRetry: () -> Void

    let tips = [
        ("figure.walk",      "Move every hour",
         "Short walks improve focus and energy levels throughout the day."),
        ("moon.zzz",         "Sleep 7–9 hours",
         "Quality sleep is the single most impactful wellness habit."),
        ("iphone.slash",     "Limit screen time",
         "Try keeping phone use under 3 hours daily for better mental clarity."),
        ("location",         "Change your environment",
         "Visiting different places reduces feelings of isolation."),
        ("book",             "Learn something daily",
         "Even 20 minutes of reading improves mood and reduces stress.")
    ]

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 24) {

                    // Header
                    VStack(spacing: 12) {
                        Image(systemName: "exclamationmark.shield")
                            .font(.system(size: 48))
                            .foregroundColor(.yellow.opacity(0.8))
                            .padding(.top, 60)

                        Text("Limited access")
                            .font(.system(size: 28, weight: .semibold))
                            .foregroundColor(.white.opacity(0.95))

                        Text("Without permissions we can't personalize your experience. Here are some general wellness tips:")
                            .font(.system(size: 15))
                            .foregroundColor(.white.opacity(0.5))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                    }

                    // Tips
                    VStack(spacing: 12) {
                        ForEach(tips, id: \.0) { icon, title, description in
                            HStack(alignment: .top, spacing: 14) {
                                Image(systemName: icon)
                                    .font(.system(size: 22))
                                    .foregroundColor(.blue.opacity(0.8))
                                    .frame(width: 44, height: 44)
                                    .background(Color.blue.opacity(0.12))
                                    .cornerRadius(12)

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(title)
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.white.opacity(0.9))
                                    Text(description)
                                        .font(.system(size: 13))
                                        .foregroundColor(.white.opacity(0.5))
                                }
                                Spacer()
                            }
                            .padding(14)
                            .background(Color.white.opacity(0.05))
                            .cornerRadius(16)
                            .padding(.horizontal, 20)
                        }
                    }
                }
            }

            // Botón reintentar
            Button(action: onRetry) {
                Text("Grant permissions")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .font(.system(size: 18, weight: .semibold))
                    .background(Color(red: 17/255, green: 138/255, blue: 178/255))
                    .foregroundColor(.white)
                    .cornerRadius(24)
                    .shadow(color: Color.blue.opacity(0.4), radius: 15)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
            .padding(.top, 16)
        }
        .background(Color(red: 28/255, green: 28/255, blue: 30/255))
        .ignoresSafeArea()
    }
}

#Preview {
    GenericWellnessTipsView(onRetry: {})
}