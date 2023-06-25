//
//  DocEditView.swift
//  TangoTestKun
//
//  Created by 丹羽雄一朗 on 2023/06/25.
//

import SwiftUI

struct DocEditView: View {
    @Environment(\.dismiss) var dismiss

    @State private var isEditing = false

    let fileName: String
    var rawText: String

    @State private var textEditorContent: String
    @FocusState private var isTextEditorFocused: Bool

    init(fileName: String, rawText: String) {
        self.fileName = fileName
        self.rawText = rawText
        self._textEditorContent = State(wrappedValue: rawText)
    }

    var body: some View {
        NavigationStack {
            Group {
                TextEditor(text: $textEditorContent)
                    .disabled(!isEditing)
                    .focused($isTextEditorFocused)
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            Spacer()
                            Button("完了") {
                                isEditing = false
                            }
                        }
                    }
            }
            .navigationTitle(fileName)
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

                    }) {
                        Text("保存")
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    Spacer()
                }
                ToolbarItem(placement: .bottomBar) {
                    Button(action: {
                        isEditing.toggle()
                        isTextEditorFocused = isEditing ? true : false
                    }) {
                        Text(isEditing ? "完了" : "編集")
                    }
                }
            }
        }
    }
}

struct DocEditView_Previews: PreviewProvider {
    static var previews: some View {
        DocEditView(fileName: "example.txt", rawText: "こんにちは=hello\nお元気ですか=How are you")
    }
}
