//
//  ReadMeExtractor.swift
//  Thankios
//
//  Created by Yuki Nagai on 4/4/16.
//  Copyright © 2016 Recruit Lifestyle Co., Ltd. All rights reserved.
//

import FileKit

public struct ReadMeExtractor: ExtractorProtocol {
    private let path: String
    
    public init(path: String) {
        self.path = path
    }
    public func extract() -> String? {
        let candidates = Path(self.path)
            .find(searchDepth: 0) { $0.fileName.uppercaseString.containsString("README") }
        for candidate in candidates {
            guard let file = try? String(contentsOfPath: candidate) else {
                continue
            }
            // Prefix for license header (ex. ##)
            var prefix = ""
            // LICENSE lines
            var lines = [String]()
            for line in file.componentsSeparatedByCharactersInSet(.newlineCharacterSet()) {
                if line.hasSuffix("#") && line.uppercaseString.containsString("LICENSE") {
                    prefix = line.componentsSeparatedByCharactersInSet(.whitespaceCharacterSet()).first!
                }
                if !prefix.isEmpty {
                    if line.hasSuffix(prefix) {
                        break
                    }
                    lines.append(line)
                }
            }
            if !lines.isEmpty {
                return lines.joinWithSeparator("\n")
            }
        }
        return nil
    }
}
