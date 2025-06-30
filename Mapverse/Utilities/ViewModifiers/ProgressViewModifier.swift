//
//  ProgressView.swift
//  Mapverse
//
//  Created by Dave Paiva on 30/06/25.
//

import SwiftUI

struct ProgressViewModifier: ViewModifier {
    var color: Color
    var size: CGFloat
    
    init(color: Color = .white, size: CGFloat = 0.8){
        self.color = color
        self.size = size
    }
    
    func body(content: Content) -> some View {
        content
            .progressViewStyle(CircularProgressViewStyle(tint: color))
            .scaleEffect(size)
    }
        
}

#Preview {
    VStack(spacing: 20) {
        ProgressView()
            .modifier(ProgressViewModifier(color: .black))
        
        ProgressView()
            .modifier(ProgressViewModifier(color: .blue, size: 1.2))
        
        ProgressView()
            .modifier(ProgressViewModifier(color: .red, size: 0.5))
    }
}
