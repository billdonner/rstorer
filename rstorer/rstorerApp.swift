//
//  rstorerApp.swift
//  rstorer
//
//  Created by bill donner on 8/26/23.
//

import SwiftUI

// Example usage:
func test(id:String){
  do{
    let (structure1, structure2) = try RecoveryManager.restoreOrInitializeStructures(id: id)
    print(structure1)
    print(structure2)
  } catch {
    print("Error: \(error)")
  }

}

@main
struct rstorerApp: App {
    var body: some Scene {
        WindowGroup {
          
            ContentView()
        }
    }
}
