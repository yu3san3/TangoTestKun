//
//  TangoDataElement.swift
//  TangoTestKun
//
//  Created by 丹羽雄一朗 on 2023/06/28.
//

import Foundation

struct TangoDataElement: Hashable {
    var jp: String
    var en: String
}

let mockRawText =
"""
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
