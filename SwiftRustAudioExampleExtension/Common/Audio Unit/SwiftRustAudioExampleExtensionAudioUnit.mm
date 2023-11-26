//
//  SwiftRustAudioExampleExtensionAudioUnit.mm
//  SwiftRustAudioExampleExtension
//
//  Created by Corné Driesprong on 26/11/2023.
//

#import "SwiftRustAudioExampleExtensionAudioUnit.h"

#import <AVFoundation/AVFoundation.h>
#import <CoreAudioKit/AUViewController.h>

#import "swift-rust-ffi.h"

// Define parameter addresses.

@interface SwiftRustAudioExampleExtensionAudioUnit ()

@property (nonatomic, readwrite) AUParameterTree *parameterTree;
@property AUAudioUnitBusArray *outputBusArray;
@property (nonatomic, readonly) AUAudioUnitBus *outputBus;
@end


@implementation SwiftRustAudioExampleExtensionAudioUnit {
    // C++ members need to be ivars; they would be copied on access if they were properties.
    Sine* _sine;
}

@synthesize parameterTree = _parameterTree;

- (instancetype)initWithComponentDescription:(AudioComponentDescription)componentDescription options:(AudioComponentInstantiationOptions)options error:(NSError **)outError {
    self = [super initWithComponentDescription:componentDescription options:options error:outError];

    if (self == nil) { return nil; }

    [self setupAudioBuses];
    
    _sine = sine_init(self.outputBus.format.sampleRate);

    return self;
}

#pragma mark - AUAudioUnit Setup

- (void)setupAudioBuses {
    // Create the output bus first
    AVAudioFormat *format = [[AVAudioFormat alloc] initStandardFormatWithSampleRate:44100 channels:2];
    _outputBus = [[AUAudioUnitBus alloc] initWithFormat:format error:nil];
    _outputBus.maximumChannelCount = 8;

    // then an array with it
    _outputBusArray = [[AUAudioUnitBusArray alloc] initWithAudioUnit:self
                                                             busType:AUAudioUnitBusTypeOutput
                                                              busses: @[_outputBus]];
}

- (void)setupParameterTree:(AUParameterTree *)parameterTree {
    _parameterTree = parameterTree;

    [self setupParameterCallbacks];
}

- (void)setupParameterCallbacks {
    // Make a local pointer to the kernel to avoid capturing self.

    // A function to provide string representations of parameter values.
    _parameterTree.implementorStringFromValueCallback = ^(AUParameter *param, const AUValue *__nullable valuePtr) {
        AUValue value = valuePtr == nil ? param.value : *valuePtr;

        return [NSString stringWithFormat:@"%.f", value];
    };
}

#pragma mark - AUAudioUnit Overrides

// An audio unit's audio output connection points.
// Subclassers must override this property getter and should return the same object every time.
// See sample code.
- (AUAudioUnitBusArray *)outputBusses {
    return _outputBusArray;
}

// Allocate resources required to render.
// Subclassers should call the superclass implementation.
- (BOOL)allocateRenderResourcesAndReturnError:(NSError **)outError {
    const auto outputChannelCount = [self.outputBusses objectAtIndexedSubscript:0].format.channelCount;

    return [super allocateRenderResourcesAndReturnError:outError];
}

// Deallocate resources allocated in allocateRenderResourcesAndReturnError:
// Subclassers should call the superclass implementation.
- (void)deallocateRenderResources {

    // Deallocate your resources.
    [super deallocateRenderResources];
}

#pragma mark - AUAudioUnit (AUAudioUnitImplementation)

// Block which subclassers must provide to implement rendering.
- (AUInternalRenderBlock)internalRenderBlock {
    /*
     Capture in locals to avoid ObjC member lookups. If "self" is captured in
     render, we're doing it wrong.
     */

    return ^AUAudioUnitStatus(AudioUnitRenderActionFlags 				*actionFlags,
                              const AudioTimeStamp       				*timestamp,
                              AVAudioFrameCount           				frameCount,
                              NSInteger                   				outputBusNumber,
                              AudioBufferList            				*outputData,
                              const AURenderEvent        				*realtimeEventListHead,
                              AURenderPullInputBlock __unsafe_unretained pullInputBlock) {

        for (AVAudioFrameCount i = 0; i < frameCount; ++i) {
            float s = render(self->_sine);
            ((float*)outputData->mBuffers[0].mData)[i] = s;
            ((float*)outputData->mBuffers[1].mData)[i] = s;
        }

        return noErr;
    };
}

@end
