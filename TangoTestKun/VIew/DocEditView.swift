//
//  DocEditView.swift
//  TangoTestKun
//
//  Created by 丹羽雄一朗 on 2023/06/25.
//

import SwiftUI

struct DocEditView: View {
    @ObservedObject var tangoModel: TangoModel
    let fileOperator = FileOperator()

    @State var textEditorContent: String = ""
    @FocusState private var isEditing: Bool

    @Environment(\.dismiss) var dismiss

    init(tangoModel: TangoModel) {
        self.tangoModel = tangoModel
        self._textEditorContent = State(initialValue: tangoModel.rawText)
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
                .listStyle(.plain)
            .navigationTitle(tangoModel.fileURL.lastPathComponent) //ファイル名を取得
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
                        tangoModel.rawText = textEditorContent
                        tangoModel.tangoData = TangoParser.parse(textEditorContent)
                        fileOperator.writeFile(atPath: tangoModel.fileURL, content: textEditorContent)
                        print("保存処理おわり")
                        dismiss()
                    }) {
                        Text("保存")
                    }
                }
            }
        }
    }
}

struct DocEditView_Previews: PreviewProvider {
    static var previews: some View {
        DocEditView(tangoModel: TangoModel())
    }
}
