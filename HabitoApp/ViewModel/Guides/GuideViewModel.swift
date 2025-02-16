//
//  GuideViewModel.swift
//  HabitoApp
//
//  Created by Areeb Durrani on 2/16/25.
//

import SwiftUI

@MainActor
class GuideViewModel: ObservableObject {
    @Published var guides: [GuideInfoFull] = []
    
    /// Fetches guides from the database, rotates the array based on the day of the month, and returns it.
    func getGuides() -> [GuideInfoFull] {
        // Fetch all guides from the database.
        let guidesFromDB = GuideModel.shared.getGuides()
        
        // Map the Guide model to our view-friendly GuideInfoFull struct.
        let guideInfos = guidesFromDB.map { guide -> GuideInfoFull in
            let image = UIImage(named: guide.imageName) ?? UIImage(systemName: "questionmark")!
            return GuideInfoFull(
                title: guide.title,
                summary: guide.summary,
                content: guide.content,
                image: image
            )
        }
        
        guard !guideInfos.isEmpty else { return [] }
        
        // Rotate the array based on the day of the month.
        let dayNum = Calendar.current.component(.day, from: Date())
        let index = dayNum % guideInfos.count
        return Array(guideInfos[index...] + guideInfos[..<index])
    }
    
    /// Refreshes the published guides array.
    func refreshGuides() {
        self.guides = getGuides()
    }
}

struct GuideInfoFull: Identifiable {
    var id = UUID()
    var title: String
    var summary: String
    var content: String
    var image: UIImage
}
