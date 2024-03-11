//
//  Toggle.swift
//  sweet_game
//
//  Created by Yevhen Khyzhniak on 11.03.2024.
//

import Foundation
import SwiftUI

struct ToggleProcessView: View {
    
    enum ViewType {
        case toggle
        case checkBox
    }

  init(isSelect: Bool, inProcess: Bool, action: @escaping (_ state: Bool) -> Void) {
    self.helper = .init(isSelect: isSelect)
    self.inProcess = inProcess
    self.action = action
    self.viewType = .toggle
  }
    
  init(isSelect: Bool, inProcess: Bool, type: ViewType, action: @escaping (_ state: Bool) -> Void) {
      self.helper = .init(isSelect: isSelect)
      self.inProcess = inProcess
      self.action = action
      self.viewType = type
  }

  @ObservedObject private var helper: Helper
  private let inProcess: Bool
  private let action: (_ state: Bool) -> Void
  private let viewType: ViewType

  var onColor = Color("color_orange", bundle: .main)
  var offColor = Color(UIColor.gray)
  var thumbColor = Color.white

    @ViewBuilder
  var body: some View {
      switch self.viewType {
      case .toggle:
          Button(action: {
              if !self.inProcess {
                  withAnimation {
                      self.helper.isSelect.toggle()
                      self.action(self.helper.isSelect)
                  }
              }
          }) {
              Capsule(style: .circular)
                  .fill(self.helper.isSelect ? onColor : offColor)
                  .frame(width: 52, height: 32)
                  .overlay(
                    self.overlayView()
                  )
          }
      case .checkBox:
          RoundedRectangle(cornerRadius: 2)
              .frame(width: 20, height: 20)
              .foregroundColor(self.helper.isSelect ? Color(.yellow) : .clear)
              .overlay(
                RoundedRectangle(cornerRadius: 2)
                    .stroke(borderColor(), lineWidth: self.helper.isSelect ? 0 : 1)
              )
              .overlay(Image(systemName: "checkmark")
                .resizable()
                .scaledToFit()
                .frame(width: 10, height: 10, alignment: .center)
                .foregroundColor(.white)
                .opacity(self.helper.isSelect ? 1.0 : 0.0)
              )
              .onTapGesture {
                  self.helper.isSelect.toggle()
                  self.action(self.helper.isSelect)
              }
      }
  }
    
    
    private func borderColor() -> Color {
        return self.helper.isSelect ? .clear : Color(UIColor.secondaryLabel)
    }

  @ViewBuilder
  private func overlayView() -> some View {
    if self.inProcess {
        ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color.white))
        .offset(x: !self.helper.isSelect ? 10 : -10)
    } else {
      Circle()
        .fill(thumbColor)
        .shadow(radius: 1, x: 0, y: 1)
        .padding(1.5)
        .offset(x: self.helper.isSelect ? 10 : -10)
    }
  }

  private class Helper: ObservableObject {
    @Published var isSelect: Bool

    init(isSelect: Bool) {
      self.isSelect = isSelect
    }
  }

}
