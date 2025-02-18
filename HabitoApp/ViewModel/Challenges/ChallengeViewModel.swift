import SwiftUI

@MainActor
class ChallengeViewModel: ObservableObject {
    @Published var challenges: [ChallengeInfoFull] = []
    var userId: Int?  // New property to store current user's id
    
    /// Fetches challenges from the database for the given date,
    /// rotates the array based on the day of the month, and returns it.
    func getChallenges(for date: Date) -> [ChallengeInfoFull] {
        guard let userId = self.userId else { return [] }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let targetDateString = dateFormatter.string(from: date)
        guard let targetDate = dateFormatter.date(from: targetDateString) else {
            return []
        }
        
        let challengesFromDB = ChallengeModel.shared.getChallenges(forUser: userId).filter { challenge in
            guard let start = dateFormatter.date(from: challenge.startDate),
                  let end = dateFormatter.date(from: challenge.endDate)
            else {
                return false
            }
            return targetDate >= start && targetDate <= end
        }
        
        let challengeInfos = challengesFromDB.map { challenge -> ChallengeInfoFull in
            let image = UIImage(named: challenge.imageName) ?? UIImage(systemName: "questionmark")!
            let backImage = UIImage(named: challenge.backImageName) ?? UIImage(systemName: "questionmark")!
            let trackImage = UIImage(named: challenge.trackImageName) ?? UIImage(systemName: "questionmark")!
            return ChallengeInfoFull(
                id: challenge.id,
                title: challenge.title,
                message: challenge.message,
                image: image,
                backImage: backImage,
                trackImage: trackImage,
                count: challenge.count,
                total: challenge.total,
                unit: challenge.unit,
                startDate: challenge.startDate,
                endDate: challenge.endDate
            )
        }
        
        // Optionally, rotate the array if desired.
        if !challengeInfos.isEmpty {
            let dayNum = Calendar.current.component(.day, from: date)
            let index = dayNum % challengeInfos.count
            return Array(challengeInfos[index...] + challengeInfos[..<index])
        }
        
        return challengeInfos
    }
    
    func oldestChallenge(userID: Int?) -> ChallengeInfoFull? {
        let challengesFromDB = ChallengeModel.shared.getChallenges(forUser: userID ?? -1)
        
        // Unwrap only the challenge if it's available
        guard let challenge = challengesFromDB.first else { return nil }
        
        // Directly assign the properties since they're non-optional
        let title = challenge.title
        let message = challenge.message
        let imageName = challenge.imageName
        let backImageName = challenge.backImageName
        let trackImageName = challenge.trackImageName
        let startDate = challenge.startDate
        let endDate = challenge.endDate

        // Convert image names to UIImage objects.
        let image = UIImage(named: imageName) ?? UIImage()
        let backImage = UIImage(named: backImageName) ?? UIImage()
        let trackImage = UIImage(named: trackImageName) ?? UIImage()
        
        return ChallengeInfoFull(
            id: challenge.id,
            title: title,
            message: message,
            image: image,
            backImage: backImage,
            trackImage: trackImage,
            count: challenge.count,
            total: challenge.total,
            unit: challenge.unit,
            startDate: startDate,
            endDate: endDate
        )
    }



    
    /// Refreshes the published challenges array using the selected date.
    func refreshChallenges(for date: Date) {
        self.challenges = getChallenges(for: date)
    }
}

struct ChallengeInfoFull: Identifiable {
    var id: Int64
    var title: String
    var message: String
    var image: UIImage
    var backImage: UIImage
    var trackImage: UIImage
    var count: Int
    var total: Int
    var unit: String
    var startDate: String  // New property
    var endDate: String    // New property
}
