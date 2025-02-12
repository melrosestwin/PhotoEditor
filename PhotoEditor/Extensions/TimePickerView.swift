//
//  TimePickerView.swift
//  Pillinko
//

import SwiftUI

struct TimePickerView: View {
    
    @Environment(\.dismiss) var dismiss
    @State var time: Date
    
    var completion: (Date) -> Void

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button("Cancel") {
                    dismiss()
                }
                
                Spacer()
                
                Button("Done") {
                    completion(time)
                    dismiss()
                }
            }
            .padding(.all, 16.flexible())
            
            Spacer(minLength: 0)
            
            DatePicker("Select Time", selection: $time, displayedComponents: .hourAndMinute)
                .labelsHidden()
                .datePickerStyle(.wheel)
            
            Spacer(minLength: 0)
        }
        .background(.brandPurple)
        .ignoresSafeArea(edges: .bottom)
    }
}
