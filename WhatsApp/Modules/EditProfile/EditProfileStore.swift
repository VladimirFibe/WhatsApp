//
//  EditProfileStore.swift
//  WhatsApp
//
//  Created by Vladimir Fibe on 28.09.2023.
//

import Foundation

import Foundation

enum EditProfileEvent {
    case done
}

enum EditProfileAction {
    case reset
}

final class EditProfileStore: Store<EditProfileEvent, EditProfileAction> {
    private let useCase: EditProfileUseCase

    init(useCase: EditProfileUseCase) {
        self.useCase = useCase
    }

    override func handleActions(action: EditProfileAction) {
//        switch action {
//        case .register(let email, let password):
//            statefulCall {
//                weak var wSelf = self
//                try await wSelf?.register(
//                    withEmail: email,
//                    password: password
//                )
//            }
//        case .login(let email, let password):
//            statefulCall {
//                weak var wSelf = self
//                try await wSelf?.login(
//                    withEmail: email,
//                    password: password
//                )
//            }
//        case .sendEmailVerification:
//            statefulCall(sendEmailVerification)
//        case .resetPassword(let email):
//            statefulCall {
//                weak var wSelf = self
//                try await wSelf?.resetPassword(for: email)
//            }
//
//        }
    }

//    private func register(withEmail email: String, password: String) async throws {
//        try await useCase.register(
//            withEmail: email,
//            password: password
//        )
//        sendEvent(.registered)
//    }
//
//    private func login(withEmail email: String, password: String) async throws {
//    }
//
//    private func sendEmailVerification() async throws {
//    }
//
//    private func resetPassword(for email: String) async throws {
//    }
}
