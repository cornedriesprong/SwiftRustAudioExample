//
//  SwiftRustAudioExampleApp.swift
//  SwiftRustAudioExample
//
//  Created by Corné Driesprong on 26/11/2023.
//

import CoreMIDI
import SwiftUI

@main
struct SwiftRustAudioExampleApp: App {
    @ObservedObject private var hostModel = AudioUnitHostModel()

    var body: some Scene {
        WindowGroup {
            ContentView(hostModel: hostModel)
        }
    }
}
