//
//  TabContentView.swift
//  TangoTestKun
//
//  Created by 丹羽雄一朗 on 2023/06/25.
//

import SwiftUI

struct JpView: View {
    let tangoData: [TangoData]
    let isCheckingAnswers: Bool

    var body: some View {
        if tangoData.isEmpty {
            Text("単語データが選択されていません。")
                .foregroundColor(.gray)
        } else {
            List(0..<tangoData.count, id: \.self) { index in
                HStack {
                    Image(systemName: "\(index+1).circle")
                    Text(tangoData[index].jp)
                    if isCheckingAnswers {
                        Spacer()
                        Text(tangoData[index].en)
                    }
                }
            }
            .listStyle(.plain)
        }
    }
}

struct EnView: View {
    let tangoData: [TangoData]
    let isCheckingAnswers: Bool

    var body: some View {
        if tangoData.isEmpty {
            Text("単語データが選択されていません。")
                .foregroundColor(.gray)
        } else {
            List(0..<tangoData.count, id: \.self) { index in
                HStack {
                    Image(systemName: "\(index+1).circle")
                    Text(tangoData[index].en)
                    if isCheckingAnswers {
                        Spacer()
                        Text(tangoData[index].jp)
                    }
                }
            }
            .listStyle(.plain)
        }
    }
}

struct TabContentView_Previews: PreviewProvider {
    static var previews: some View {
        JpView(tangoData: mockTangoData, isCheckingAnswers: false)
        EnView(tangoData: mockTangoData, isCheckingAnswers: false)
    }
}
