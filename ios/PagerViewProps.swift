import SwiftUI
import UIKit

struct IdentifiablePlatformView: Identifiable, Equatable {
  let id = UUID()
  let view: UIView

  init(_ view: UIView) {
    self.view = view
  }
}

@objc public enum PagerLayoutDirection: Int {
  case ltr
  case rtl

  var converted: LayoutDirection {
    switch self {
    case .ltr:
      return .leftToRight
    case .rtl:
      return .rightToLeft
    }
  }
}

class PagerViewProps: ObservableObject {
  @Published var children: [IdentifiablePlatformView] = []
  @Published var currentPage: Int = -1
  @Published var scrollEnabled: Bool = true
  @Published var overdrag: Bool = false
  @Published var keyboardDismissMode: UIScrollView.KeyboardDismissMode = .none
  @Published var layoutDirection: PagerLayoutDirection = .ltr
  @Published var orientation: UICollectionView.ScrollDirection = .horizontal

  func page(atScrollPosition position: Int) -> Int {
    layoutDirection == .rtl ? children.count - 1 - position : position
  }

  @discardableResult
  func resignFirstResponder(outsidePage page: Int) -> Bool {
    guard children.indices.contains(page) else {
      return false
    }
    for (index, child) in children.enumerated() where index != page {
      if let responder = firstResponder(in: child.view) {
        return responder.resignFirstResponder()
      }
    }
    return false
  }

  private func firstResponder(in view: UIView) -> UIView? {
    if view.isFirstResponder {
      return view
    }
    for subview in view.subviews {
      if let responder = firstResponder(in: subview) {
        return responder
      }
    }
    return nil
  }
}
