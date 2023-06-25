//
//  FileManager.swift
//  TangoTestKun
//
//  Created by 丹羽雄一朗 on 2023/06/25.
//

import Foundation

class FileOperator {
    private let fileManager = FileManager.default

    func isFileExisting(atPath path: String) -> Bool {
        return fileManager.fileExists(atPath: path)
    }

    func writeFile(atPath path: URL, content: String) {
        do {
            try content.write(to: path, atomically: true, encoding: .utf8)
        } catch {
            print("書き込み失敗")
        }
    }
}

let str =  NSHomeDirectory() + "/Documents"
let mockURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
