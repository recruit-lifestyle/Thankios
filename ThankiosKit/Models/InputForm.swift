//
//  InputForm.swift
//  Thankios
//
//  Created by Yuki Nagai on 3/21/16.
//  Copyright © 2016 Yuki Nagai All rights reserved.
//

import Foundation

public struct InputForm {
    public let rootPath:   String
    public let destPath: String
    
    public init(_ arguments: [String]) {
        let count = arguments.count
        self.rootPath = count > 1 ? arguments[1] : "./"
        self.destPath = count > 2 ? arguments[2] : "./"
    }
}
