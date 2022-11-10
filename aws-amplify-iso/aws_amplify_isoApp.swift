//
//  aws_amplify_isoApp.swift
//  aws-amplify-iso
//
//  Created by Vital SOWATH on 4/11/22.
//

import SwiftUI
import AWSCognitoAuthPlugin
import AWSDataStorePlugin
import AWSS3StoragePlugin
import AWSAPIPlugin
import Amplify

@main
struct aws_amplify_isoApp: App {
     
    var body: some Scene {
        WindowGroup {
            SessionView()
        }
    }
    
    init() {
        configureAmplify()
    }
    
    func configureAmplify() {
        do {
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            let models = AmplifyModels()
            try Amplify.add(plugin: AWSAPIPlugin(modelRegistration: models))
            try Amplify.add(plugin: AWSDataStorePlugin(modelRegistration: models))
            try Amplify.add(plugin: AWSS3StoragePlugin())
            try Amplify.configure()
            print("Amplify Configured Successfully")
        } catch {
            print("Amplify Configured Unsuccessfully", error)
        }
    }
}
