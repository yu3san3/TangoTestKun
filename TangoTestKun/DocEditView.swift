//
//  DocEditView.swift
//  TangoTestKun
//
//  Created by 丹羽雄一朗 on 2023/06/25.
//

import SwiftUI

struct DocEditView: View {
    let fileOperator = FileOperator()

    let fileURL: URL
    @State var rawText: String

    @FocusState private var isEditing: Bool

    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            TextEditor(text: $rawText)
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
            .navigationTitle(fileURL.lastPathComponent) //ファイル名を取得
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
                        fileOperator.writeFile(atPath: fileURL, content: rawText)
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
        DocEditView(fileURL: mockURL, rawText: "こんにちは=hello\nお元気ですか=How are you")
    }
}
