//
//  ButtonViewModifier.swift
//  Mapverse
//
//  Created by Dave Paiva on 27/05/25.
//

import SwiftUI

enum ButtonVariant {
    case primary
    case text
}

struct ButtonViewModifier: ViewModifier {
    let isLoading: Bool
    let variant: ButtonVariant
    
    init(isLoading: Bool = false, variant: ButtonVariant = .primary){
        self.isLoading = isLoading
        self.variant = variant
    }
    
    func body(content: Content) -> some View {
        Group {
            if isLoading {
                ProgressView()
                    .modifier(ProgressViewModifier())
            } else {
                content
            }
        }
        .frame(maxWidth: frameMaxWidth)
        .padding()
        .background(backgroundColor)
        .foregroundColor(foregroundColor)
        .cornerRadius(10)
        .disabled(self.isLoading)
        .animation(.easeInOut(duration: 0.2), value: self.isLoading)
        .fontWeight(fontWeight)
    }
    
    private var fontWeight: Font.Weight? {
        switch(variant){
        case .primary:
            return nil
        case .text:
            return .bold
        }
    }
    
    private var frameMaxWidth: CGFloat? {
        switch(variant){
        case .primary:
            return .infinity
        case .text:
            return nil
        }
    }
    
    private var backgroundColor: Color {
          switch true {
          case variant == .primary && isLoading:
              return Color.blue.opacity(0.7)
          case variant == .primary && !isLoading:
              return Color.blue
          case variant == .text:
              return Color.clear
         default:
              return Color.clear
          }
      }
      
      private var foregroundColor: Color {
          switch variant {
          case .primary:
              return .white
          case .text:
              return .blue
          }
      }
}

