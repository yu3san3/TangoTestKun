//
//  TangoParser.swift
//  TangoTestKun
//
//  Created by 丹羽雄一朗 on 2023/02/12.
//

import Foundation

class Tango {
    static func parse(_ text: String) -> [TangoData] {
        
        var result: [TangoData] = []
        result.append(TangoData(jp: "", en: ""))
        
        for lineRow in text.components(separatedBy: .newlines) { //textを1行づつ処理
            result.append(TangoData(jp: "", en: ""))
            let tangoCount: Int = (result.endIndex-1)-1 //配列内の編集すべきインデックスを示す
            let line: String = lineRow.trimmingCharacters(in: .whitespaces) //行の端にある空白を削除
            if line == "" {
                continue
            } else {
                var jpAndEn: [String] = line.components(separatedBy: "=")
                let jp: String = jpAndEn.removeFirst() //左側
                let en: String = jpAndEn.joined(separator: "=") //右側
                result[tangoCount].jp = jp
                result[tangoCount].en = en
            }
        }
        result.removeLast() //余分な空の要素を削除
        return result
    }
}

//ここから下はオブジェクトの定義

struct TangoData: Hashable {
    var jp: String
    var en: String
}
