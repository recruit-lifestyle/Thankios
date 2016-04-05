//
//  LicenseFileExtractor.swift
//  Thankios
//
//  Created by Yuki Nagai on 4/4/16.
//  Copyright © 2016 Recruit Lifestyle Co., Ltd. All rights reserved.
//

import FileKit

public struct LicenseFileExtractor: ExtractorProtocol {
    private let path: String
    
    public init(path: String) {
        self.path = path
    }
    public func extract() -> String? {
        let candidates = Path(self.path)
            .find(searchDepth: 0) { $0.fileName.uppercaseString.containsString("LICENSE") }
        for candidate in candidates {
            if let license = try? String(contentsOfPath: candidate) {
                return license
            }
        }
        return nil
    }
}
