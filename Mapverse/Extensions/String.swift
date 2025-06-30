//
//  String.swift
//  Mapverse
//
//  Created by Dave Paiva on 30/06/25.
//

import Foundation

extension String {
    func formatDateTimeString(currentFormat: String = "yyyy-MM-dd'T'HH:mm:ssZ", expectedFormat: String = "dd/MM/yyyy HH:mm:ss")  -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = currentFormat
        guard let date = dateFormatter.date(from: self) else {
            return self
        }
        dateFormatter.dateFormat = expectedFormat
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: date)
    }
}
