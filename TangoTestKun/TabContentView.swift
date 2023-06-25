//
//  TabContentView.swift
//  TangoTestKun
//
//  Created by 丹羽雄一朗 on 2023/06/25.
//

import SwiftUI

struct TabContentView: View {
    let tangoData: [TangoData]
    let isCheckingAnswers: Bool
    let testType: TestType

    var body: some View {
        if tangoData.isEmpty {
            Text("単語データが選択されていません。")
                .foregroundColor(.gray)
        } else {
            testContentList
        }
    }

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
}

enum TestType {
    case jp
    case en
}

struct TabContentView_Previews: PreviewProvider {
    static var previews: some View {
        TabContentView(tangoData: mockTangoData, isCheckingAnswers: false, testType: .jp)
    }
}
