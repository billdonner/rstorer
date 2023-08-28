//
//  RecoveryManager.swift
//  rstorer
//
//  Created by bill donner on 8/28/23.
//

import Foundation
import q20kshare

struct PlayData: Codable {
  var id: String
  var data: [GameData]
}

struct AppState: Codable {
  var id: String
  var value: Int
}
class RecoveryManager {
  
 static func downloadFile(from url: URL ) async throws -> Data {
    let (data, _) = try await URLSession.shared.data(from: url)
    return data
  }
    private static let structure1FileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("structure1.json")
    private static let appstateFileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("appstate.json")
    
  static func savePlayData(_ structure1: PlayData) throws {
        let encodedData = try JSONEncoder().encode(structure1)
        try encodedData.write(to: structure1FileURL)
    }
    
   static func saveAppState(_ appstate: AppState) throws {
        let encodedData = try JSONEncoder().encode(appstate)
        try encodedData.write(to: appstateFileURL)
    }
    
   static func restorePlayData() throws -> PlayData {
        let decodedData = try Data(contentsOf: structure1FileURL)
        return try JSONDecoder().decode(PlayData.self, from: decodedData)
    }
    
  static func restoreAppState() throws -> AppState {
        let decodedData = try Data(contentsOf: appstateFileURL)
        return try JSONDecoder().decode(AppState.self, from: decodedData)
    }
    
  static func initializePlayData(id:String,data:[GameData]) {
        let newPlayData = PlayData(id: id, data: data)
        try? savePlayData(newPlayData)
    }
    
 static func initializeAppState(id:String) {
        let newAppState = AppState(id: id, value: 0)
        try? saveAppState(newAppState)
    }
    
  public static func restoreOrInitializeStructures(id:String,data:[GameData]) throws -> (PlayData, AppState) {
        if let restoredPlayData = try? restorePlayData(),
           let restoredAppState = try? restoreAppState(),
           restoredPlayData.id == id ,
           restoredAppState.id ==  id {
          print("****Successful restoration")
            return (restoredPlayData, restoredAppState)
        } else {
          
          initializePlayData(id:id,data:data)
          initializeAppState(id: id)
          print("****Could not restore - initializing")
            return try (restorePlayData(), restoreAppState())
        }
    }
  
  
 static func rstore(_ url:URL) async throws -> AppState  {
    
    //1. get remote data, decode, and get id of Downloaded game data
    let start_time = Date()
    let tada = try await  RecoveryManager.downloadFile(from:url)
    let gd =   try JSONDecoder().decode([GameData].self,from:tada)
    let elapsed = Date().timeIntervalSince(start_time)
    let id = gd[0].id // not what we want
    print("Downloaded \(id) in \(elapsed) secs")
    //2. try to restore both structures, otherwise initilize them
    // let (structure1, appstate) = try RecoveryManager.restoreOrInitializeStructures(id: id)
    
    let appstate = try? RecoveryManager.restoreAppState()
    if let appstate = appstate{
      if appstate.id == id {
        // all good
        print ("Restored app state")
        return appstate
      }
      else {
        // must be new download
        print("New download - must initialize app state")
        // the download has a different id, so reset all state
        RecoveryManager.initializePlayData(id: id,data:gd)
        RecoveryManager.initializeAppState(id: id )
        return try RecoveryManager.restoreAppState()
      }
    }
    else {
      print("Could not restore app state")
      // the download has a different id, so reset all state
      RecoveryManager.initializeAppState(id: id )
      return try RecoveryManager.restoreAppState()
    }
  }
}


