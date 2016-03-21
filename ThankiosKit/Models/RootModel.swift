//
//  RootModel.swift
//  Thankios
//
//  Created by Yuki Nagai on 3/21/16.
//  Copyright © 2016 Yuki Nagai All rights reserved.
//

import FileKit

public struct RootModel {
    public let path: String
    public let libraries: [LibraryModel]
    
    private let candidates: [ManagerProtocol.Type] = [
        CocoaPodsManager.self,
        CarthageManager.self,
    ]
    
    public init(path: String) {
        self.path = path
        self.libraries = []
    }
    
    private init(path: String, libraries: [LibraryModel]) {
        self.path = path
        self.libraries = libraries
    }
    
    public func collect() -> RootModel {
        let libraries = self.candidates
            .map     { $0.init(path: self.path) }
            .filter  { $0.managing }
            .flatMap { $0.collect() }
            .map     { $0.extractLicense() }
        return RootModel(path: self.path, libraries: libraries)
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
