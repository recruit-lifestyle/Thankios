//
//  main.swift
//  Thankios
//
//  Created by Yuki Nagai on 3/20/16.
//  Copyright © 2016 Recruit Lifestyle Co., Ltd. All rights reserved.
//

import ThankiosKit

func main(arguments: [String]) {
    let input = InputForm(arguments)
    Project().collect().write(input.path)
}
main(Process.arguments)
