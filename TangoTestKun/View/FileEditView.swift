//
//  DocEditView.swift
//  TangoTestKun
//
//  Created by 丹羽雄一朗 on 2023/06/25.
//

import SwiftUI

struct FileEditView: View {
    let editMode: EditMode
    @ObservedObject var nowEditingFile: TangoFile
    @State private var textEditorContent: String

    @State private var isExporting = false
    @State private var isShowingDismissAlert = false
    @FocusState private var isEditing: Bool

    @Environment(\.dismiss) var dismiss

    init(tangoFile: TangoFile, editMode: EditMode) {
        switch editMode {
        case .existingFile:
            self.editMode = editMode
            self.nowEditingFile = tangoFile
            self._textEditorContent = State(initialValue: tangoFile.rawText)
        case .newFile:
            self.editMode = editMode
            self.nowEditingFile = tangoFile
            self._textEditorContent = State(initialValue: "")
        }
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
                    document: TextFile(initialText: textEditorContent),
                    contentType: .plainText,
                    defaultFilename: fileName
                ) { result in
                    switch result {
                    case .success(let url):
                        nowEditingFile.fileURL = url
                        nowEditingFile.rawText = textEditorContent
                    case .failure(let error):
                        print("❗️書き出し失敗\(error.localizedDescription)")
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
            .onAppear {
                if editMode == .newFile {
                    isEditing = true
                }
            }
    }

    var cancelButton: some View {
        Button(action: {
            if !hasChanges() {
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

    func hasChanges() -> Bool {
        switch editMode {
        case .existingFile:
            if textEditorContent != nowEditingFile.rawText {
                return true
            }
        case .newFile:
            if textEditorContent != "" {
                return true
            }
        }
        return false
    }

    var saveButton: some View {
        Button(action: {
            isExporting = true
        }) {
            Text("保存")
        }
    }

    @available(*, deprecated, message: "ファイルを書き出す際にはfileExporterを使おう")
    func saveExistingFile() {
        let fileOperator = FileOperator()
        fileOperator.writeFile(atPath: nowEditingFile.fileURL, content: textEditorContent, allowSuperscription: true)
    }
}

struct DocEditView_Previews: PreviewProvider {
    static var previews: some View {
        let tangoFile = TangoFile(
            fileURL: TangoFile.mockURL,
            rawText: TangoFile.mockRawText
        )
        FileEditView(tangoFile: tangoFile, editMode: .existingFile)
    }
}
