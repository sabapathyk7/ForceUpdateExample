//
//  ForceUpdateViewController.swift
//  ForceUpdateExample
//
//  Created by kanagasabapathy on 15/01/24.
//

import UIKit

final class ForceUpdateViewController: UIViewController {

    private var forceUpdate = false
    private var viewModel: ForceUpdateViewModel = ForceUpdateViewModel()

    private lazy var updateButton: UIButton = {
        // Create and configure Button
        let updateButton = UIButton(type: .system)
        updateButton.setTitle("Show Update Alert", for: .normal)
        updateButton.addTarget(self, action: #selector(showUpdateAlert), for: .touchUpInside)
        return updateButton
    }()

    private lazy var forceUpdateButton: UIButton = {
        // Create and configure Button
        let forceUpdateButton = UIButton(type: .system)
        forceUpdateButton.setTitle("Show Force Update Alert", for: .normal)
        forceUpdateButton.addTarget(self, action: #selector(showForceUpdateAlert), for: .touchUpInside)
        return forceUpdateButton
    }()

    private func setupUI() {
        view.addSubViews([updateButton, forceUpdateButton])
        setupConstraints()

    }
    private func setupConstraints() {
        updateButton.anchorCenter(centerX: view.centerXAnchor,
                                  centerY: view.centerYAnchor,
                                  inset: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -30))
        forceUpdateButton.anchorCenter(centerX: view.centerXAnchor,
                                       centerY: view.centerYAnchor,
                                       inset: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 30))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }

    @objc func showUpdateAlert() {
        forceUpdate = false
        showAlert()
    }

    @objc func showForceUpdateAlert() {
        forceUpdate = true
        showAlert()
    }

    func showAlert() {
        switch viewModel.appStatus {
        case .upToDate:
            print("App Upto Date")
        case .updateAvailable(let version, let storeURL, let releaseNotes):
            let alertController = UIAlertController(
                title: forceUpdate ? "Force Update" : "Update \(version)",
                message: forceUpdate ? "A new version is available. Update now?": releaseNotes,
                preferredStyle: .alert
            )

            alertController.addAction(UIAlertAction(
                title: "Update",
                style: .default,
                handler: { _ in
                    self.handleUpdate(storeURL: storeURL)
                }
            ))

            if !forceUpdate {
                alertController.addAction(UIAlertAction(
                    title: "Cancel",
                    style: .cancel,
                    handler: nil
                ))
            }

            present(alertController, animated: true, completion: nil)
        }
    }

    func handleUpdate(storeURL: URL) {
        UIApplication.shared.open(storeURL)
    }
}
