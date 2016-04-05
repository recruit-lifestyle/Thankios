//
//  Library.swift
//  Thankios
//
//  Created by Yuki Nagai on 4/4/16.
//  Copyright © 2016 Recruit Lifestyle Co., Ltd. All rights reserved.
//

import FileKit
import PrettyColors

public struct Library {
    private let path:    String
    public  let name:    String
    public  let license: String
    
    public var itemFileName: String {
        return "ListItem\(name).plist"
    }
    
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
    
    public func extractLicense() -> Library? {
        var information = Color.Wrap(foreground: .Blue).wrap(self.name) + ": "
        defer { print(information) }
        let extractors: [ExtractorProtocol] = [
            LicenseFileExtractor(path: self.path),
            ReadMeExtractor(path: self.path)
        ]
        for extractor in extractors {
            guard let license = extractor.extract() else {
                continue
            }
            information += "License found."
            return Library(path: self.path, name: self.name, license: license)
        }
        information += Color.Wrap(foreground: .Red).wrap("License not found.")
        return nil
    }
}
