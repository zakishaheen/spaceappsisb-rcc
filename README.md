# RemoRoboCon (RRC) - SpaceGlove entry in NASA International Space Apps Challenge 2015
## Overview
![International Space Apps Challenge](https://github.com/zakishaheen/spaceappsisb-rcc/blob/master/logo.png)

*RemoRoboCon (RRC) Aims to enhance tele-manipulators on the mobile service system (MSS) on the ISS, specifically the Dextre (SPDM). We seek to find ways to use wearable tech to improve precision and motion of control by adapting the robots to use data from wearable tech and voice.* 

This project is solving the SpaceGloVe: [Spacecraft Gesture and Voice Commanding challenge](https://2015.spaceappschallenge.org/challenge/spaceglove-spacecraft-gesture-and-voice-commanding/).


![Alt text](https://github.com/zakishaheen/spaceappsisb-rcc/blob/master/d1.jpg)

![Alt text](https://github.com/zakishaheen/spaceappsisb-rcc/blob/master/d2.jpg)

## Description
Telemanipulators on the ISS are very important and versatile robots. They are use in repair operations and reduce the risk to humans from space walks. One of the tele-manipulators is Dextre - the special purpose dexterous manipulator (SPDM). It is controlled currently by joy stick console system. We aim to let astronauts be able to do more by freeing their hands from controlling the joysticks and providing new ways of manipulating the robot arms.

We will simulate a simple, tele-manipulating robot with a rotating clamp claw in 2D on the iPad (top view). It will then be controlled by a hand-mounted wearable (iPhone) and use voice commands to activate rotation, extension. claw rotation and other commands. Motion sensors will be used to rotate, extend and orient the robot in the proper direction. This will greatly increase the dexterity of the astronaut as they do not have to hold the joysticks anymore.

## Technologies 
- iOS SDK
- UIKit Dynamics
- Multipeer connectivity framework
- iPhone Gyroscope & Accelerometer 

# Demo

Watch demo video [here](https://vimeo.com/124734540) (Vimeo). 

## Setup instructions
There are two XCode projects. One contains the robot simulator called `rccsimulator` and other is called `SpaceGlove-Controller`. Best way to experience the project is to deploy the `rccsimulator` on the iPad or iPad simulator. Then Deploy the `SpaceGlove-Controller` on an iPhone. Make sure both of them are on the same network. On the iPhone, the peer connectivity dialog will show up. Select 'zaki' to connect and hit done. At the same time a popup dialog will open on the iPad to accept the incoming request. Once it is allowed, both devices are paired up ready for the iphone to control the Robot simulator.

You can play around with the robot without the iPhone control by using the sliders. There are some glitches in the robot constraints so don't worry about some minor wobbling of the components. 

To select different modes, select the apropriate action on the Space Glove App. 

## Team
- [Zaki Shaheen](https://twitter.com/meetZaki)
- [Naveed Ahsan](https://pk.linkedin.com/in/aahsanali)



RemoRoboCon Simulator and Controller for NASA International SpaceApps Challenge 2015 (SpaceAppsISB)




