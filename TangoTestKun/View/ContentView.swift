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
    @State private var isCheckingAnswers = false
    @State private var isShowingAlert = false
    @State private var isShowingFileEditView = false
    @State private var isShowingNewFileEditView = false

    var body: some View {
        VStack {
            HStack(spacing: 2) {
                titleText
                Spacer()
                shuffleButton
                showAnswersToggle
                importTangoFileButton
                editExistingFileButton
                    .sheet(
                        isPresented: $isShowingFileEditView,
                        content: {
                            FileEditView(tangoData: nowEditingFile)
                        }
                    )
                createNewFileButton
                    .sheet(
                        isPresented: $isShowingNewFileEditView,
                        content: {
                            FileEditView()
                        }
                    )
            }
            .padding(.horizontal, 18)
            TabView {
                TabContentView(
                    tangoData: nowEditingFile.tangoData,
                    isCheckingAnswers: isCheckingAnswers,
                    testType: .jp
                )
                .tabItem {
                    Image(systemName: "j.circle.fill")
                    Text("日本語")
                }
                TabContentView(
                    tangoData: nowEditingFile.tangoData,
                    isCheckingAnswers: isCheckingAnswers,
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

    var shuffleButton: some View {
        Button(action: {
            nowEditingFile.tangoData.shuffle()
        }) {
            Image(systemName: "shuffle")
        }
    }

    var showAnswersToggle: some View {
        Toggle(isOn: $isCheckingAnswers) {
            Image(systemName: isCheckingAnswers ? "pencil" : "pencil.slash")
        }
        .toggleStyle(.button)
    }

    var importTangoFileButton: some View {
        Button(action: {
            isImporting = true
        }) {
            Image(systemName: "folder")
        }
    }

    var editExistingFileButton: some View {
        Button(action: {
            isShowingFileEditView = true
        }) {
            Image(systemName: "doc.text")
        }
    }

    var createNewFileButton: some View {
        Button(action: {
            isShowingNewFileEditView = true
        }) {
            Image(systemName: "plus")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
