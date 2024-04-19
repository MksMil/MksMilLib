//
//  Concavable.swift
//  ViewsSamples
//
//  Created by Миляев Максим on 19.04.2024.
//

import SwiftUI

@available(iOS 15.0, *)
public struct Concavable: ViewModifier{
    
    public let cornerRadius : Double
    public var mainColor: Color = .gray
    public var isSelected: Bool = false
    
    public func body(content: Content) -> some View {
        content
            .scaleEffect(isSelected ? 0.98: 1)
            .background {
                if isSelected {
                    ZStack {
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .fill(mainColor)
                        
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(.black, lineWidth: 2)
                            .blur(radius: 1)
                            .opacity(0.1)
                            .offset(x: 1, y: 1)
                            .mask(RoundedRectangle(cornerRadius: cornerRadius)
                                .fill(LinearGradient(colors:[.white, Color.clear],
                                                     startPoint: .top,
                                                     endPoint: .bottom)))
                        
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(.black, lineWidth: 6)
                            .blur(radius: 3)
                            .opacity(0.1)
                            .offset(x: 3, y: 3)
                            .mask(RoundedRectangle(cornerRadius: cornerRadius)
                                .fill(LinearGradient(colors: [.white, Color.clear],
                                                     startPoint: .top,
                                                     endPoint: .bottom)))
                        
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(.white, lineWidth: 2)
                            .blur(radius: 0.5)
                            .opacity(0.3)
                            .offset(x: -1, y: -1)
                            .mask(RoundedRectangle(cornerRadius: cornerRadius)
                                .fill(LinearGradient(colors: [Color.clear, .white],
                                                     startPoint: .top,
                                                     endPoint: .bottom)))
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(.white, lineWidth: 6)
                            .blur(radius: 3)
                            .opacity(0.3)
                            .offset(x: -3, y: -3)
                            .mask(RoundedRectangle(cornerRadius: cornerRadius)
                                .fill(LinearGradient(colors: [Color.clear, .white],
                                                     startPoint: .top,
                                                     endPoint: .bottom)))
                                        
                    }
                } else {
                    ZStack {
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .fill(mainColor)
                        
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(.black, lineWidth: 2)
                            .blur(radius: 1)
                            .opacity(0.1)
                            .offset(x: -1, y: -1)
                            .mask(RoundedRectangle(cornerRadius: cornerRadius)
                                .fill(LinearGradient(colors:[.white, Color.clear],
                                                     startPoint: .bottom,
                                                     endPoint: .top)))
                        
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(.black, lineWidth: 6)
                            .blur(radius: 3)
                            .opacity(0.1)
                            .offset(x: -3, y: -3)
                            .mask(RoundedRectangle(cornerRadius: cornerRadius)
                                .fill(LinearGradient(colors: [.white, Color.clear],
                                                     startPoint: .bottom,
                                                     endPoint: .top)))
                        
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(.white, lineWidth: 2)
                            .blur(radius: 0.5)
                            .opacity(0.3)
                            .offset(x: 1, y: 1)
                            .mask(RoundedRectangle(cornerRadius: cornerRadius)
                                .fill(LinearGradient(colors: [Color.clear, .white],
                                                     startPoint: .bottom,
                                                     endPoint: .top)))
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(.white, lineWidth: 6)
                            .blur(radius: 3)
                            .opacity(0.3)
                            .offset(x: 3, y: 3)
                            .mask(RoundedRectangle(cornerRadius: cornerRadius)
                                .fill(LinearGradient(colors: [Color.clear, .white],
                                                     startPoint: .bottom,
                                                     endPoint: .top)))
                                        
                    }
                }
            }
    }
}
