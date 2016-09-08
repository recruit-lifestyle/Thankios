//
//  ThankiosKit.swift
//  Thankios
//
//  Created by Yuki Nagai on 7/28/16.
//  Copyright © 2016 Recruit Lifestyle Co., Ltd. All rights reserved.
//

import Foundation
import FileKit

public struct ThankiosKit {
    let arguments: [String]
    
    public init(_ arguments: [String]) {
        guard arguments.count == 3 else {
            let message = "[Usage] thankios <input directory> <output directory>"
            fatalError(message)
        }
        self.arguments = arguments
    }
    
    public func generate() {
        print("**Generate License**")
        let files = Path(self.arguments[1]).find { $0.pathExtension == "txt" }
        files.forEach { print("-> " + $0.fileName) }
        let specifiers = files.map { path in
            [
                "FooterText": try! String(contentsOfPath: path),
                "Title": (path.fileName as NSString).deletingPathExtension,
                "Type": "PSGroupSpecifier"
            ]
        }
        let title = "Acknowledgements"
        let contents = [
            "PreferenceSpecifiers": specifiers,
            "StringsTable": title,
            "Title": title
        ] as [String : Any]
        let destination = Path(self.arguments[2]) + "\(title).plist"
        try! (contents as NSDictionary).writeToPath(destination)
    }
}
