//
//  InputForm.swift
//  Thankios
//
//  Created by Yuki Nagai on 3/21/16.
//  Copyright © 2016 Yuki Nagai All rights reserved.
//

import PrettyColors

public struct InputForm {
    public let path: String
    
    public init(_ arguments: [String]) {
        let usage = Color.Wrap(foreground: .Green).wrap("USAGE: thankios <output directory>\n" + "on your project root")
        print(usage)
        let count = arguments.count
        self.path = count > 1 ? arguments[1] : "./"
    }
}
