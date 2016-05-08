//
//  ManagerProtocol.swift
//  Thankios
//
//  Created by Yuki Nagai on 3/21/16.
//  Copyright © 2016 Recruit Lifestyle Co., Ltd. All rights reserved.
//

public protocol ManagerProtocol {
    var managing: Bool { get }
    init(rootPath: String)
    func collect() -> [Library]
}
