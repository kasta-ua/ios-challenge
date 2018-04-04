//
//  ViewControllerState.swift
//  liteKasta
//
//  Created by Zoreslav Khimich on 4/3/18.
//  Copyright © 2018 Markason LLC. All rights reserved.
//

import IGListKit

extension ViewController {
    enum State {
        case initialFetch
        case failure(error: Error)
        case success(items: [ListDiffable])
    }
}
