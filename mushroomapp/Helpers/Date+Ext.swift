//
//  Date+Ext.swift
//  mushroomapp
//
//  Created by Tien Dung Vu on 13/9/25.
//

import Foundation
extension Date {
    func toDayString() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: self)
    }
}
