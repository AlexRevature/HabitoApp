import SwiftUI

@Observable
class ChallengeViewModel {
    
    /// Returns challenges for a specific date by fetching them from the database,
    /// mapping image names to UIImages from the asset bundle, and rotating the array.
    func getChallenges(date: Date) -> [ChallengeInfoFull] {
        // Fetch challenges from the database.
        let challenges = ChallengeModel.shared.getChallenges()
        
        // Map each Challenge to a ChallengeInfoFull for the UI,
        // using the image names to load assets.
        let challengeInfos = challenges.map { challenge -> ChallengeInfoFull in
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
        
        // Rotate the array based on the day of the month.
        guard !challengeInfos.isEmpty else { return [] }
        let dayNum = Calendar.current.component(.day, from: date)
        let index = dayNum % challengeInfos.count
        return Array(challengeInfos[index...] + challengeInfos[..<index])
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
