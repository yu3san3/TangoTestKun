//
//  ContentView.swift
//  TangoTestKun
//
//  Created by 丹羽雄一朗 on 2023/02/12.
//

import SwiftUI

//バージョン情報
let globalVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
//ビルド情報
let globalBuildNum = Bundle.main.infoDictionary!["CFBundleVersion"] as! String

struct ContentView: View {
    
    @State private var tangoData: [TangoData] = []
    @State private var isImporting = false
    @State private var isCheckingAnswers = false
    @State private var isShowingAlert = false
    
    var body: some View {
        VStack {
            HStack(spacing: 2) {
                Text("単語テストくん")
                    .bold()
                    .onTapGesture {
                        isShowingAlert = true
                    }
                    .alert(isPresented: $isShowingAlert) {
                        Alert(
                            title: Text("単語テストくん"),
                            message: Text("\(globalVersion)(\(globalBuildNum))")
                        )
                    }
                Spacer()
                Button(action: {
                    tangoData.shuffle()
                }) {
                    Image(systemName: "shuffle")
                }
                Toggle(isOn: $isCheckingAnswers) {
                    Image(systemName: isCheckingAnswers ? "pencil" : "pencil.slash")
                }
                .toggleStyle(.button)
                Button(action: {
                    isImporting = true
                }) {
                    Image(systemName: "folder")
                }
            }
            .padding(.horizontal, 18)
            TabView {
                JpView(tangoData: tangoData, isCheckingAnswers: isCheckingAnswers)
                    .tabItem {
                        Image(systemName: "j.circle.fill")
                        Text("日本語")
                    }
                EnView(tangoData: tangoData, isCheckingAnswers: isCheckingAnswers)
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
                        let text = try String(contentsOf: textURL)
                        tangoData = Tango.parse(text)
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
}

struct JpView: View {
    let tangoData: [TangoData]
    let isCheckingAnswers: Bool
    
    var body: some View {
        if tangoData.isEmpty {
            Text("単語データが選択されていません。")
                .foregroundColor(.gray)
        } else {
            List(0..<tangoData.count, id: \.self) { index in
                HStack {
                    Image(systemName: "\(index+1).circle")
                    Text(tangoData[index].jp)
                    if isCheckingAnswers {
                        Spacer()
                        Text(tangoData[index].en)
                    }
                }
            }
            .listStyle(.plain)
        }
    }
}

struct EnView: View {
    let tangoData: [TangoData]
    let isCheckingAnswers: Bool
    
    var body: some View {
        if tangoData.isEmpty {
            Text("単語データが選択されていません。")
                .foregroundColor(.gray)
        } else {
            List(0..<tangoData.count, id: \.self) { index in
                HStack {
                    Image(systemName: "\(index+1).circle")
                    Text(tangoData[index].en)
                    if isCheckingAnswers {
                        Spacer()
                        Text(tangoData[index].jp)
                    }
                }
            }
            .listStyle(.plain)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
