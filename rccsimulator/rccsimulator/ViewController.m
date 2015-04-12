//
//  ViewController.m
//  rccsimulator
//
//  Created by Zaki Shaheen on 4/11/15.
//  Copyright (c) 2015 Zaki Shaheen. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *armView;
@property (weak, nonatomic) IBOutlet UIView *baseView;
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) UIAttachmentBehavior *originAnchorAttachmentBehavior;
@property (strong, nonatomic) UIAttachmentBehavior *baseAttachmentBehavior;
@property (strong, nonatomic) UIAttachmentBehavior *writeElbowAttachmentBehavior;
@property (strong, nonatomic) UIAttachmentBehavior *wristElbowSliderAttachmentBehavior;
@property (weak, nonatomic) IBOutlet UISlider *armExtensionSlider;


@property (weak, nonatomic) IBOutlet UIView *anchorView;
@property (weak, nonatomic) IBOutlet UISlider *rotationSlider;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.anchorView.center = CGPointMake(self.anchorView.center.x, self.rotationSlider.value);
    
    [self.baseView.layer setCornerRadius:self.baseView.frame.size.width/2];
//    UIPanGestureRecognizer *recog = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
//    UITapGestureRecognizer *recog = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
//    [self.view addGestureRecognizer:recog];

}
- (IBAction)updateRotation:(id)sender {

    [self.wristElbowSliderAttachmentBehavior setAnchorPoint:CGPointMake(self.anchorView.frame.origin.x, self.rotationSlider.value)];
    
//    self.baseView.center = CGPointMake(self.baseView.center.x, self.rotationSlider.value);
//    [self.animator updateItemUsingCurrentState:self.baseView];
}
- (IBAction)armExtensionUpdated:(id)sender {
    CGRect r = self.armView.frame;
    r.size.width = r.size.width - 200;
    
    self.armView.frame = r;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
    UIDynamicAnimator *animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    UIAttachmentBehavior *originPointAttachment = [[UIAttachmentBehavior alloc]
                                             initWithItem:self.baseView
                                             offsetFromCenter:UIOffsetMake(0, 0)
                                             attachedToAnchor:self.baseView.frame.origin];
    originPointAttachment.length = 0;
    originPointAttachment.damping = 1.0;
    
    UIAttachmentBehavior *baseAttachment = [[UIAttachmentBehavior alloc] initWithItem:self.armView
                                                                 offsetFromCenter:UIOffsetMake(-self.armView.frame.size.width/2, 0)
                                                                   attachedToItem:self.baseView
                                                                 offsetFromCenter:UIOffsetMake(0, 0)];
    baseAttachment.length = 0;
    baseAttachment.damping = 1.0;
    
    UIAttachmentBehavior *wristAttachment = [[UIAttachmentBehavior alloc] initWithItem:self.anchorView
                                                                     offsetFromCenter:UIOffsetMake(0, 0)
                                                                       attachedToItem:self.armView
                                                                     offsetFromCenter:UIOffsetMake(self.armView.frame.size.width/2, 0)];
    
    wristAttachment.length = 0;
    wristAttachment.damping = 1;
    
    
    self.wristElbowSliderAttachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:self.anchorView attachedToAnchor:CGPointMake(self.anchorView.frame.origin.x, self.rotationSlider.value)];
    self.wristElbowSliderAttachmentBehavior.length = 0;
    [self.animator addBehavior:self.wristElbowSliderAttachmentBehavior];
    
    
    [animator addBehavior:originPointAttachment];
    [animator addBehavior:baseAttachment];
    [animator addBehavior:wristAttachment];
    [animator addBehavior:self.wristElbowSliderAttachmentBehavior];
    
    
    self.animator = animator;
    self.originAnchorAttachmentBehavior = originPointAttachment;
    self.baseAttachmentBehavior = baseAttachment;
    self.writeElbowAttachmentBehavior = wristAttachment;
    
}


//- (void) move:(UIPanGestureRecognizer *)r{
//    
//    switch (r.state) {
//        case UIGestureRecognizerStateBegan:{
//            
//            break;
//        }
//            
//        case UIGestureRecognizerStateChanged:{
//            [self.touchAttach setAnchorPoint:[r locationInView:self.view]];
//            break;
//        }
//            
//        case UIGestureRecognizerStateEnded:{
//            [self.animator removeBehavior:self.touchAttach];
//            break;
//        }
//            
//        default:
//            break;
//    }
////    [self.baseView setCenter:[r locationInView:self.view]];
////    [self.animator updateItemUsingCurrentState:self.baseView];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
