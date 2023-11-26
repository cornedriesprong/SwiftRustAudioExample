//
//  SwiftRustAudioExampleExtensionMainView.swift
//  SwiftRustAudioExampleExtension
//
//  Created by Corné Driesprong on 26/11/2023.
//

import SwiftUI

struct SwiftRustAudioExampleExtensionMainView: View {
    var parameterTree: ObservableAUParameterGroup
    
    var body: some View {
        ParameterSlider(param: parameterTree.global.gain)
    }
}
