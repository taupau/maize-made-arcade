<div align="center">
  <img src="https://materials.tpeng.cc/proj/mma/title-logo.png" width="400" height="auto" />
</div>

# Maize-Made Arcade

[![Discord](https://img.shields.io/discord/1080338019309060116.svg?logo=discord&style=flat-square&color=219779&logoColor=white&label=‎ )](https://discord.gg/uvv5CFp65X)
[![Ghost](https://img.shields.io/static/v1?style=flat-square&message=Blog%20Posts&color=219779&logo=Ghost&logoColor=white&label=‎ )](https://logs.tpeng.cc/tag/maize-made-arcade)

The Maize-Made Arcade (MMA) is an arcade machine built from the ground up by TauPau Engineering, powered by a Raspberry Pi 4 running a web-based interface built with the open-source GoDot game engine.

<img src="https://materials.tpeng.cc/proj/mma/mma_real.jpg" width="300" height="auto" />

## Project Outline
- [Control Interface](#control-interface)
  - [Circuit Board Design](#circuit-board-design)
  - [Interface Program](#interface-program)
- [Physical Design]()
  - [CAD]()
  - [Construction / Assembly]()
- [Game Development]()
  - [Game Menu]()
  - [Games]()
    - [Pong]()
    - [Asteroids]()
    - [Victors' Crossing]()


The content below is in-progress. Please feel free to read the [blog post](https://logs.tpeng.cc/tag/maize-made-arcade).

### Control Interface
The MMA follows a classic arcade machine controller interface: a joystick on the left and a group of four buttons on the right. 

The joystick and buttons work by using basic limit switches, wired to a custom circuit board mounted to the Raspberry Pi. This setup is coupled with a small program written in Rust that translates the arcade inputs into keyboard strokes, which are then used by the gaming interface. 

<div style="display: flex;">
  <img style="flex: 50%; padding: 5px;" src="https://materials.tpeng.cc/proj/mma/control_wiring.jpg" width="300" height="auto" />
  <img style="flex: 50%; padding: 5px;" src="https://materials.tpeng.cc/proj/mma/pcb_real.jpg" width="300" height="auto" />
</div>

#### Circuit Board Design
<img src="https://materials.tpeng.cc/proj/mma/pcb-2d.png" width="300" height="auto" />

The circuit board design for this project was relatively simple, as each control input is directly connected to a GPIO pin set to INPUT. To make the design a bit more interesting, we incorporated "status" LEDs in the center of the board that light up whenever its corresponding input is activated. The control input pins are active LOW (when a button is pressed the reading on the pin is LOW), as the buttons are pulling the pins to GND when pressed, with the internal pull-up resistors completing the control circuit.

#### Interface Program
As previously stated the gaming interface essentially just runs in a normal browser, expecting normal keyboard inputs. This means we need a program that can convert the GPIO inputs to keyboard strokes that can be interpreted by the browser (this setup has the added benefit of making the games playable on any PC!).


The code is incredibly simple, here's the main loop:
```rust
        for (i, pin) in pins.iter().enumerate() {
            if pin.is_low() {
                enigo.key_down(KEYS[i]);
            } else if pin.is_high() {
                enigo.key_up(KEYS[i]);
            }
        }
```

The program uses [enigo](https://github.com/enigo-rs/enigo) for input simulation, and keeps a mapping of pins -> output keystroke. That's it!
