use enigo::{Enigo, Key, KeyboardControllable};
use rppal::gpio::Gpio;

// UP, DOWN, LEFT, RIGHT, J_UP, J_DOWN, J_LEFT, J_RIGHT
const INPUTS: [u8; 8] = [11, 9, 10, 22, 26, 19, 13, 6];
const KEYS: [Key; 8] = [Key::UpArrow, Key::DownArrow, Key::LeftArrow, Key::RightArrow, Key::Layout('w'), Key::Layout('s'), Key::Layout('a'), Key::Layout('d')];

fn main() {
    let mut enigo = Enigo::new();
    let gpio = Gpio::new().unwrap();

    let pins = [
        gpio.get(INPUTS[0]).unwrap().into_input(),
        gpio.get(INPUTS[1]).unwrap().into_input(),
        gpio.get(INPUTS[2]).unwrap().into_input(),
        gpio.get(INPUTS[3]).unwrap().into_input(),
        gpio.get(INPUTS[4]).unwrap().into_input(),
        gpio.get(INPUTS[5]).unwrap().into_input(),
        gpio.get(INPUTS[6]).unwrap().into_input(),
        gpio.get(INPUTS[7]).unwrap().into_input(),
    ];

    loop {
        for (i, pin) in pins.iter().enumerate() {
            if pin.is_low() {
                enigo.key_up(KEYS[i]);
            } else if pin.is_high() {
                enigo.key_down(KEYS[i]);
            }
        }

        std::thread::sleep(std::time::Duration::from_millis(5));
    }
}
