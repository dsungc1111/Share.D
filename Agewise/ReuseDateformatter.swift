//
//  ReuseDateformatter.swift
//  PiecePhoto
//
//  Created by 최대성 on 7/26/24.
//

import Foundation


final class ReuseDateformatter {
    
    static let shared = ReuseDateformatter()
    
    private init() {}
    
    static var dateFormatter: DateFormatter = {
          let formatter = DateFormatter()
          formatter.locale = Locale(identifier: "ko_KR")
          return formatter
      }()
    
    
    
    func getDateString(date: Date) -> String {
        Self.dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        return Self.dateFormatter.string(from: date)
    }
    func getDate(dateString: String) -> Date {
        Self.dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return Self.dateFormatter.date(from: dateString) ?? Date()
    }
    func changeStringForm(dateString: String) -> String {
        let changedDate = getDate(dateString: dateString)
        let changedStringForm = getDateString(date: changedDate)
        return changedStringForm
    }
}
