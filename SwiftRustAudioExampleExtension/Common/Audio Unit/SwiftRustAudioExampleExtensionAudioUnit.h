//
//  SwiftRustAudioExampleExtensionAudioUnit.h
//  SwiftRustAudioExampleExtension
//
//  Created by Corné Driesprong on 26/11/2023.
//

#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface SwiftRustAudioExampleExtensionAudioUnit : AUAudioUnit
- (void)setupParameterTree:(AUParameterTree *)parameterTree;
@end
