//
//  RecoveryManager.swift
//  rstorer
//
//  Created by bill donner on 8/28/23.
//

import Foundation
class RecoveryManager {
  
 static func downloadFile(from url: URL ) async throws -> Data {
    let (data, _) = try await URLSession.shared.data(from: url)
    return data
  }
    private static let structure1FileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("structure1.json")
    private static let structure2FileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("structure2.json")
    
    private static func saveStructure1(_ structure1: Structure1) throws {
        let encodedData = try JSONEncoder().encode(structure1)
        try encodedData.write(to: structure1FileURL)
    }
    
    private static func saveStructure2(_ structure2: Structure2) throws {
        let encodedData = try JSONEncoder().encode(structure2)
        try encodedData.write(to: structure2FileURL)
    }
    
    private static func restoreStructure1() throws -> Structure1 {
        let decodedData = try Data(contentsOf: structure1FileURL)
        return try JSONDecoder().decode(Structure1.self, from: decodedData)
    }
    
    private static func restoreStructure2() throws -> Structure2 {
        let decodedData = try Data(contentsOf: structure2FileURL)
        return try JSONDecoder().decode(Structure2.self, from: decodedData)
    }
    
  private static func initializeStructure1(id:String) {
        let newStructure1 = Structure1(id: id, data: "Initial data")
        try? saveStructure1(newStructure1)
    }
    
  private static func initializeStructure2(id:String) {
        let newStructure2 = Structure2(id: id, value: 0)
        try? saveStructure2(newStructure2)
    }
    
  public static func restoreOrInitializeStructures(id:String) throws -> (Structure1, Structure2) {
        if let restoredStructure1 = try? restoreStructure1(),
           let restoredStructure2 = try? restoreStructure2(),
           restoredStructure1.id == id ,
           restoredStructure2.id ==  id {
          print("****Successful restoration")
            return (restoredStructure1, restoredStructure2)
        } else {
          
          initializeStructure1(id:id)
          initializeStructure2(id: id)
          print("****Could not restore - initializing")
            return try (restoreStructure1(), restoreStructure2())
        }
    }
}


