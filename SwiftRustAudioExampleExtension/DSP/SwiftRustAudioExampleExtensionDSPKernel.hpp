//
//  SwiftRustAudioExampleExtensionDSPKernel.hpp
//  SwiftRustAudioExampleExtension
//
//  Created by Corné Driesprong on 26/11/2023.
//

#pragma once

#import <AudioToolbox/AudioToolbox.h>
#import <algorithm>
#import <vector>
#import <span>

#import "SinOscillator.h"
#import "SwiftRustAudioExampleExtension-Swift.h"
#import "SwiftRustAudioExampleExtensionParameterAddresses.h"

/*
 SwiftRustAudioExampleExtensionDSPKernel
 As a non-ObjC class, this is safe to use from render thread.
 */
class SwiftRustAudioExampleExtensionDSPKernel {
public:
    void initialize(int channelCount, double inSampleRate) {
        mSampleRate = inSampleRate;
        mSinOsc = SinOscillator(inSampleRate);
        mSinOsc.setFrequency(441.0);
    }
    
    void deInitialize() {
    }
    
    // MARK: - Bypass
    bool isBypassed() {
        return mBypassed;
    }
    
    void setBypass(bool shouldBypass) {
        mBypassed = shouldBypass;
    }
    
    // MARK: - Parameter Getter / Setter
    // Add a case for each parameter in SwiftRustAudioExampleExtensionParameterAddresses.h
    void setParameter(AUParameterAddress address, AUValue value) {
        switch (address) {
            case SwiftRustAudioExampleExtensionParameterAddress::gain:
                mGain = value;
                break;
        }
    }
    
    AUValue getParameter(AUParameterAddress address) {
        // Return the goal. It is not thread safe to return the ramping value.
        
        switch (address) {
            case SwiftRustAudioExampleExtensionParameterAddress::gain:
                return (AUValue)mGain;
                
            default: return 0.f;
        }
    }
    
    // MARK: - Max Frames
    AUAudioFrameCount maximumFramesToRender() const {
        return mMaxFramesToRender;
    }
    
    void setMaximumFramesToRender(const AUAudioFrameCount &maxFrames) {
        mMaxFramesToRender = maxFrames;
    }
    
    /**
     MARK: - Internal Process
     
     This function does the core siginal processing.
     Do your custom DSP here.
     */
    void process(std::span<float *> outputBuffers, AUEventSampleTime bufferStartTime, AUAudioFrameCount frameCount) {
        if (mBypassed) {
            // Fill the 'outputBuffers' with silence
            for (UInt32 channel = 0; channel < outputBuffers.size(); ++channel) {
                std::fill_n(outputBuffers[channel], frameCount, 0.f);
            }
            return;
        }
        
        // Generate per sample dsp before assigning it to out
        for (UInt32 frameIndex = 0; frameIndex < frameCount; ++frameIndex) {
            // Do your frame by frame dsp here...
            const auto sample = mSinOsc.process() * mGain;

            for (UInt32 channel = 0; channel < outputBuffers.size(); ++channel) {
                outputBuffers[channel][frameIndex] = sample;
            }
        }
    }
    
    void handleOneEvent(AUEventSampleTime now, AURenderEvent const *event) {
        switch (event->head.eventType) {
            case AURenderEventParameter: {
                handleParameterEvent(now, event->parameter);
                break;
            }
                
            default:
                break;
        }
    }
    
    void handleParameterEvent(AUEventSampleTime now, AUParameterEvent const& parameterEvent) {
        // Implement handling incoming Parameter events as needed
    }
    
    // MARK: Member Variables
    double mSampleRate = 44100.0;
    double mGain = 1.0;
    bool mBypassed = false;
    AUAudioFrameCount mMaxFramesToRender = 1024;
    
    SinOscillator mSinOsc;
};
