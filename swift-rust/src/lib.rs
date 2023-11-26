use std::os::raw::c_float;

pub struct Sine {
    frequency: f32,
    sample_rate: f32,
    phase: f32,
}

impl Sine {
    pub fn new(frequency: f32, sample_rate: f32) -> Self {
        Self {
            frequency,
            sample_rate,
            phase: 0.0,
        }
    }

    #[inline]
    pub fn render(&mut self) -> f32 {
        let value =
            (self.phase * self.frequency * 2.0 * std::f32::consts::PI / self.sample_rate).sin();
        self.phase = (self.phase + 1.0) % self.sample_rate;
        value
    }
}

#[no_mangle]
pub extern "C" fn sine_init(sample_rate: f32) -> Box<Sine> {
    let sine = Sine::new(440.0, sample_rate);

    return Box::new(sine);
}

#[no_mangle]
pub extern "C" fn render(sine: &mut Sine) -> c_float {
    sine.render()
}
