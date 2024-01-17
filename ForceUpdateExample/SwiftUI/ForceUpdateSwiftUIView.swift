//
//  ForceUpdateSwiftUIView.swift
//  ForceUpdateExample
//
//  Created by kanagasabapathy on 15/01/24.
//

import SwiftUI

struct ForceUpdateSwiftUIView: View {
    @StateObject private var viewModel = ForceUpdateViewModel()
    var body: some View {
        VStack {
            switch viewModel.appStatus {
            case .upToDate:
                EmptyView()
            case .updateAvailable(let version, let storeURL, let releaseNotes):
                AlertView(version: version, storeURL: storeURL, releaseNotes: releaseNotes)
            }
        }
        .padding()
    }
}

struct AlertView: View {
    @State private var showingAlert = false
    @State private var forceUpdate = false
    var version: String
    var storeURL: URL
    var releaseNotes: String
    var body: some View {
        VStack {
            // Button to trigger the alert with "Update" and "Cancel" buttons
            Button("Show Update Alert") {
                forceUpdate = false
                showingAlert.toggle()
            }

            // Button to trigger the force update alert with only "Update" button
            Button("Show Force Update Alert") {
                forceUpdate = true
                showingAlert.toggle()
            }
        }
        .alert(isPresented: $showingAlert) {
            // Use a ternary operator to conditionally create the Alert
            return forceUpdate
            ? Alert(title: Text(Constants.forceUpdateTitle),
                    message: Text(Constants.forceUpdateMessage),
                    dismissButton: .default(Text(Constants.updateBtnText), action: {
                handleUpdate()
            }))
            : Alert(title: Text("Update \(version)"),
                    message: Text(releaseNotes),
                    primaryButton: .default(Text(Constants.updateBtnText), action: {
                handleUpdate()
            }),
                    secondaryButton: .default(Text(Constants.learnMore)))
        }
    }

    func handleUpdate() {
        UIApplication.shared.open(storeURL)
    }
}

#Preview {
    ForceUpdateSwiftUIView()
}
