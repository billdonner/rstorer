//
//  ContentView.swift
//  rstorer
//
//  Created by bill donner on 8/26/23.
//

import SwiftUI
import q20kshare

let PRIMARY_REMOTE = URL(string:"https://billdonner.com/fs/gd/readyforios01.json")!
let SECONDARY_REMOTE = URL(string:"https://billdonner.com/fs/gd/readyforios02.json")!
let TERTIARY_REMOTE = URL(string:"https://billdonner.com/fs/gd/readyforios03.json")!



let CHOSEN_REMOTE = SECONDARY_REMOTE

struct ContentView: View {
  @State var isDownloading = false
  @State var foo:AppState = .init(id:UUID().uuidString, value: 1)
  
  var body: some View {
    VStack {
      Text(foo.id)
      Image(systemName: "globe")
        .imageScale(.large)
        .foregroundStyle(.tint)
      ProgressView("Downloading...").opacity(isDownloading ? 1.0:0.0)
      Button {
        Task { isDownloading = true
          foo = try! await RecoveryManager.rstore(CHOSEN_REMOTE)
          isDownloading = false }
      }
    label: {Text("Reload")}
    }
    .padding()
    .task {
      isDownloading = true
      foo = try! await RecoveryManager.rstore(CHOSEN_REMOTE)
      isDownloading = false
    }
  }
}

#Preview {
  ContentView()
}



