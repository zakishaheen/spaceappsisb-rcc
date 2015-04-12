//
//  ViewController.m
//  SpaceGlove
//
//  Created by Ahsan on 4/11/15.
//  Copyright (c) 2015 WSC. All rights reserved.
//

#import "ViewController.h"
#import "SSAccelerometerInfo.h"
#import "ConnectionManager.h"
#import <MultipeerConnectivity/MultipeerConnectivity.h>
//r1f27c

@import CoreMotion;


@interface ViewController ()<ConnectionManagerDelegate>{
    
    ConnectionManager *manager;
    MCSessionState state;
}
@property (weak, nonatomic) IBOutlet UISegmentedControl *typeSegment;
@property (weak, nonatomic) IBOutlet UISlider *rotationSlider;
@property (weak, nonatomic) IBOutlet UISlider *extensionSlider;
@property (weak, nonatomic) IBOutlet UISlider *clawSlider;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

@property (strong, nonatomic) CMMotionManager *motionManager;

@end

@implementation ViewController


- (void) setupPeerConectivity {
    
    
    manager = [ConnectionManager sharedConnectionManager];
//    [manager advertiseSelf:YES delegate:self];
    [manager startBrowsingWithDelegate:self];
    

}

/////////////////////////////////////////////////

- (void)willConntectedWithManager:(id)connectionManager status:(NSDictionary*)stateDic {
    
    MCSessionState stateA = [stateDic[@"state"] integerValue];
    state = stateA;

    if (state == MCSessionStateConnected) {
        MCPeerID *peer = stateDic[@"peerID"];
    }
}

- (void)didConntectedWithManager:(id)connectionManager status:(NSDictionary*)stateDic {
    
    MCSessionState stateA = [stateDic[@"state"] integerValue];
    state = stateA;

    if (state == MCSessionStateConnected) {
        MCPeerID *peer = stateDic[@"peerID"];
    }
}
- (void)didDisconntectedWithManager:(id)connectionManager status:(NSDictionary *)stateDic{

    MCSessionState stateA = [stateDic[@"state"] integerValue];
    state = stateA;

    if (state == MCSessionStateNotConnected) {

        MCPeerID *peer = stateDic[@"peerID"];
    }

}
- (void)connectionManager:(id)connectionManager receivedString:(NSString *)received {
    
    if ([[UIDevice currentDevice].model isEqualToString:@"iPhone Simulator"] && ![received hasPrefix:@"IGNORE"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:received delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
}
- (IBAction)sendData:(id)sender {
    
    [manager sendMessage:@"Hello Robo..."];
}
///************************************
#pragma mark - MCNearbyServiceAdvertiserDelegate

//*************
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (state == MCSessionStateNotConnected) {
        [self setupPeerConectivity];
        
    }else{
        
    }
}
- (void)viewDidLoad {
    
    
    
    [super viewDidLoad];

    state = MCSessionStateNotConnected;
    
    self.rotationSlider.minimumValue =  self.clawSlider.minimumValue = (-1.0)*(M_PI_2);
    self.extensionSlider.minimumValue =  (-1.75)*(M_PI_2);
    
    self.rotationSlider.maximumValue  = self.clawSlider.maximumValue = (1.0)*(M_PI_2);
    self.extensionSlider.maximumValue = (1.0)*(M_PI_2);
    
    CallBackBlock response = ^(id value,MontionValueType type){

        CMDeviceMotion *motion = (CMDeviceMotion *) value;
        double pitch = motion.attitude.pitch;
        double roll  = motion.attitude.roll;
        double yaw   = motion.attitude.yaw;

        NSString *data = [NSString stringWithFormat:@"%ld,%f,%f,%f",(long)self.typeSegment.selectedSegmentIndex,pitch,roll];
        [manager sendMessage:data];
        
        dispatch_async(dispatch_get_main_queue(), ^{

            if (self.typeSegment.selectedSegmentIndex == ActionTypeRotate) {
                self.rotationSlider.value = (-1.0) * pitch;
                
            }else if (self.typeSegment.selectedSegmentIndex == ActionTypeExtend) {
                self.extensionSlider.value = (-1.0) * roll;
                
            }else if (self.typeSegment.selectedSegmentIndex == ActionTypeClaw) {
                
                self.clawSlider.value = (-1.0) * pitch;
                
            }
            


        });
        
    };
    
    [[SSAccelerometerInfo sharedMotionManger] setCallBackBlock:response];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
