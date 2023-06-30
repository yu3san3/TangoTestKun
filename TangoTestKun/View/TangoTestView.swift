//
//  TabContentView.swift
//  TangoTestKun
//
//  Created by 丹羽雄一朗 on 2023/06/25.
//

import SwiftUI

struct TangoTestView: View {
    @Binding var tangoData: [TangoDataElement]
    let testType: TestType
    @Binding var isCheckingAnswers: Bool

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
}

private extension TangoTestView {
    var testContentList: some View {
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

    var bottomButton: some View {
        HStack(spacing: 0) {
            shuffleButton
            Divider()
            showAnswersButton
        }
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10.0)
                .stroke(lineWidth: 0.5)
                .foregroundColor(.blue)
        )
        .frame(height: 10)
        .padding(.horizontal, 23)
        .padding(.vertical, 30)
    }

    var shuffleButton: some View {
        Button(action: {
            tangoData.shuffle()
        }) {
            Image(systemName: "shuffle")
                .frame(width: 13, height: 10)
                .padding()
                .background(Color(UIColor.systemBackground))
        }
    }

    var showAnswersButton: some View {
        Button(action: {
            isCheckingAnswers.toggle()
        }) {
            Image(systemName: isCheckingAnswers ? "pencil" : "pencil.slash")
                .frame(width: 13, height: 10)
                .padding()
                .foregroundColor(isCheckingAnswers ? .red : nil)
                .background(Color(UIColor.systemBackground))
        }
    }
}

struct TabContentView_Previews: PreviewProvider {
    static var previews: some View {
        TangoTestView(
            tangoData: .constant(TangoFile.mockTangoData),
            testType: .jp,
            isCheckingAnswers: .constant(false)
        )
    }
}

