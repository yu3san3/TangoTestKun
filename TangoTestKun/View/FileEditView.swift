//
//  DocEditView.swift
//  TangoTestKun
//
//  Created by 丹羽雄一朗 on 2023/06/25.
//

import SwiftUI

enum EditMode {
    case existingFile
    case newFile
}

struct FileEditView: View {
    @ObservedObject var tangoData: TangoData

    let fileOperator = FileOperator()

    @State var isExporting: Bool = false
    @State var textEditorContent: String = ""
    @FocusState private var isEditing: Bool

    let editMode: EditMode

    @Environment(\.dismiss) var dismiss

    init(tangoData: TangoData) {
        self.editMode = .existingFile
        self.tangoData = tangoData
        self._textEditorContent = State(initialValue: tangoData.rawText)
    }

    init() {
        let newTangoData = TangoData()
        self.editMode = .newFile
        self.tangoData = newTangoData
    }

    var body: some View {
        NavigationStack {
            TextEditor(text: $textEditorContent)
                .listRowSeparator(.hidden)
                .focused($isEditing)
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button("完了") {
                            isEditing = false
                        }
                    }
                }
                .listStyle(.plain)            .navigationTitle(tangoData.fileURL.lastPathComponent) //ファイル名を取得
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            dismiss()
                        }) {
                        Text("キャンセル")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        switch editMode {
                        case .existingFile:
                            tangoData.rawText = textEditorContent
                            tangoData.tangoData = TangoParser.parse(textEditorContent)
                            fileOperator.writeFile(atPath: tangoData.fileURL, content: textEditorContent)
                        case .newFile:
                            isExporting = true
                        }
                    }) {
                        Text("保存")
                    }
                }
            }
            .fileExporter(
                isPresented: $isExporting,
                document: TangoFile(initialText: textEditorContent),
                contentType: .plainText,
                defaultFilename: "NewFile"
            ) { result in
                if case .success = result {
                    print("Success!")
                } else {
                    print("Something went wrong…")
                }
                dismiss()
            }
        }
    }
}

struct DocEditView_Previews: PreviewProvider {
    static var previews: some View {
        let tangoData = TangoData(
            tangoData: TangoData.mockTangoData,
            fileURL: TangoData.mockURL,
            rawText: TangoData.mockRawText
        )
        FileEditView(tangoData: tangoData)
    }
}
