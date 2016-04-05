//
//  ManagerProtocol.swift
//  Thankios
//
//  Created by Yuki Nagai on 3/21/16.
//  Copyright © 2016 Yuki Nagai All rights reserved.
//

public protocol ManagerProtocol {
    var managing: Bool { get }
    init(path: String)
    func collect() -> [Library]
}
