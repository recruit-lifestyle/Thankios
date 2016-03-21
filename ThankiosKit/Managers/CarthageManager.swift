//
//  CarthageManager.swift
//  Thankios
//
//  Created by Yuki Nagai on 3/21/16.
//  Copyright © 2016 Yuki Nagai All rights reserved.
//

import FileKit

public struct CarthageManager: ManagerProtocol {
    private let path: String
    
    public var managing: Bool {
        let checkouts = Path(self.path) + "Carthage/Checkouts"
        return checkouts.isDirectory
    }
    
    public init(path: String) {
        self.path = path
    }
    
    public func collect() -> [LibraryModel] {
        let checkouts = Path(self.path) + "Carthage/Checkouts"
        return checkouts.find(searchDepth: 0) { $0.isDirectory }.map { LibraryModel(path: $0.rawValue) }
    }
}
