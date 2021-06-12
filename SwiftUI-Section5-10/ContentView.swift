//
//  ContentView.swift
//  SwiftUI-Section5-10
//
//  Created by 萩倉丈 on 2021/06/12.
//

import SwiftUI

// P. 272

extension UIApplication {
    func endEditing() {
        // キーボードを下げるための処理
        sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil, from: nil, for: nil
        )
    }
}

// P. 274
func saveText(_ textData: String, _ fileName: String) {
    guard let url = docURL(fileName) else {
        return
    }
    
    do {
        let path = url.path
        try textData.write(toFile: path, atomically:true, encoding: .utf8)
    } catch let error as NSError {
        print(error)
    }
}

// P. 277
func loadText(_ fileName: String) -> String? {
    guard let url = docURL(fileName) else {
        return nil
    }
    do {
        let textData = try String(contentsOf: url, encoding: .utf8)
        return textData
    } catch {
        return nil
    }
}

// P. 275
func docURL(_ fileName: String) -> URL? {
    let fileManager = FileManager.default
    do {
        let docsUrl = try fileManager.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false)
        let url = docsUrl.appendingPathComponent(fileName)
        return url
    } catch {
        return nil
    }
}

struct ContentView: View {
    @State private var theText: String = ""
    
    var body: some View {
        NavigationView {
            TextEditor(text: $theText)
                .lineSpacing(10)
                .border(Color.gray)
                .padding([.leading, .bottom, .trailing])
                .navigationTitle("メモ")
                .toolbar {
                    // P. 276
                    ToolbarItem(placement:.navigationBarTrailing) {
                        Button {
                            if let data = loadText("sample.txt") {
                                theText = data
                            }
                        } label: {
                            Text("読み込み")
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            // キーボードを下げる処理
                            UIApplication.shared.endEditing()
                            saveText(theText, "sample.txt")
                        } label : {
                            Text("保存")
                        }
                    }
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
