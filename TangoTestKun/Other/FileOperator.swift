//
//  FileManager.swift
//  TangoTestKun
//
//  Created by 丹羽雄一朗 on 2023/06/25.
//

import Foundation

class FileOperator {
    private let fileManager = FileManager.default
    private let rootDirectory = NSHomeDirectory() + "/Documents/hoge"

    init() {
        createDirectory(atPath: rootDirectory)
    }

    func isFileExisting(atPath path: String) -> Bool {
        return fileManager.fileExists(atPath: path)
    }

    func createDirectory(atPath path: String) {
        if isFileExisting(atPath: path) {
            return
        }
        do {
            try fileManager.createDirectory(atPath: path, withIntermediateDirectories: false, attributes: nil)
        } catch let error {
            print(error.localizedDescription)
        }
    }

    func writeFile(atPath path: URL, content: String) {
        do {
            try content.write(to: path, atomically: true, encoding: .utf8)
        } catch {
            print("書き込み失敗: \(error.localizedDescription)")
        }
    }
}
