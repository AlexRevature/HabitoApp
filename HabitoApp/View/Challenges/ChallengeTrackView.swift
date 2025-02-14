//
//  ChallengeTrackView.swift
//  HabitoApp
//
//  Created by Areeb Durrani on 2/13/25.
//

import SwiftUI

struct ChallengeTrackView: View {
    @Binding var info: ChallengeInfoFull
    @State var value: Double
    @State private var navigateToNotification = false

    init(info: Binding<ChallengeInfoFull>) {
        self._info = info
        self.value = Double(info.wrappedValue.count)
    }

    var body: some View {
        NavigationView() {
            VStack {
                Text(info.title)
                    .font(.title)
                Text(info.message)
                
                imageStack
                    .padding(.vertical, 90)
                
                Slider(
                    value: $value,
                    in: 0...Double(info.total),
                    step: 1
                )
                .tint(.blue)
                .padding(.horizontal, 45)
                .padding(.bottom, 30)
                
                Button {
                    // Navigate to ChallengeNotificationView
                    navigateToNotification = true
                } label: {
                    Text("Done")
                        .tint(.white)
                        .padding(EdgeInsets(top: 12, leading: 30, bottom: 12, trailing: 30))
                        .background(.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                
                // Invisible NavigationLink activated when navigateToNotification becomes true.
                NavigationLink(destination: ChallengeNotifyView(), isActive: $navigateToNotification) {
                    EmptyView()
                }
                
                Spacer()
            }
            .padding(.top, 80)
            .onChange(of: value) { newValue in
                info.count = Int(newValue)
            }
        }
    }
    
    var imageStack: some View {
        ZStack {
            Image(systemName: "circle")
                .resizable()
                .foregroundStyle(.blue)
                .scaledToFit()
                .frame(width: 200, height: 200)
            Text("\(info.count)")
                .font(.title)
        }
    }
}

#Preview {
    @Previewable
    @State var challenge = ChallengeViewModel().getChallenges(for: Date())[0]
    ChallengeTrackView(info: $challenge)
}
