//
//  TangoModel.swift
//  TangoTestKun
//
//  Created by 丹羽雄一朗 on 2023/06/25.
//

import Foundation

class TangoData: ObservableObject {
    @Published var tangoData: [TangoDataElement] = []
    @Published var fileURL = mockURL
    @Published var rawText = "no file selected"
}
