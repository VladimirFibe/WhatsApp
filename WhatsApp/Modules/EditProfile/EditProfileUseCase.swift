//
//  EditProfileUseCase.swift
//  WhatsApp
//
//  Created by Vladimir Fibe on 28.09.2023.
//

import Foundation

import Foundation

protocol EditProfileUseCaseProtocol {
}

final class EditProfileUseCase: EditProfileUseCaseProtocol {

    private let apiService: EditProfileServiceProtocol

    init(apiService: EditProfileServiceProtocol) {
        self.apiService = apiService
    }
}
