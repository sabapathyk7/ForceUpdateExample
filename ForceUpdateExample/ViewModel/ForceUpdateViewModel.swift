//
//  ForceUpdateViewModel.swift
//  ForceUpdateExample
//
//  Created by kanagasabapathy on 16/01/24.
//

import Foundation
import NetworkKit
import Combine

@MainActor
final class ForceUpdateViewModel: ObservableObject {
    @Published var appMetaDataInfo: AppMetaDataInfo = AppMetaDataInfo()
    @Published var appStatus: AppStatus = AppStatus.upToDate

    enum AppStatus: Equatable {
        case upToDate
        case updateAvailable(version: String, storeURL: URL, releaseNotes: String)
    }
    private var networkService: Networkable
    private var cancellable = Set<AnyCancellable>()
    private var currentVersion: () -> String? = {
        //    Uncomment below
        //    Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        "12.1"   // Comment for real-time
    }
    //    Uncomment below
    //    private let bundleIdentifier: String? = Bundle.main.bundleIdentifier

    private let bundleIdentifier: String? = "com.apple.Pages" // Comment for real-time
    init(networkService: Networkable = NetworkService()) {
        self.networkService = networkService
        Task {
          appStatus = await fetchAppStatus()
        }
    }
}

extension ForceUpdateViewModel {
    private func fetchAppStatus() async -> AppStatus {
        do {
            let appMetaDataResult = try await networkService.sendRequest(
                endpoint: AppUpdateEndPoint.appUpdateMetaData(
                    queryParams: Constants.bundleID)) as AppMetaDataResult
            print(appMetaDataResult.results)
            guard let appMetaData = appMetaDataResult.results.first else {
                throw NetworkError.noResponse
            }
            return try updateStatus(for: appMetaData)
        } catch {
            print(error)
            return AppStatus.upToDate
        }
    }
    private func fetchAppStatusCombine() {
        networkService.sendRequest(
            endpoint: AppUpdateEndPoint.appUpdateMetaData(
                queryParams: Constants.bundleID),
            type: AppMetaDataResult.self)
        .receive(on: RunLoop.main)
        .sink { completion in
            switch completion {
            case .finished:
                print("Finished")
            case .failure(let error):
                print(error.customMessage)
            }
        } receiveValue: { result in
            print(result)
        }
        .store(in: &cancellable)
    }
    private func fetchAppStatusClosure() {
        networkService.sendRequest(endpoint: AppUpdateEndPoint.appUpdateMetaData(
            queryParams: Constants.bundleID)) { (response: Result<AppMetaDataResult, NetworkError>) in
                switch response {
                case .success(let appMetaDataResultData):
                    DispatchQueue.main.async {
                        print(appMetaDataResultData)
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        print(error.customMessage)
                    }
                }
            }
    }
    private func updateStatus(for appMetaData: AppMetaData) throws -> AppStatus {
        guard let currentVersion = currentVersion() else {
            throw NetworkError.decode
        }
        switch currentVersion.compare(appMetaData.version) {
        case .orderedDescending, .orderedSame:
            return ForceUpdateViewModel.AppStatus.upToDate
        case .orderedAscending:
            return ForceUpdateViewModel.AppStatus.updateAvailable(
                version: appMetaData.version,
                storeURL: appMetaData.trackViewUrl,
                releaseNotes: appMetaData.releaseNotes)
        }
    }
}
