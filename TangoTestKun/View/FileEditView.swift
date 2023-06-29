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
    @ObservedObject var nowEditingFile: TangoData

    let fileOperator = FileOperator()

    @State var isExporting: Bool = false
    @State var textEditorContent: String = ""
    @FocusState private var isEditing: Bool

    let editMode: EditMode

    @Environment(\.dismiss) var dismiss

    init(tangoData: TangoData) {
        self.editMode = .existingFile
        self.nowEditingFile = tangoData
        self._textEditorContent = State(initialValue: tangoData.rawText)
    }

    init() {
        let newTangoData = TangoData()
        self.editMode = .newFile
        self.nowEditingFile = newTangoData
    }

    var body: some View {
        NavigationStack {
            textEditor
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        cancelButton
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        saveButton
                    }
                }
                .navigationTitle(nowEditingFile.fileURL.lastPathComponent) //ファイル名を取得
                .navigationBarTitleDisplayMode(.inline)
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

    var textEditor: some View {
        TextEditor(text: $textEditorContent)
            .focused($isEditing)
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("完了") {
                        isEditing = false
                    }
                }
            }
    }

    var cancelButton: some View {
        Button(action: {
            dismiss()
        }) {
            Text("キャンセル")
        }
    }

    var saveButton: some View {
        Button(action: {
            switch editMode {
            case .existingFile:
                saveExistingFile()
            case .newFile:
                isExporting = true
            }
        }) {
            Text("保存")
        }
    }

    private func saveExistingFile() {
        nowEditingFile.rawText = textEditorContent
        nowEditingFile.tangoData = TangoParser.parse(textEditorContent)
        fileOperator.writeFile(atPath: nowEditingFile.fileURL, content: textEditorContent)
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
