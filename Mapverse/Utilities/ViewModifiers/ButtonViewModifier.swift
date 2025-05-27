//
//  ButtonViewModifier.swift
//  Mapverse
//
//  Created by Dave Paiva on 27/05/25.
//

import SwiftUI

struct ButtonViewModifier: ViewModifier {
    let isLoading: Bool
    
    init(isLoading: Bool = false){
        self.isLoading = isLoading
    }
    
    func body(content: Content) -> some View {
        Group {
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(0.8)
            } else {
                content
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(self.isLoading ? Color.blue.opacity(0.7) : Color.blue)
        .foregroundColor(.white)
        .cornerRadius(10)
        .disabled(self.isLoading)
        .animation(.easeInOut(duration: 0.2), value: self.isLoading)
    }
}

