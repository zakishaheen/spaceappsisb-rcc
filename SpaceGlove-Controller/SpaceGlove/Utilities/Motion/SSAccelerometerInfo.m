//
//  SSAccelerometerInfo.m
//  SystemServicesDemo
//
//  Created by Shmoopi LLC on 9/20/12.
//  Copyright (c) 2012 Shmoopi LLC. All rights reserved.
//

#import "SSAccelerometerInfo.h"

// Private
@interface SSAccelerometerInfo ()

/**
 * processMotion:withError:
 *
 * Appends the new motion data to the appropriate instance variable strings.
 */
- (void)processMotion:(CMDeviceMotion*)motion withError:(NSError*)error;

/**
 * processAccel:withError:
 *
 * Appends the new raw accleration data to the appropriate instance variable string.
 */
- (void)processAccel:(CMAccelerometerData*)accelData withError:(NSError*)error;

/**
 * processGyro:withError:
 *
 * Appends the new raw gyro data to the appropriate instance variable string.
 */
- (void)processGyro:(CMGyroData*)gyroData withError:(NSError*)error;

@end

// Implementation
@implementation SSAccelerometerInfo

@synthesize attitudeString, attitude, gravityString, magneticFieldString, rotationRateString, rotationRate, userAccelerationString, userAcceleration,rawGyroscopeString, rawAccelerometerString;

#pragma mark - Singelton

+ (SSAccelerometerInfo *)sharedMotionManger {
    
    static SSAccelerometerInfo *sharedSystemServices = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSystemServices = [[self alloc] init];
    });
    return sharedSystemServices;
}

#pragma mark - Device Orientation
+ (UIDeviceOrientation)deviceOrientation {
    // Get the device's current orientation
    @try {
        // Device orientation
        //UIInterfaceOrientation Orientation = [[UIApplication sharedApplication] statusBarOrientation];
        
        UIDeviceOrientation Orientation = [[UIDevice currentDevice] orientation];
        
        // Successful
        return Orientation;
    }
    @catch (NSException *exception) {
        // Error
        return -1;
    }
}

// Start logging motion data
- (void)startLoggingMotionData {
    
    motionManager = [[CMMotionManager alloc] init];
    motionManager.deviceMotionUpdateInterval = 0.1; //100 Hz
    motionManager.accelerometerUpdateInterval = 0.1;
    motionManager.gyroUpdateInterval = 0.01;
    
    // Limiting the concurrent ops to 1 is a cheap way to avoid two handlers editing the same
    // string at the same time.
    deviceMotionQueue = [[NSOperationQueue alloc] init];
    [deviceMotionQueue setMaxConcurrentOperationCount:1];
    
    accelQueue = [[NSOperationQueue alloc] init];
    [accelQueue setMaxConcurrentOperationCount:1];
    
    gyroQueue = [[NSOperationQueue alloc] init];
    [gyroQueue setMaxConcurrentOperationCount:1];

    // Logging Motion Data
    
    CMDeviceMotionHandler motionHandler = ^(CMDeviceMotion *motion, NSError *error) {
        [self processMotion:motion withError:error];
    };
    
    CMGyroHandler gyroHandler = ^(CMGyroData *gyroData, NSError *error) {
        [self processGyro:gyroData withError:error];
    };
    
    CMAccelerometerHandler accelHandler = ^(CMAccelerometerData *accelerometerData, NSError *error) {
        [self processAccel:accelerometerData withError:error];
    };
    
    [motionManager startDeviceMotionUpdatesToQueue:deviceMotionQueue withHandler:motionHandler];
    
    [motionManager startGyroUpdatesToQueue:gyroQueue withHandler:gyroHandler];
    
    [motionManager startAccelerometerUpdatesToQueue:accelQueue withHandler:accelHandler];
}

// Stop logging motion data
- (void)stopLoggingMotionData {
    
    // Stop everything
    [motionManager stopDeviceMotionUpdates];
    [deviceMotionQueue waitUntilAllOperationsAreFinished];
    
    [motionManager stopAccelerometerUpdates];
    [accelQueue waitUntilAllOperationsAreFinished];
    
    [motionManager stopGyroUpdates];
    [gyroQueue waitUntilAllOperationsAreFinished];
    
}

#pragma mark - Set Motion Variables when Updating (in background)

- (void)processAccel:(CMAccelerometerData*)accelData withError:(NSError*)error {
    
    rawAccelerometerString = [NSString stringWithFormat:@"%f,%f,%f,%f", accelData.timestamp,
                              accelData.acceleration.x,
                              accelData.acceleration.y,
                              accelData.acceleration.z,
                              nil];
//    self.callBackBlock(@"",MontionValueTypeAccelro);
}

- (void)processGyro:(CMGyroData*)gyroData withError:(NSError*)error {
    
    rawGyroscopeString = [NSString stringWithFormat:@"%f,%f,%f,%f", gyroData.timestamp,
                          gyroData.rotationRate.x,
                          gyroData.rotationRate.y,
                          gyroData.rotationRate.z,
                          nil];
    
//    self.callBackBlock(@"",MontionValueTypeGyro);
    
//    NSLog(@"GYRO:%@",rawGyroscopeString);

}

- (void)processMotion:(CMDeviceMotion*)motion withError:(NSError*)error {
    
    attitude.pitch = motion.attitude.pitch;
    attitude.roll  = motion.attitude.roll;
    attitude.yaw   = motion.attitude.yaw;
    
    
    attitudeString = [NSString stringWithFormat:@"%f,%f,%f,%f", motion.timestamp,
                      motion.attitude.roll,
                      motion.attitude.pitch,
                      motion.attitude.yaw,
                      nil];
    
    
    
    gravityString = [NSString stringWithFormat:@"%f,%f,%f,%f", motion.timestamp,
                     motion.gravity.x,
                     motion.gravity.y,
                     motion.gravity.z,
                     nil];
    
    magneticFieldString = [NSString stringWithFormat:@"%f,%f,%f,%f,%d", motion.timestamp,
                           motion.magneticField.field.x,
                           motion.magneticField.field.y,
                           motion.magneticField.field.z,
                           (int)motion.magneticField.accuracy,
                           nil];
    
    rotationRate = motion.rotationRate;
    
    rotationRateString = [NSString stringWithFormat:@"%f,%f,%f,%f", motion.timestamp,
                          motion.rotationRate.x,
                          motion.rotationRate.y,
                          motion.rotationRate.z,
                          nil];
    
    userAcceleration = motion.userAcceleration;
    
    userAccelerationString = [NSString stringWithFormat:@"%f,%f,%f,%f", motion.timestamp,
                              motion.userAcceleration.x,
                              motion.userAcceleration.y,
                              motion.userAcceleration.z,
                              nil];
    
    self.callBackBlock(motion,MontionValueTypeMotion);
}


@end
