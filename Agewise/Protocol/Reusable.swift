//
//  Reusable.swift
//  Agewise
//
//  Created by 최대성 on 8/15/24.
//

import UIKit

protocol Identifier{
    static var identifier: String { get }
}

extension UICollectionViewCell: Identifier {
    static var identifier: String {
        return String(describing: self)
    }
}
extension UITableViewCell: Identifier {
    static var identifier: String {
        return String(describing: self)
    }
}
