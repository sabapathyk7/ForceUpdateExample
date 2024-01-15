//
//  HostingSwiftUIController.swift
//  ForceUpdateExample
//
//  Created by kanagasabapathy on 15/01/24.
//

import UIKit
import SwiftUI

class HostingSwiftUIController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let hostingVC = UIHostingController(rootView: ForceUpdateSwiftUIView())
        guard let hostingVC = hostingVC as? UIHostingController else {
            return
        }
        guard let swiftUIView = hostingVC.view else {
            return
        }
        addChild(hostingVC)
        view.addSubview(swiftUIView)
        swiftUIView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                           leading: view.safeAreaLayoutGuide.leadingAnchor,
                           bottom: view.safeAreaLayoutGuide.bottomAnchor,
                           trailing: view.safeAreaLayoutGuide.trailingAnchor)
        hostingVC.didMove(toParent: self)
    }
}
