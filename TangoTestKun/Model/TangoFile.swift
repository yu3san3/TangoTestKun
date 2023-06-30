//
//  TangoModel.swift
//  TangoTestKun
//
//  Created by 丹羽雄一朗 on 2023/06/25.
//

import Foundation

class TangoFile: ObservableObject {
    @Published var tangoData: [TangoDataElement] = []
    @Published var fileURL: URL
    @Published var rawText: String {
        didSet {
            tangoData = TangoParser.parse(rawText)
        }
    }

    init(fileURL: URL, rawText: String) {
        self.fileURL = fileURL
        self.rawText = rawText
    }

    init() {
        self.fileURL = TangoFile.mockURL
        self.rawText = ""
    }
}

extension TangoFile {
    static let mockTangoData = TangoParser.parse(mockRawText)
    static let mockURL = FileOperator.rootDirectory
    static let mockRawText = """
        起動する、開始する=launch
        意図=intent
        適格である=eligible
        束=bundle
        浮く=float
        委任する、代表=delegate
        制限、制約=restriction
        登録する、記録=register
        整列、調整=alignment
        半径=radius
    """
}
