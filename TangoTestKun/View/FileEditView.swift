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
    let editMode: EditMode
    @ObservedObject var nowEditingFile: TangoData
    @State private var textEditorContent: String

    @State private var isExporting = false
    @State private var isShowingDismissAlert = false
    @FocusState private var isEditing: Bool

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
        self._textEditorContent = State(initialValue: "")
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
                .navigationTitle(fileName)
                .navigationBarTitleDisplayMode(.inline)
                .fileExporter(
                    isPresented: $isExporting,
                    document: TangoFile(initialText: textEditorContent),
                    contentType: .plainText,
                    defaultFilename: "新規ファイル"
                ) { result in
                    if case .success = result {
                        print("正常に出力されました")
                    } else {
                        print("出力できませんでした")
                    }
                    dismiss()
                }
        }
    }
}

private extension FileEditView {
    var fileName: String {
        switch editMode {
        case .existingFile:
            return nowEditingFile.fileURL.lastPathComponent //ファイル名を取得
        case .newFile:
            return "新規ファイル"
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
            guard textEditorContent != nowEditingFile.rawText else {
                dismiss()
                return
            }
            isShowingDismissAlert = true
        }) {
            Text("キャンセル")
        }
        .alert("本当に戻りますか？", isPresented: $isShowingDismissAlert) {
            Button("はい", role: .destructive) { dismiss() }
            Button("いいえ", role: .cancel) {}
        } message: {
            Text("「はい」を押すと、今までの編集内容は保存されません。")
        }
    }

    var saveButton: some View {
        Button(action: {
            switch editMode {
            case .existingFile:
                saveExistingFile(textContent: textEditorContent)
            case .newFile:
                isExporting = true
            }
        }) {
            Text("保存")
        }
    }

    func saveExistingFile(textContent: String) {
        let fileOperator = FileOperator()
        nowEditingFile.rawText = textContent
        nowEditingFile.tangoData = TangoParser.parse(textContent)
        fileOperator.writeFile(atPath: nowEditingFile.fileURL, content: textContent)
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
