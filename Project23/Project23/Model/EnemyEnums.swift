//
//  createEnemy.swift
//  Project23
//
//  Created by Alexander Ha on 11/4/20.
//

import UIKit

enum SequenceType: CaseIterable {
    case oneNoBomb, one, twoWithBomb, two, three, four, chain, fastChain
}


enum ForceBomb {
    case never, always, random
}
