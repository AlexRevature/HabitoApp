//
//  AnalysisView.swift
//  HabitoApp
//
//  Created by Alex Cabrera on 2/12/25.
//

import SwiftUI

struct AnalysisView: View {
    var body: some View {
        VStack {
            topCard
                .frame(maxHeight: 100)
                .padding(.bottom, 15)
            barCard
                .frame(maxHeight: 240)
                .padding(.bottom, 15)
            HStack {
                sleepCard
                stepCard
            }
            .frame(maxHeight: 140)
            Spacer()
        }
        .padding(.horizontal, 30)
    }

    var topCard: some View {
        HStack {
            Text("Today's Progress!")
            Spacer()
            PercentageCircle(percentage: 0.5)
        }
        .padding()
        .background(.customLight)
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }

    var barCard: some View {
        VStack {
            HStack {
                Text("Days")
                Spacer()
                Text("7 Days")
            }
            barGroup
        }
        .padding()
        .background(.customLight)
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }

    var barGroup: some View {
        HStack {
            ForEach(0..<7) { idx in
                VStack {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(.customPrimary)
                    Text("Mon")
                }
//                .frame(maxHeight: 170)
            }
        }
    }

    var sleepCard: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                Text("Sleep")
                PercentageCircle(percentage: 0.5)
            }
            Text("8/8 Hourse")
        }
        .padding()
        .background(.customLight)
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }

    var stepCard: some View {
        VStack {
            Image(systemName: "circle")
            Spacer()
            Text("Steps")
                .padding(.bottom, 10)
            Text("5000")
        }
        .padding()
        .background(.customLight)
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }

    private struct PercentageCircle: View {
        var percentage: Double

        var body: some View {
            ZStack {
                Circle()
                    .stroke(Color.white.opacity(0.9), lineWidth: 8)

                Circle()
                    .trim(from: 0, to: percentage)
                    .stroke(Color.green, lineWidth: 8)
                    .rotationEffect(.degrees(-90))

                Text("\(Int(percentage * 100))%")
                    .font(.title2)
                    .foregroundStyle(.white)
                    .bold()
            }
        }
    }
}

#Preview {
    AnalysisView()
}
