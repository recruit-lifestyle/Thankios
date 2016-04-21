//
//  CocoaPodsManager.swift
//  Thankios
//
//  Created by Yuki Nagai on 3/21/16.
//  Copyright © 2016 Yuki Nagai All rights reserved.
//

import FileKit

public struct CocoaPodsManager: ManagerProtocol {
    private let rootPath: String
    private typealias Specifier = [String: String]
    
    public var managing: Bool {
        let pods = Path(self.rootPath) + "Pods"
        return pods.isDirectory
    }
    
    public init(rootPath: String) {
        self.rootPath = rootPath
    }
    
    public func collect() -> [Library] {
        let filePath = (Path(self.rootPath) + "Pods/Target Support Files")
            .find(searchDepth: 0) { $0.fileName.hasPrefix("Pods-") }.first!
            + "Pods-Example-acknowledgements.plist"
        let contents = try! NSDictionary(contentsOfPath: filePath)
        let specifiers = contents["PreferenceSpecifiers"] as! [Specifier]
        return specifiers.flatMap { self.extract($0) }
    }
    
    private func extract(specifier: Specifier) -> Library? {
        let title      = specifier["Title"]!
        let footerText = specifier["FooterText"]!
        guard !["Acknowledgements", ""].contains(title) else {
            return nil
        }
        return Library(name: title, license: footerText)
    }
}
