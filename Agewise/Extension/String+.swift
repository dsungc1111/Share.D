//
//  String+.swift
//  Agewise
//
//  Created by 최대성 on 8/17/24.
//

import Foundation

extension String {
    var removeHtmlTag: String {
        guard let data = self.data(using: .utf8) else { return self }
        do {
            let attributedString = try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
            return attributedString.string
        } catch {
            return self
        }
    }
}
