//
//  main.swift
//  Thankios
//
//  Created by Yuki Nagai on 3/20/16.
//  Copyright © 2016 Yuki Nagai All rights reserved.
//

import Foundation
import ThankiosKit

func main(arguments: [String]) {
    let input = InputForm(arguments)
    RootModel(path: input.rootPath).collect().write(input.destPath)
}
main(Process.arguments)
