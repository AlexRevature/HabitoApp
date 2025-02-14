import SwiftUI

import SwiftUI

@MainActor
class ChallengeViewModel: ObservableObject {
    @Published var challenges: [ChallengeInfoFull] = []
    
    /// Fetches challenges from the database for the given date,
    /// rotates the array based on the day of the month, and returns it.
    func getChallenges(for date: Date) -> [ChallengeInfoFull] {
        let challengesFromDB = ChallengeModel.shared.getChallenges()
        let challengeInfos = challengesFromDB.map { challenge -> ChallengeInfoFull in
            let image = UIImage(named: challenge.imageName) ?? UIImage(systemName: "questionmark")!
            let backImage = UIImage(named: challenge.backImageName) ?? UIImage(systemName: "questionmark")!
            let trackImage = UIImage(named: challenge.trackImageName) ?? UIImage(systemName: "questionmark")!
            return ChallengeInfoFull(
                title: challenge.title,
                message: challenge.message,
                image: image,
                backImage: backImage,
                trackImage: trackImage,
                count: challenge.count,
                total: challenge.total,
                unit: challenge.unit
            )
        }
        guard !challengeInfos.isEmpty else { return [] }
        let dayNum = Calendar.current.component(.day, from: date)
        let index = dayNum % challengeInfos.count
        return Array(challengeInfos[index...] + challengeInfos[..<index])
    }
    
    /// Refreshes the published challenges array using the selected date.
    func refreshChallenges(for date: Date) {
        self.challenges = getChallenges(for: date)
    }
}


struct ChallengeInfoFull: Identifiable {
    var id = UUID()
    var title: String
    var message: String
    var image: UIImage
    var backImage: UIImage
    var trackImage: UIImage
    var count: Int
    var total: Int
    var unit: String
}
