//
//  LibraryModel.swift
//  Thankios
//
//  Created by Yuki Nagai on 3/21/16.
//  Copyright © 2016 Yuki Nagai All rights reserved.
//

import FileKit

public struct LibraryModel {
    private let path:    String
    public  let name:    String
    public  let license: String
    
    public init(path: String) {
        self.path    = path
        self.name    = Path(path).fileName
        self.license = ""
    }
    
    private init(path: String, name: String, license: String) {
        self.path    = path
        self.name    = name
        self.license = license
    }
    
    public func extractLicense() -> LibraryModel {
        let licenseFileCandidates = Path(self.path)
            .find(searchDepth: 0) { $0.fileName.uppercaseString.containsString("LICENSE") }
        let license: String
        if let licenseFile = licenseFileCandidates.first {
            license = try! String(contentsOfPath: licenseFile)
                .stringByTrimmingCharactersInSet(.whitespaceAndNewlineCharacterSet())
        } else {
            // Check README?
            license = ""
        }
        return LibraryModel(path: self.path, name: self.name, license: license)
    }
}
