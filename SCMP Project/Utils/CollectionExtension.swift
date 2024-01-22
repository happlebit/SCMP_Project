//
//  CollectionExtension.swift
//  SCMP Project
//
//  Created by Anson Wong on 22/1/2024.
//

import Foundation

extension Collection where Indices.Iterator.Element == Index {
    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
