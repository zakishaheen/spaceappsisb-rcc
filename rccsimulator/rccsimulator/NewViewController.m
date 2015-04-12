//
//  NewViewController.m
//  rccsimulator
//
//  Created by Zaki Shaheen on 4/11/15.
//  Copyright (c) 2015 Zaki Shaheen. All rights reserved.
//

#import "NewViewController.h"
#import "ConnectionManager.h"

#import <MultipeerConnectivity/MultipeerConnectivity.h>
@interface NewViewController (){
    
    ConnectionManager *manager;
    
}

@property (nonatomic, strong) UIView *v1;
@property (nonatomic, strong) UIView *v2;
@property (nonatomic, strong) UIView *v3;
@property (nonatomic, strong) UIView *v4;

@property MCPeerID *myPeerId;

@property (nonatomic, strong) UIView *bicepView;
@property (nonatomic, strong) UIView *forearmView;
@property (nonatomic, strong) UIView *wristView;

@property (nonatomic, strong) UIAttachmentBehavior *bicepOriginAttachment;
@property (nonatomic, strong) UIAttachmentBehavior *bicepEndAttachment;

@property (nonatomic, strong) UIAttachmentBehavior *forearmOriginAttachment;
@property (nonatomic, strong) UIAttachmentBehavior *forearmEndAttachment;

@property (nonatomic, strong) UIAttachmentBehavior *wristOriginAttachment;
@property (nonatomic, strong) UIAttachmentBehavior *wristEndAttachment;

@property (nonatomic, strong) UIDynamicAnimator *animator;

@property CGPoint p1;
@property CGPoint p2;
@property CGPoint p3;
@property CGPoint p4;

@property CGFloat r;

@property CGFloat t1;
@property CGFloat t2;

@property CGFloat anchorSize;
@property CGFloat armLength;
@property CGFloat wristLength;

@property (weak, nonatomic) IBOutlet UISlider *wristSlider;

@property (weak, nonatomic) IBOutlet UISlider *extensionSlider;
@property CGFloat l;
@property (weak, nonatomic) IBOutlet UISlider *rotationSlider;

@end

@implementation NewViewController

- (void) calculateAnchorsCoordinates{
    
    
    self.p1 = CGPointMake(100, self.view.frame.size.height/4);
    
    self.p2 = CGPointMake(self.p1.x + self.r * cos(self.t1),
                          self.p1.y + self.r * sin(self.t1));
    
    self.p3 = CGPointMake(self.p1.x + (self.r + self.l) * cos(self.t1),
                          self.p1.y + (self.r + self.l) * sin(self.t1));
    
    self.p4 = CGPointMake(self.p3.x + (self.wristLength) * cos(self.t1 + self.t2),
                          self.p3.y + (self.wristLength) * sin(self.t1 + self.t2));
    
    
    self.bicepOriginAttachment.anchorPoint = self.p1;
    self.bicepEndAttachment.anchorPoint = self.p3;
    
    self.forearmOriginAttachment.anchorPoint = self.p2;
    self.forearmEndAttachment.anchorPoint = self.p3;
    
    self.wristOriginAttachment.anchorPoint = self.p3;
    self.wristEndAttachment.anchorPoint = self.p4;
    
    
    [self updateFrames];
}

- (void) updateFrames{

    self.v1.center = self.p1;
    self.v2.center = self.p2;
    self.v3.center = self.p3;
    self.v4.center = self.p4;
}

- (void)setupAnchorStartValues {
    self.anchorSize = 10.0f;
    self.armLength = 300.0f;
    self.wristLength = 70.0f;
    self.l = self.armLength;
    self.r = self.l * self.extensionSlider.value;
    self.t1 = self.rotationSlider.value;
    self.t2 = self.wristSlider.value;
}

- (void)createAnchorViews {
    self.v1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.anchorSize, self.anchorSize)];
    self.v2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.anchorSize, self.anchorSize)];
    self.v3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.anchorSize, self.anchorSize)];
    self.v4 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.anchorSize, self.anchorSize)];
    
    [self.v1.layer setCornerRadius:self.anchorSize/2.0];
    [self.v2.layer setCornerRadius:self.anchorSize/2.0];
    [self.v3.layer setCornerRadius:self.anchorSize/2.0];
    [self.v4.layer setCornerRadius:self.anchorSize/2.0];
    
    [self.v1 setBackgroundColor:[UIColor blackColor]];
    [self.v2 setBackgroundColor:[UIColor blackColor]];
    [self.v3 setBackgroundColor:[UIColor blackColor]];
    [self.v4 setBackgroundColor:[UIColor blackColor]];
    
    [self.view addSubview:self.v1];
    [self.view addSubview:self.v2];
    [self.view addSubview:self.v3];
    [self.view addSubview:self.v4];
    
    
}

- (void) setupDynamics{
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
}


- (void) createArmViews{
    self.bicepView = [[UIView alloc] initWithFrame:CGRectZero];
    self.bicepView.backgroundColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.75];
    
    self.forearmView = [[UIView alloc] initWithFrame:CGRectZero];
    self.forearmView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:0.75];
    
    self.wristView = [[UIView alloc] initWithFrame:CGRectZero];
    self.wristView.backgroundColor = [UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:0.75];
    
    [self.view addSubview:self.forearmView];
    [self.view addSubview:self.bicepView];
    [self.view  addSubview:self.wristView];
    

}

- (void) calculateArmViews{
    CGRect bicepFrame = CGRectMake(0, 0, self.armLength, 30);
    CGRect foreArmFrame = CGRectMake(0, 0, self.armLength, 20);
    CGRect wristFrame = CGRectMake(0, 0, self.wristLength, 15);
    
    self.bicepView.frame = bicepFrame;
    self.forearmView.frame = foreArmFrame;
    self.wristView.frame = wristFrame;
}

- (void) createAttachments{
    self.bicepOriginAttachment = [[UIAttachmentBehavior alloc]
                                                   initWithItem:self.bicepView
                                                   offsetFromCenter:UIOffsetMake(-self.bicepView.frame.size.width/2, 0)
                                                   attachedToAnchor:self.p1];
    
    
    self.bicepEndAttachment = [[UIAttachmentBehavior alloc]
                                                   initWithItem:self.bicepView
                                                   offsetFromCenter:UIOffsetMake(self.bicepView.frame.size.width/2, 0)
                                                   attachedToAnchor:self.p3];
    
    self.bicepOriginAttachment.length = 0;
    self.bicepEndAttachment.length = 0;

    [self.animator addBehavior:self.bicepOriginAttachment];
    [self.animator addBehavior:self.bicepEndAttachment];

    
    self.forearmOriginAttachment = [[UIAttachmentBehavior alloc]
                                  initWithItem:self.forearmView
                                  offsetFromCenter:UIOffsetMake(-self.forearmView.frame.size.width/2, 0)
                                  attachedToAnchor:self.p2];
    
    
    self.forearmEndAttachment = [[UIAttachmentBehavior alloc]
                               initWithItem:self.forearmView
                               offsetFromCenter:UIOffsetMake(self.forearmView.frame.size.width/2, 0)
                               attachedToAnchor:self.p3];
    
    self.forearmOriginAttachment.length = 0;
    self.forearmEndAttachment.length = 0;

    [self.animator addBehavior:self.forearmOriginAttachment];
    [self.animator addBehavior:self.forearmEndAttachment];

    
    
    self.wristOriginAttachment = [[UIAttachmentBehavior alloc]
                                    initWithItem:self.wristView
                                    offsetFromCenter:UIOffsetMake(-self.wristView.frame.size.width/2, 0)
                                    attachedToAnchor:self.p3];
    
    
    self.wristEndAttachment = [[UIAttachmentBehavior alloc]
                                 initWithItem:self.wristView
                                 offsetFromCenter:UIOffsetMake(self.wristView.frame.size.width/2, 0)
                                 attachedToAnchor:self.p4];
    
    self.wristOriginAttachment.length = 0;
    self.wristEndAttachment.length = 0;
    
    
    [self.animator addBehavior:self.wristOriginAttachment];
    [self.animator addBehavior:self.wristEndAttachment];
    

    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupAnchorStartValues];
    [self createAnchorViews];
    [self calculateAnchorsCoordinates];
    [self createArmViews];
    [self calculateArmViews];
    
    
    
    
}

////////////////////// Multipeer connectivity \\\///////////////////////////

- (void) setupPeerConectivity {
    
    
    manager = [ConnectionManager sharedConnectionManager];
    [manager advertiseSelf:YES delegate:self];
    //    [manager startBrowsingWithDelegate:self];
    
    
}

- (void)willConntectedWithManager:(id)connectionManager status:(NSDictionary*)stateDic {
    
    MCSessionState state = [stateDic[@"state"] integerValue];
    
    if (state == MCSessionStateConnected) {
        MCPeerID *peer = stateDic[@"peerID"];
    }
}

- (void)didConntectedWithManager:(id)connectionManager status:(NSDictionary*)stateDic {
    
    MCSessionState state = [stateDic[@"state"] integerValue];
    
    if (state == MCSessionStateConnected) {
        MCPeerID *peer = stateDic[@"peerID"];
    }
}

- (void)connectionManager:(id)connectionManager receivedString:(NSString *)received {
    
    if ([[UIDevice currentDevice].model isEqualToString:@"iPhone Simulator"] && ![received hasPrefix:@"IGNORE"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:received delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }else{
        
        NSString *string = received;
        
        
        NSArray *arr = [string componentsSeparatedByString:@","];
        
        NSInteger mode = [arr[0] integerValue];
        CGFloat f1 = [arr[1] floatValue];
        CGFloat f2 = [arr[2] floatValue];
        
        switch (mode) {
            case 0: // rotation
            {
                self.t1 = f1;
                [self calculateAnchorsCoordinates];
                self.rotationSlider.value = f1;
                break;
            }
                
            case 1:{ // extension
                
                self.r = self.l * f2;
                [self calculateAnchorsCoordinates];
                self.extensionSlider.value = f2;
                break;
            }
                
            case 2:{ // claw
                self.t2 = f1;
                [self calculateAnchorsCoordinates];
                self.wristSlider.value = f1;
                break;
            }
                
            default:
                break;
        }

    }
}

//////////////////////////






- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self setupDynamics];
    [self createAttachments];

    [self setupPeerConectivity];
    
//    static NSString * const XXServiceType = @"simulator";
//    self.myPeerId = [[MCPeerID alloc] initWithDisplayName:@"zaki"];
//    
//    
//    MCNearbyServiceAdvertiser *advertiser =
//    [[MCNearbyServiceAdvertiser alloc] initWithPeer:self.myPeerId
//                                      discoveryInfo:nil
//                                        serviceType:XXServiceType];
//    advertiser.delegate = self;
//    [advertiser startAdvertisingPeer];
}

- (IBAction)rotationSliderUpdated:(id)sender {
    self.t1 = self.rotationSlider.value;
    [self calculateAnchorsCoordinates];
}

- (IBAction)extensionSliderUpdated:(id)sender {
    self.r = self.l * self.extensionSlider.value;
    [self calculateAnchorsCoordinates];
}
- (IBAction)wristSliderUpdated:(id)sender {
    self.t2 = self.wristSlider.value;
    [self calculateAnchorsCoordinates];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
