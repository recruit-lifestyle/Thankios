//
//  ExtractorProtocol.swift
//  Thankios
//
//  Created by Yuki Nagai on 4/4/16.
//  Copyright © 2016 Recruit Lifestyle Co., Ltd. All rights reserved.
//

public protocol ExtractorProtocol {
    init(path: String)
    func extract() -> String?
}
