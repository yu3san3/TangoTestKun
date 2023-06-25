//
//  ContentView.swift
//  TangoTestKun
//
//  Created by 丹羽雄一朗 on 2023/02/12.
//

import SwiftUI

//バージョン情報
let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
//ビルド情報
let appBuildNum = Bundle.main.infoDictionary!["CFBundleVersion"] as! String

struct ContentView: View {

    @StateObject var tangoModel = TangoModel()
    
    @State private var isImporting = false
    @State private var isCheckingAnswers = false
    @State private var isShowingAlert = false
    @State private var isShowingDocEditView = false
    
    var body: some View {
        VStack {
            HStack(spacing: 2) {
                titleText
                Spacer()
                shuffleButton
                showAnswersToggle
                importTangoFileButton
                Button(action: {
                    isShowingDocEditView = true
                }) {
                    Image(systemName: "doc.text")
                }
                .sheet(
                    isPresented: $isShowingDocEditView,
                    content: {
                        DocEditView(tangoModel: tangoModel)
                    }
                )
            }
            .padding(.horizontal, 18)
            TabView {
                TabContentView(
                    tangoData: tangoModel.tangoData,
                    isCheckingAnswers: isCheckingAnswers,
                    testType: .jp
                )
                .tabItem {
                    Image(systemName: "j.circle.fill")
                    Text("日本語")
                }
                TabContentView(
                    tangoData: tangoModel.tangoData,
                    isCheckingAnswers: isCheckingAnswers,
                    testType: .en
                )
                .tabItem {
                    Image(systemName: "e.circle.fill")
                    Text("英語")
                }
            }
        }
        .fileImporter(
            isPresented: $isImporting,
            allowedContentTypes: [.plainText],
            allowsMultipleSelection: false
        ) { result in
            if case .success = result {
                do {
                    let textURL: URL = try result.get().first!
                    if textURL.startAccessingSecurityScopedResource() {
                        tangoModel.fileURL = textURL
                        tangoModel.rawText = try String(contentsOf: textURL)
                        tangoModel.tangoData = TangoParser.parse(tangoModel.rawText)
                    }
                } catch {
                    let nsError = error as NSError
                    fatalError("File Import Error \(nsError), \(nsError.userInfo)")
                }
            } else {
                print("❌File Import Failed")
            }
        }
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
            tangoModel.tangoData.shuffle()
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
