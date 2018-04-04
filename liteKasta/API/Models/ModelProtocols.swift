//
//  ModelProtocols.swift
//  ikasta
//
//  Created by Zoreslav Khimich on 2/6/18.
//  Copyright © 2018 modnakasta. All rights reserved.
//

import Foundation

protocol TimeFramed {
    var startsAt: Date { get }
    var finishesAt: Date { get }
}

extension Array where Element: TimeFramed {
    func filterActive(for date: Date) -> ([Element], Date) {
        var validUntil = Date.distantFuture
        var active = [Element]()
        for aModel in self {
            assert(aModel.startsAt < aModel.finishesAt)
            // Закончилась в прошлом
            if aModel.finishesAt <= date {
                continue;
            }
            // Начнется и закончится в будущем
            else if aModel.startsAt > date {
                validUntil = Swift.min(validUntil, aModel.startsAt)
            }
            // Уже началась и еще не закончилась
            else {
                validUntil = Swift.min(validUntil, aModel.finishesAt)
                active.append(aModel)
            }
        }
        return (active, validUntil)
    }
}

protocol Tagged {
    var tags: String { get }
}

extension Array where Element: Tagged {
    func filterTagged(with targetTags:Set<Character>) -> [Element] {
        if targetTags.isEmpty {
            return self
        }
        return self.filter() { !Set($0.tags).isDisjoint(with: targetTags) }
    }
}
