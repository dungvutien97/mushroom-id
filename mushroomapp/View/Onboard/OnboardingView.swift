//
//  OnboardingView.swift
//  mushroomapp
//
//  Created by Tien Dung Vu on 17/9/25.
//

import SwiftUI

struct OnboardingPage {
    let title: String
    let description: String
    let imageName: String
}

struct OnboardingView: View {
    @State private var currentPage = 0
    
    private let pages: [OnboardingPage] = [
        OnboardingPage(title: "Discover Mushrooms",
                       description: "Identify mushrooms instantly with AI-powered recognition.",
                       imageName: "example"),
        OnboardingPage(title: "Stay Safe",
                       description: "Learn if a mushroom is edible or poisonous before picking.",
                       imageName: "example"),
        OnboardingPage(title: "Track Your Finds",
                       description: "Save locations of discoveries and build your mushroom journal.",
                       imageName: "example")
    ]
    
    var body: some View {
        VStack {
            TabView(selection: $currentPage) {
                ForEach(0..<pages.count, id: \.self) { index in
                    VStack(spacing: 20) {
                        Spacer()
                        Image(pages[index].imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 250)
                        
                        Text(pages[index].title)
                            .font(.title)
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        Text(pages[index].description)
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        Spacer()
                    }
                    .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            
            Button(action: {
                if currentPage < pages.count - 1 {
                    withAnimation {
                        currentPage += 1
                    }
                } else {
                    // Done → chuyển sang HomeView
                    print("Onboarding completed")
                }
            }) {
                Text(currentPage == pages.count - 1 ? "Get Started" : "Continue")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .padding(.horizontal)
                    .padding(.bottom, 20)
            }
        }
    }
}
