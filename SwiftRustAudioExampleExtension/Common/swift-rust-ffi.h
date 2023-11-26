//
//  swift-rust-ffi.h
//  SwiftRustAudioExample
//
//  Created by Corné Driesprong on 26/11/2023.
//

#ifndef swift_rust_ffi_h
#define swift_rust_ffi_h

typedef struct {
} Sine;

extern "C" {
    Sine* sine_init(float sample_rate);
    float render(Sine* sine);
}

#endif /* swift_rust_ffi_h */
