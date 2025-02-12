//
//  Date+Extension.swift
//  Pillinko
//

import Foundation

extension Date {
    func formattedUSLocaleTime() -> String {
        self.formatted(.dateTime.hour().minute().locale(Locale(identifier: "en_US")))
    }
}

extension Calendar {
    func endOfDay(for date: Date) -> Date {
        let startOfDay = self.startOfDay(for: date)
        return self.date(byAdding: DateComponents(day: 1, second: -1), to: startOfDay) ?? startOfDay
    }
}
