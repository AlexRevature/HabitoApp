//
//  ProfileMainView.swift
//  HabitoApp
//
//  Created by Alex Cabrera on 2/6/25.
//

import SwiftUI

struct ProfileMainView: View {

    @State var viewModel = ProfileViewModel()

    var body: some View {
        VStack {
            Image(uiImage: viewModel.userInfo?.image ?? UIImage(systemName: "person.circle")!)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 120)
                .padding(.top, 30)
                .padding(.bottom, 2)
            Text(viewModel.userInfo?.name ?? "Empty")
            Text(viewModel.userInfo?.email ?? "N/A")
                .padding(.bottom, 15)
            LayerInfo()
                .padding(.bottom, 5)

            List {
                ForEach(viewModel.actionList) { rowInfo in
                    ActionRow(image: rowInfo.actionImage, text: rowInfo.text)
                }
            }
            Spacer()
        }
    }
}

private struct ActionRow: View {

    var image: UIImage
    var text: String

    var body: some View {
        NavigationLink {
            Text("")
        } label: {
            HStack {
                Image(uiImage: image)
                    .padding(.trailing, 8)
                Text(text)
                Spacer()
            }
            .padding(.vertical, 8)
        }
    }
}

private struct LayerInfo: View {
    var body: some View {
        HStack {
            ForEach(0..<3) { idx in
                LayerCell()
                    .padding(.horizontal, 10)
            }
        }
    }
}

private struct LayerCell: View {
    var body: some View {
        VStack {
            Image(systemName: "circle")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 60)
            Text("Test 1")
            Text("Test 2")
        }
    }
}


//#Preview {
//    NavigationStack {
//        ProfileMainView()
//    }
//}
