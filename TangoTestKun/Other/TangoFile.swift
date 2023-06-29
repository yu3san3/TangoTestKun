//
//  TangoFile.swift
//  TangoTestKun
//
//  Created by 丹羽雄一朗 on 2023/06/30.
//

import SwiftUI
import UniformTypeIdentifiers

/// refs: https://www.hackingwithswift.com/quick-start/swiftui/how-to-export-files-using-fileexporter
struct TangoFile: FileDocument {
    // tell the system we support only plain text
    static var readableContentTypes = [UTType.plainText]

    // by default our document is empty
    var text = ""

    // a simple initializer that creates new, empty documents
    init(initialText: String = "") {
        text = initialText
    }

    // this initializer loads data that has been saved previously
    init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents {
            text = String(decoding: data, as: UTF8.self)
        }
    }

    // this will be called when the system wants to write our data to disk
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = Data(text.utf8)
        return FileWrapper(regularFileWithContents: data)
    }
}
