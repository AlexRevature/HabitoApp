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
                .clipShape(Circle())
                .frame(maxWidth: 170)
                .padding(.top, 30)
                .padding(.bottom, 2)
            Text(viewModel.userInfo?.name ?? "Empty")
                .bold()
            Text(viewModel.userInfo?.email ?? "N/A")
                .padding(.bottom, 15)
            LayerInfo()
                .padding(.bottom, 5)

            List {
                ForEach(viewModel.actionList) { rowInfo in
                    ActionRow(imageName: rowInfo.imageName, text: rowInfo.text, tint: rowInfo.tintColor)
                }
            }
            Spacer()
        }
    }
}

private struct ActionRow: View {

    var imageName: String
    var text: String
    var tint: Color

    var body: some View {
        NavigationLink {
            Text("")
        } label: {
            HStack {
                Image(systemName: imageName)
                    .padding(.trailing, 8)
                Text(text)
                Spacer()
            }
            .foregroundStyle(tint)
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


#Preview {
    NavigationStack {
        ProfileMainView()
    }
}
