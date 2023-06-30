//
//  TabContentView.swift
//  TangoTestKun
//
//  Created by 丹羽雄一朗 on 2023/06/25.
//

import SwiftUI

struct TabContentView: View {
    @ObservedObject var tangoData: TangoData
    @State private var isCheckingAnswers = false
    let testType: TestType

    var body: some View {
        if tangoData.tangoData.isEmpty {
            Text("単語データが選択されていません。")
                .foregroundColor(.gray)
        } else {
            testContentList
        }
    }

    var testContentList: some View {
        ZStack(alignment: .bottomTrailing) {
            List(0..<tangoData.tangoData.endIndex, id: \.self) { index in
                HStack {
                    Image(systemName: "\(index+1).circle")
                    switch testType {
                    case .jp:
                        Text(tangoData.tangoData[index].jp)
                        if isCheckingAnswers {
                            Spacer()
                            Text(tangoData.tangoData[index].en)
                        }
                    case .en:
                        Text(tangoData.tangoData[index].en)
                        if isCheckingAnswers {
                            Spacer()
                            Text(tangoData.tangoData[index].jp)
                        }
                    }

                }
            }
            .listStyle(.plain)
            HStack {
                shuffleButton
                showAnswersToggle
            }
            .padding()
        }
    }

    var shuffleButton: some View {
        Button(action: {
            tangoData.tangoData.shuffle()
        }) {
            Image(systemName: "shuffle")
        }
    }

    var showAnswersToggle: some View {
        Toggle(isOn: $isCheckingAnswers) {
            Image(systemName: isCheckingAnswers ? "pencil" : "pencil.slash")
        }
        .toggleStyle(.button)
    }
}

struct TabContentView_Previews: PreviewProvider {
    static var previews: some View {
        let tangoData = TangoData(
            tangoData: TangoData.mockTangoData,
            fileURL: TangoData.mockURL,
            rawText: TangoData.mockRawText
        )
        TabContentView(tangoData: tangoData, testType: .jp)
    }
}

