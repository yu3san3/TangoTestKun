//
//  FileManager.swift
//  TangoTestKun
//
//  Created by 丹羽雄一朗 on 2023/06/25.
//

import Foundation

class FileOperator {
    private let fileManager = FileManager.default
    private let rootDirectory = NSHomeDirectory() + "/Documents"

    func isFileExisting(atPath path: String) -> Bool {
        return fileManager.fileExists(atPath: path)
    }

    func createExampleFile() {
        let path = rootDirectory + "/example.txt"
        let contents = TangoData.mockRawText.data(using: .utf8)
        createFile(atPath: path, contents: contents, allowSuperscription: true)
    }

    func createFile(atPath path: String, contents: Data?, allowSuperscription: Bool) {
        if isFileExisting(atPath: path) && !allowSuperscription { //同名ファイルがある場合に上書きをしない
            print("ファイルがすでに存在: \(NSString(string: path).lastPathComponent)")
            return
        }
        if !fileManager.createFile(atPath: path, contents: contents, attributes: nil) {
            print("ファイル作成に失敗")
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
