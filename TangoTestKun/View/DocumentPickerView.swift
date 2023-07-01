//
//  DocumentPickerView.swift
//  TangoTestKun
//
//  Created by 丹羽雄一朗 on 2023/07/01.
//

import SwiftUI
import UniformTypeIdentifiers

struct DocumentPickerView : UIViewControllerRepresentable {
    var onCompletion: (URL) -> Void

    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var parent: DocumentPickerView

        init(_ parent: DocumentPickerView) {
            self.parent = parent
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
            self.parent.onCompletion(url)
        }
    }

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let documentPickerViewController =  UIDocumentPickerViewController(
            forOpeningContentTypes: [UTType.text]
        )
        documentPickerViewController.delegate = context.coordinator
        documentPickerViewController.directoryURL = FileOperator.iCloudRootDirectory
        return documentPickerViewController
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}

extension View {
    func documentPicker(isPresented: Binding<Bool>, onCompletion: @escaping (URL) -> Void) -> some View {
        self.modifier(DocumentPickerModifier(isPresented: isPresented, onCompletion: onCompletion))
    }
}

struct DocumentPickerModifier: ViewModifier {
    @Binding var isPresented: Bool
    var onCompletion: (URL) -> Void

    func body(content: Content) -> some View {
        content
            .sheet(isPresented: $isPresented) {
                DocumentPickerView(onCompletion: onCompletion)
            }
    }
}

struct DocumentPickerView_Previews: PreviewProvider {
    static var previews: some View {
        DocumentPickerView() { url in
            print(url)
        }
    }
}
