//
//  Project.swift
//  Thankios
//
//  Created by Yuki Nagai on 4/4/16.
//  Copyright © 2016 Recruit Lifestyle Co., Ltd. All rights reserved.
//

import FileKit

public struct Project {
    public let libraries: [Library]
    
    private let candidates: [ManagerProtocol.Type] = [
        CocoaPodsManager.self,
        CarthageManager.self
    ]
    
    public init() {
        self.libraries = []
    }
    
    private init(libraries: [Library]) {
        self.libraries = libraries
    }
    
    public func collect() -> Project {
        let cwd = "./"
        let libraries = self.candidates
            .map     { $0.init(rootPath: cwd) }
            .filter  { $0.managing }
            .flatMap { $0.collect() }
        libraries.forEach { $0.printResult() }
        return Project(libraries: libraries)
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
        let file = Path(destination) + "Acknowledgements.plist"
        try! contents.writeToPath(file)
    }
}
