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

    func createSampleFile() {
        if let iCloudPath = FileOperator.iCloudRootDirectory?.appendingPathComponent("sample.txt") {
            print("iCloudへsample.txtを作成")
            writeFile(atPath: iCloudPath, content: TangoFile.mockRawText, allowSuperscription: false)
        }
        let localPath = FileOperator.localRootDirectory.appendingPathComponent("sample.txt")
        print("localへsample.txtを作成")
        writeFile(atPath: localPath, content: TangoFile.mockRawText, allowSuperscription: false)
    }

    func writeFile(atPath path: URL, content: String, allowSuperscription: Bool) {
        if !allowSuperscription && isFileExisting(atPath: path) { //同名ファイルがある場合に上書きをしない
            print("ファイルがすでに存在: \(path.lastPathComponent)")
            return
        }
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
