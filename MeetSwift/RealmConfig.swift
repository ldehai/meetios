//
//  RealmConfig.swift
//  MeetSwift
//
//  Created by andy on 9/11/16.
//  Copyright © 2016 AventLabs. All rights reserved.
//

import Foundation
import RealmSwift

public func realmConfig() -> Realm.Configuration {
    
    // 默认将 Realm 放在 App Group 里
    
    let directory: URL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.aventlabs")!
    let realmFileURL = directory.appendingPathComponent("db.realm")
    
    var config = Realm.Configuration()
    config.fileURL = realmFileURL
    config.schemaVersion = 1
    config.migrationBlock = { migration, oldSchemaVersion in
    }
    
    return config
}
