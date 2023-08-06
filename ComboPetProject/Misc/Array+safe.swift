//
//  Array+safe.swift
//  ComboPetProject
//
//  Created by Andrew K on 8/6/23.
//

import Foundation

extension Array {
    mutating func safeRemove(at index: Int) {
        guard index >= 0 && index < count else { return }
        remove(at: index)
    }
    func safeItem(at index: Int) -> Element? {
        guard index >= 0 && index < count else {
            return nil
        }
        return self[index]
    }
    mutating func safeInsert(item: Element, at index: Int) {
        var ind = index
        if index < 0 {
            ind = 0
        } else if index > count {
            ind = Swift.max(count - 1, 0)
        }
        if ind == count {
            append(item)
        } else {
            insert(item, at: ind)
        }
    }
}
