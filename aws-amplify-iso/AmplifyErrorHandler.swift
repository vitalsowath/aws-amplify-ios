//
//  AmplifyError.swift
//  aws-amplify-iso
//
//  Created by Vital SOWATH on 4/11/22.
//

import Amplify
import Foundation

enum AmplifyErrorHandler: Error {
    case amplify(AmplifyError)
}
