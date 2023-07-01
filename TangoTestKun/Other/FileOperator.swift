//
//  FileManager.swift
//  TangoTestKun
//
//  Created by 丹羽雄一朗 on 2023/06/25.
//

import Foundation

class FileOperator {
    private let fileManager = FileManager.default

    func isFileExisting(atPath path: URL) -> Bool {
        return fileManager.fileExists(atPath: path.path)
    }

    func createExampleFile() {
        if let path = FileOperator.iCloudRootDirectory?.appendingPathComponent("sample.txt") {
            createFile(atPath: path, content: TangoFile.mockRawText, allowSuperscription: false)
        } else {
            print("❗️iCloudへの書き込みに失敗")
        }
    }

    func createFile(atPath path: URL, content: String, allowSuperscription: Bool) {
        if isFileExisting(atPath: path) && !allowSuperscription { //同名ファイルがある場合に上書きをしない
            print("ファイルがすでに存在: \(path.lastPathComponent)")
            return
        }
        if !fileManager.createFile(atPath: path.path, contents: content.data(using: .utf8), attributes: nil) {
            print("❗️ファイル作成失敗")
        }
    }

    func writeFile(atPath path: URL, content: String) {
        do {
            try content.write(to: path, atomically: true, encoding: .utf8)
        } catch {
            print("❗️書き込み失敗: \(error.localizedDescription)")
        }
    }
}

extension FileOperator {
    static let localRootDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let iCloudRootDirectory = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents")
}
