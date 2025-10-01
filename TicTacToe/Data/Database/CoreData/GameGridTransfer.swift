//
//  GameGridTransfer.swift
//  TicTacToe

import Foundation
import CoreData

extension GameEntity {
    var gridArray: [[Int]] {
        get {
            if let arr = self.grid as? [[Int]] { return arr }

            if let nsarr = self.grid {
                var result = [[Int]]()
                for rowAny in nsarr {
                    guard let row = rowAny as? NSArray else { continue }
                    let intRow = row.compactMap { element -> Int? in
                        if let n = element as? NSNumber { return n.intValue }
                        if let s = element as? String, let v = Int(s) { return v }
                        return nil
                    }
                    result.append(intRow)
                }
                return result
            }

            return Array(repeating: Array(repeating: 0, count: 3), count: 3)
        }
        set {
            self.grid = newValue as NSArray
        }
    }
}

