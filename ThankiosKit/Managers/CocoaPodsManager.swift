//
//  CocoaPodsManager.swift
//  Thankios
//
//  Created by Yuki Nagai on 3/21/16.
//  Copyright © 2016 Yuki Nagai All rights reserved.
//

import FileKit

public struct CocoaPodsManager: ManagerProtocol {
    private let path: String
    
    public var managing: Bool {
        let pods = Path(self.path) + "Pods"
        return pods.isDirectory
    }
    
    public init(path: String) {
        self.path = path
    }
    
    public func collect() -> [Library] {
        let searchPath = Path(self.path) + "Pods"
        return searchPath.find(searchDepth: 0) { path in
            let contains = [
                "Headers",
                "Local Podspecs",
                "Pods.xcodeproj",
                "Target Support Files"
                ].contains(path.fileName)
            return path.isDirectory && !contains
            }.map { Library(path: $0.rawValue) }
    }
}
