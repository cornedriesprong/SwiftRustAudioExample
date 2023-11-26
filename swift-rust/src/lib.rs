use std::os::raw::{c_int, c_uint, c_void};

#[repr(C)]
#[allow(nonstandard_style, clippy::upper_case_acronyms)]
pub struct AudioBuffer {
    pub mNumberChannels: c_uint,
    pub mDataByteSize: c_uint,
    pub mData: *mut c_void,
}

#[repr(C)]
#[allow(nonstandard_style, clippy::upper_case_acronyms)]
pub struct AudioBufferList {
    pub mNumberBuffers: c_uint,
    pub mBuffers: [AudioBuffer; 128],
}

#[no_mangle]
pub extern "C" fn render(output: &mut AudioBufferList, frame_count: usize) -> i32 {
    let buffer_l = &mut output.mBuffers[0];
    let data_l = unsafe {
        let data_slice = std::slice::from_raw_parts_mut(
            buffer_l.mData as *mut f32,
            buffer_l.mDataByteSize as usize / std::mem::size_of::<f32>(),
        );
        data_slice
    };
    let buffer_r = &mut output.mBuffers[1];
    let data_r = unsafe {
        let data_slice = std::slice::from_raw_parts_mut(
            buffer_r.mData as *mut f32,
            buffer_r.mDataByteSize as usize / std::mem::size_of::<f32>(),
        );
        data_slice
    };

    let mut data = vec![0.0; frame_count];
    // engine.render(&mut data, frame_count);

    for ((l, r), d) in data_l.iter_mut().zip(data_r.iter_mut()).zip(data) {
        *l = d;
        *r = d;
    }

    return 0;
}
