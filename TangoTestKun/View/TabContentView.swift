//
//  TabContentView.swift
//  TangoTestKun
//
//  Created by 丹羽雄一朗 on 2023/06/25.
//

import SwiftUI

struct TabContentView: View {
    @Binding var tangoData: [TangoDataElement]
    @State private var isCheckingAnswers = false
    let testType: TestType

    var body: some View {
        if tangoData.isEmpty {
            Text("単語データが選択されていません。")
                .foregroundColor(.gray)
        } else {
            ZStack(alignment: .bottomTrailing) {
                testContentList
                bottomButton
            }
        }
    }

    private var testContentList: some View {
        List(0..<tangoData.endIndex, id: \.self) { index in
            HStack {
                Image(systemName: "\(index+1).circle")
                switch testType {
                case .jp:
                    Text(tangoData[index].jp)
                    if isCheckingAnswers {
                        Spacer()
                        Text(tangoData[index].en)
                    }
                case .en:
                    Text(tangoData[index].en)
                    if isCheckingAnswers {
                        Spacer()
                        Text(tangoData[index].jp)
                    }
                }

            }
        }
        .listStyle(.plain)
    }

    private var bottomButton: some View {
        HStack(spacing: 0) {
            shuffleButton
            Divider()
            showAnswersButton()
        }
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10.0)
                .stroke(lineWidth: 0.5)
                .foregroundColor(.blue)
        )
        .frame(height: 17)
        .padding(.horizontal)
        .padding(.vertical, 30)
    }

    private var shuffleButton: some View {
        Button(action: {
            tangoData.shuffle()
        }) {
            Image(systemName: "shuffle")
                .frame(width: 17, height: 17)
                .padding()
        }
    }

    @ViewBuilder
    private func showAnswersButton() -> some View {
        let backGroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.1)
        Button(action: {
            isCheckingAnswers.toggle()
        }) {
            Image(systemName: isCheckingAnswers ? "pencil" : "pencil.slash")
                .frame(width: 17, height: 17)
                .padding()
                .background(
                    isCheckingAnswers ? Color(backGroundColor) : Color.clear
                )
        }
    }
}

struct TabContentView_Previews: PreviewProvider {
    static var previews: some View {
        TabContentView(tangoData: .constant(TangoData.mockTangoData), testType: .jp)
    }
}

