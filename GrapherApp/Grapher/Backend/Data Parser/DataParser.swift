//
//  DataParser.swift
//  Grapher
//
//  Created by Charlie While on 28/10/2020.
//

import Foundation

class DataParser {
    static let shared = DataParser()
    
    var data = [String : [[String : Any]]]()
    
    public func getEntriesFromLog() {
        self.data.removeAll()
            
        let dict = NSDictionary(contentsOfFile: "/var/mobile/Library/Preferences/com.charliewhile.grapher.plist")
        if dict == nil { return }
        let data = dict!["log"] as? [String : [[String : Any]]] ?? [String : [[String : Any]]]()
        self.data = data
    }
    
    public func purge(_ all: Bool, _ key: String = "") {
        let dict = NSDictionary(contentsOfFile: "/var/mobile/Library/Preferences/com.charliewhile.grapher.plist")
        if dict == nil { return }
        var fuckyDict = dict as! [String : Any]
        
        if all {
            fuckyDict["log"] = [String : [[String : Any]]]()
        } else {
            var data = fuckyDict["log"] as? [String : [[String : Any]]] ?? [String : [[String : Any]]]()
            data[key] = [[String : Any]]()
            fuckyDict["log"] = data
        }
                
        (fuckyDict as NSDictionary).write(toFile: "/var/mobile/Library/Preferences/com.charliewhile.grapher.plist", atomically: true)
        self.getEntriesFromLog()
    }
}
