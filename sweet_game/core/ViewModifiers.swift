//
//  ViewModifiers.swift
//  sweet_game
//
//  Created by Yevhen Khyzhniak on 28.02.2024.
//

import Foundation
import SwiftUI

extension View {
    func removePredictiveSuggestions() -> some View {
        self.keyboardType(.namePhonePad)
            .autocorrectionDisabled(true)
    }
}

extension View {
    
    func appBackgroudColor(color: Color) -> some View {
        self.modifier(BackgroudColorModifier(color: color))
    }
    
    func standardPadding() -> some View {
        self.modifier(StandardPaddingModifier())
    }
    
    func standardHorizontalPadding() -> some View {
        self.modifier(StandardHorizontalPaddingModifier())
    }
    
    func standardVerticalPadding() -> some View {
        self.modifier(StandardVerticalPaddingModifier())
    }
    
    func physicalCardSize() -> some View {
        self.modifier(PhysicalCardSizeModifier())
    }
    
    func physicalCardHeight() -> some View {
        self.modifier(PhysicalCardHeightModifier())
    }
}

extension Button {
    func onTapEnded(_ action: @escaping () -> Void) -> some View {
        buttonStyle(ButtonPressHandler(action: action))
    }
}

struct BackgroudColorModifier: ViewModifier {
    
    init(color: Color) {
        self.color = color
    }
    
    private let color: Color
    
    func body(content: Content) -> some View {
        ZStack {
            self.color.ignoresSafeArea()
            content
        }
    }
}

struct StandardPaddingModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 22)
            .padding(.top, 23)
            .padding(.bottom, 8)
    }
}

struct StandardHorizontalPaddingModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 22)
    }
}

struct StandardVerticalPaddingModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.top, 23)
            .padding(.bottom, 8)
    }
}

struct PhysicalCardSizeModifier: ViewModifier {
    
    static let widthOffset = 78.0
    
    @ViewBuilder
    func body(content: Content) -> some View {
        let modifyWidth = UIScreen.main.bounds.width - Self.widthOffset
        content
            .frame(width: modifyWidth, height: modifyWidth * 0.6)
    }
}

struct PhysicalCardHeightModifier: ViewModifier {
    
    static let widthOffset = 78.0
    
    @ViewBuilder
    func body(content: Content) -> some View {
        let modifyWidth = UIScreen.main.bounds.width - Self.widthOffset
        content
            .frame(height: modifyWidth * 0.6)
    }
}

struct ButtonPressHandler: ButtonStyle {
    var action: () -> ()
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .onChange(of: configuration.isPressed) {
                if $0 {
                    action()
                }
            }
    }
}

extension View {
    /// Applies the given transform if the given condition evaluates to `true`.
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - transform: The transform to apply to the source `View`.
    /// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }

    /// Method for making a haptic feedback.
    /// - Parameter style: feedback style
    func triggerHapticFeedback(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
