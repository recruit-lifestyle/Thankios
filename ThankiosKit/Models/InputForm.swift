//
//  InputForm.swift
//  Thankios
//
//  Created by Yuki Nagai on 3/21/16.
//  Copyright © 2016 Yuki Nagai All rights reserved.
//

import PrettyColors

public struct InputForm {
    public let rootPath:   String
    public let destPath: String
    
    public init(_ arguments: [String]) {
        let usage = Color.Wrap(foreground: .Green).wrap("USAGE: thankios <project root directory> <output directory>")
        print(usage)
        let count = arguments.count
        self.rootPath = count > 1 ? arguments[1] : "./"
        self.destPath = count > 2 ? arguments[2] : "./"
    }
}
