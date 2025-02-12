//
//  DatePickerView.swift
//  Pillinko
//

import SwiftUI

enum DatePickerComponent {
    case date
    case time
}

struct DatePickerView<Label: View>: View {
    
    @State private var popoverPresented: Bool = false
    
    @Binding var date: Date
    var minDate: Date = Calendar.current.date(from: DateComponents(year: 1920, month: 1, day: 1)) ?? Date()
    var maxDate: Date = Date.distantFuture
    var component: DatePickerComponent
    var arrowEdge: Edge = .bottom
    var label: (Date) -> Label

    var body: some View {
        label(date)
            .background(.black.opacity(0.001))
            .onTapGesture {
                UIApplication.shared.endEditing()
                popoverPresented = true
            }
            .popover(isPresented: $popoverPresented, attachmentAnchor: .point(.center), arrowEdge: arrowEdge) {
                switch component {
                case .date:
                    DatePickerContentView(date: $date, minDate: minDate, maxDate: maxDate)
                        .presentationCompactAdaptation(.popover)
                case .time:
                    TimePickerContentView(date: $date)
                        .presentationCompactAdaptation(.popover)
                }
            }
    }
}

struct DatePickerContentView: View {
    
    @Binding var date: Date
    var minDate: Date
    var maxDate: Date
    
    var body: some View {
        DatePicker("", selection: $date, in: minDate...maxDate, displayedComponents: .date)
            .labelsHidden()
            .datePickerStyle(.graphical)
            .frame(width: 320)
    }
}

struct TimePickerContentView: View {
    
    @Binding var date: Date
    
    var body: some View {
        VStack {
            DatePicker("", selection: $date, displayedComponents: .hourAndMinute)
                .labelsHidden()
                .datePickerStyle(.wheel)
                .frame(width: 180, height: 140)
                .padding()
        }
    }
}
