//
//  CarthageManager.swift
//  Thankios
//
//  Created by Yuki Nagai on 3/21/16.
//  Copyright © 2016 Yuki Nagai All rights reserved.
//

import FileKit

public struct CarthageManager: ManagerProtocol {
    private let rootPath: String
    
    public var managing: Bool {
        let checkouts = Path(self.rootPath) + "Carthage/Checkouts"
        return checkouts.isDirectory
    }
    
    public init(rootPath: String) {
        self.rootPath = rootPath
    }
    
    public func collect() -> [Library] {
        let checkouts = Path(self.rootPath) + "Carthage/Checkouts"
        let candidates = checkouts.find(searchDepth: 0) { $0.isDirectory }
        return candidates.map { self.extract($0) }
    }
    
    private func extract(path: Path) -> Library {
        let name = path.fileName
        let candidates = path.find(searchDepth: 0) { $0.fileName.uppercaseString.containsString("LICENSE") }
        let license = candidates.flatMap { try? String(contentsOfPath: $0) }.first ?? ""
        let library = Library(name: name, license: license)
        return library
    }
}
