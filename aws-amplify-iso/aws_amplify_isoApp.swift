//
//  aws_amplify_isoApp.swift
//  aws-amplify-iso
//
//  Created by Vital SOWATH on 4/11/22.
//

import SwiftUI
import AWSCognitoAuthPlugin
import AWSDataStorePlugin
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
            try Amplify.add(plugin: AWSDataStorePlugin(modelRegistration: AmplifyModels()))
            try Amplify.configure()
            print("Amplify Configured Successfully")
        } catch {
            print("Amplify Configured Unsuccessfully", error)
        }
    }
}
