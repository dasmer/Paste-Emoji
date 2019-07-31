// Source: https://github.com/Jinxiansen/SwiftUI/blob/master/Example/Example/Page/SpecialPage/ControllerPage.swift

import Foundation
import SwiftUI
import UIKit

struct ControllerPage<T: UIViewController> : UIViewControllerRepresentable {

    // MARK: - UIViewControllerRepresentable

    func makeUIViewController(context: UIViewControllerRepresentableContext<ControllerPage>) -> UIViewController {
        return T()
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<ControllerPage>) {
        debugPrint("\(#function)：\(type(of: T.self))")
    }
}
