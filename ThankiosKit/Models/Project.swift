//
//  Project.swift
//  Thankios
//
//  Created by Yuki Nagai on 4/4/16.
//  Copyright © 2016 Recruit Lifestyle Co., Ltd. All rights reserved.
//

import FileKit

public struct Project {
    public let path: String
    public let libraries: [Library]
    
    private let candidates: [ManagerProtocol.Type] = [
        CocoaPodsManager.self,
        CarthageManager.self
    ]
    
    public init(path: String) {
        self.path = path
        self.libraries = []
    }
    
    private init(path: String, libraries: [Library]) {
        self.path = path
        self.libraries = libraries
    }
    
    public func collect() -> Project {
        let libraries = self.candidates
            .map     { $0.init(path: self.path) }
            .filter  { $0.managing }
            .flatMap { $0.collect() }
            .flatMap { $0.extractLicense() }
        return Project(path: self.path, libraries: libraries)
    }
    
    public func write(destination: String) {
        let specifies = self.libraries.map { library in
            return [
                "FooterText": library.license,
                "Title": library.name,
                "Type": "PSGroupSpecifier",
            ]
        }
        let contents = [
            "PreferenceSpecifiers": specifies,
            "StringsTable": "Acknowledgements",
            "Title": "Acknowledgements",
            ]
        let file = Path(destination) + "LisenceList.plist"
        try! contents.writeToPath(file)
    }
}
