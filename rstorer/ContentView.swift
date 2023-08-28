//
//  ContentView.swift
//  rstorer
//
//  Created by bill donner on 8/26/23.
//

import SwiftUI
import q20kshare

let PRIMARY_REMOTE = "https://billdonner.com/fs/gd/readyforios01.json"
let SECONDARY_REMOTE = "https://billdonner.com/fs/gd/readyforios02.json"
let TERTIARY_REMOTE = "https://billdonner.com/fs/gd/readyforios03.json"


func rstore() async {
  do {
    
    //1. get remote data, decode, and get id of Downloaded game data
    let start_time = Date()
    let tada = try await  RecoveryManager.downloadFile(from:URL(string: PRIMARY_REMOTE)!)
    let gd =   try JSONDecoder().decode([GameData].self,from:tada)
    let elapsed = Date().timeIntervalSince(start_time)
    let id = gd[0].id // not what we want
    print("Downloaded \(id) in \(elapsed) secs")
    //2. try to restore both structures, otherwise initilize them
    let (structure1, structure2) = try RecoveryManager.restoreOrInitializeStructures(id: id)
    print(structure1)
    print(structure2)
  } catch {
    print("Error: \(error)")
  }
}



struct ContentView: View {
  @State var isDownloading = false
  var body: some View {
    VStack {
      Image(systemName: "globe")
        .imageScale(.large)
        .foregroundStyle(.tint)
      ProgressView("Downloading...").opacity(isDownloading ? 1.0:0.0)
      Button { Task { isDownloading = true
        await rstore()
        isDownloading = false }
      }
    
    label: {Text("Reload")}
    }
    .padding()
    .task {
      isDownloading = true
      await rstore()
      isDownloading = false
    }
  }
}

#Preview {
  ContentView()
}

struct Structure1: Codable {
  var id: String
  var data: String
}

struct Structure2: Codable {
  var id: String
  var value: Int
}

