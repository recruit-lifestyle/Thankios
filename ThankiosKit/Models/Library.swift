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
    public let name:    String
    public let license: String
    
    public var itemFileName: String {
        return "ListItem\(name).plist"
    }
    
    public init(name: String, license: String) {
        self.name    = name
        self.license = license
    }
}
