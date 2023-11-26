//
//  SwiftRustAudioExampleExtensionParameterAddresses.h
//  SwiftRustAudioExampleExtension
//
//  Created by Corné Driesprong on 26/11/2023.
//

#pragma once

#include <AudioToolbox/AUParameters.h>

#ifdef __cplusplus
namespace SwiftRustAudioExampleExtensionParameterAddress {
#endif

typedef NS_ENUM(AUParameterAddress, SwiftRustAudioExampleExtensionParameterAddress) {
    gain = 0
};

#ifdef __cplusplus
}
#endif
