//
//  RootViewModel.swift
//  Mapverse
//
//  Created by Dave Paiva on 26/05/25.
//

import Foundation
import Combine

class RootViewModel: ObservableObject {
    @Published var userAccessToken: String?
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        setupSubscribers()
    }
    
    private func setupSubscribers() {
        AuthService.shared.$currentUserAccessToken
            .sink { [weak self] accessToken in
                guard let self = self else { return }
                self.userAccessToken = accessToken
            }
            .store(in: &cancellables)
    }
    
}
