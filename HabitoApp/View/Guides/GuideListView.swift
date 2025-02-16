//
//  GuideListView.swift
//  HabitoApp
//
//  Created by Areeb Durrani on 2/16/25.
//

import SwiftUI

struct GuideListView: View {
    var guide: Guide

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    guideImage
                    guideTitleAndSummary
                    Divider().padding(.horizontal)
                    guideContentSection
                }
                .padding(.vertical)
            }
            .navigationTitle("Guide Details")
        }
    }
    
    // MARK: - Subviews
    
    private var guideImage: some View {
        Image(guide.imageName)
            .resizable()
            .scaledToFit()
            .frame(height: 250)
            .clipped()
            .cornerRadius(15)
            .padding(.horizontal)
    }
    
    private var guideTitleAndSummary: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(guide.title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.green)
                .padding(.horizontal)
            
            Text(guide.summary)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.horizontal)
        }
    }
    
    private var guideContentSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Article Content:")
                .font(.headline)
                .foregroundColor(.primary)
                .padding(.horizontal)
            
            Text(guide.content)
                .font(.body)
                .padding(.horizontal)
        }
    }
}

// Sample Preview
#Preview {
    let guide = Guide(
        id: 0,
        title: "The Importance of Sleep",
        summary: "Understanding how quality sleep contributes to health and well-being.",
        content: """
                 Sleep is a fundamental pillar of health that is often overlooked in our busy lives. This article examines the critical role that sleep plays in physical restoration, mental clarity, and overall well-being. During sleep, your body undergoes essential repair processes such as tissue regeneration, muscle growth, and memory consolidation.
                 
                 Quality sleep is essential for maintaining a strong immune system, regulating hormones, and supporting cognitive functions. Inadequate sleep has been linked to a range of health issues including obesity, diabetes, and cardiovascular disease. By prioritizing sleep, you not only improve your physical health but also enhance your mood and overall quality of life.
                 
                 This guide offers practical advice on how to improve your sleep hygiene, such as maintaining a consistent bedtime routine, creating a comfortable sleep environment, and reducing screen time before bed. Embracing these practices can lead to more restorative sleep and a healthier, more energetic life.
                 """,
        imageName: "sleep"
    )
    GuideListView(guide: guide)
}
