//
//  GuideMainView.swift
//  HabitoApp
//
//  Created by Areeb Durrani on 2/16/25.
//

import SwiftUI

struct GuideMainView: View {
    var guides: [Guide] = GuideModel.shared.getGuides()
    
    var body: some View {
        NavigationStack {
            // Main content
            VStack(alignment: .leading) {
                Text("Healthy Living Guides")
                    .font(.title)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 20)
                
                Text("Wellness Articles")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding(.leading, 16)
                    .padding(.top, 5)
                
                ScrollView {
                    ForEach(guides, id: \.id) { guide in
                        NavigationLink(destination: GuideListView(guide: guide)) {
                            GuideCard(guide: guide)
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .padding(.top, 10)
            }
            .background(Color(.systemGray6))
            .edgesIgnoringSafeArea(.bottom)
        }
    }
}

struct GuideCard: View {
    let guide: Guide
    
    var body: some View {
        VStack(alignment: .leading) {
            if let image = UIImage(named: guide.imageName) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            
            Text(guide.title)
                .font(.headline)
                .foregroundColor(.primary)
                .padding(.leading, 10)
                .padding(.top, 5)
            
            Text(guide.summary)
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.leading, 10)
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(radius: 2)
    }
}

// Sample Preview
#Preview {
    GuideMainView()
}
