//
//  ContentView.swift
//  TangoTestKun
//
//  Created by 丹羽雄一朗 on 2023/02/12.
//

import SwiftUI

let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
let appBuildNum = Bundle.main.infoDictionary!["CFBundleVersion"] as! String

struct ContentView: View {

    @StateObject var nowEditingFile = TangoData(
        tangoData: [],
        fileURL: TangoData.mockURL,
        rawText: "ファイルが選ばれていません"
    )
    
    @State private var isImporting = false
    @State private var isShowingAlert = false
    @State private var isShowingExistingFileEditView = false
    @State private var isShowingNewFileEditView = false

    var body: some View {
        VStack {
            header
            TabView {
                TangoTestView(
                    tangoData: $nowEditingFile.tangoData,
                    testType: .jp
                )
                .tabItem {
                    Image(systemName: "j.circle.fill")
                    Text("日本語")
                }
                TangoTestView(
                    tangoData: $nowEditingFile.tangoData,
                    testType: .en
                )
                .tabItem {
                    Image(systemName: "e.circle.fill")
                    Text("英語")
                }
            }
        }
        .onAppear {
            let fileOperator = FileOperator()
            fileOperator.createExampleFile()
        }
        .fileImporter(
            isPresented: $isImporting,
            allowedContentTypes: [.plainText],
            allowsMultipleSelection: false
        ) { result in
            do {
                guard let selectedFileURL: URL = try result.get().first else {
                    return
                }
                guard selectedFileURL.startAccessingSecurityScopedResource() else {
                    return
                }
                try setNowEditingFile(from: selectedFileURL)
                selectedFileURL.stopAccessingSecurityScopedResource()
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    private func setNowEditingFile(from selectedFileURL: URL) throws {
        nowEditingFile.fileURL = selectedFileURL
        nowEditingFile.rawText = try String(contentsOf: selectedFileURL)
        nowEditingFile.tangoData = TangoParser.parse(nowEditingFile.rawText)
    }
}

private extension ContentView {
    var header: some View {
        HStack {
            titleText
            Spacer()
            fileMenu
            .sheet(
                isPresented: $isShowingExistingFileEditView,
                content: {
                    FileEditView(tangoData: nowEditingFile)
                }
            )
            .sheet(
                isPresented: $isShowingNewFileEditView,
                content: {
                    FileEditView()
                }
            )
        }
        .padding(.horizontal, 18)
    }

    var titleText: some View {
        Text("単語テストくん")
            .bold()
            .onTapGesture {
                isShowingAlert = true
            }
            .alert(isPresented: $isShowingAlert) {
                Alert(
                    title: Text("単語テストくん"),
                    message: Text("\(appVersion)(\(appBuildNum))")
                )
            }
    }

    var fileMenu: some View {
        Menu {
            importTangoFileButton
            if !nowEditingFile.tangoData.isEmpty {
                editExistingFileButton
            }
            createNewFileButton
        } label: {
            Label("フォルダ", systemImage: "folder")
                .labelStyle(.iconOnly)
        }
    }

    var importTangoFileButton: some View {
        Button(action: {
            isImporting = true
        }) {
            Label("読み込み", systemImage: "arrow.down.doc")
        }
    }

    var editExistingFileButton: some View {
        Button(action: {
            isShowingExistingFileEditView = true
        }) {
            Label("編集", systemImage: "pencil")
        }
    }

    var createNewFileButton: some View {
        Button(action: {
            isShowingNewFileEditView = true
        }) {
            Label("新規作成", systemImage: "plus")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
