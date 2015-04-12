//
//  ConnectionManager.m
//  Cleaner
//
//  Created by Muhammad Rashid on 24/09/2014.
//  Copyright (c) 2014 Muhammad Rashid. All rights reserved.
//

#import "ConnectionManager.h"
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface ConnectionManager () <MCSessionDelegate, MCBrowserViewControllerDelegate>

@property (nonatomic, strong) MCPeerID *peerID;
@property (nonatomic, strong) MCSession *session;
@property (nonatomic, strong) MCBrowserViewController *browser;
@property (nonatomic, strong) MCAdvertiserAssistant *advertiser;
@property (nonatomic, assign) ConnectionType type;

@end

@implementation ConnectionManager {
    NSTimer *_waitingTimer;
    UILocalNotification *_expireNotification;
    UIBackgroundTaskIdentifier _taskId;
}

- (BOOL)isConnected {
    
    return _session.connectedPeers.count;
}

- (void)stopPeer2PeerService {
    
    [_advertiser stop];
    _advertiser = nil;
    _browser = nil;
}

-(id)init{
    
    self = [super init];
    
    if (self) {
        [self setupPeerAndSessionWithDisplayName:[UIDevice currentDevice].name];
        _browser = nil;
        _advertiser = nil;
        _type = ConnectionTypeNone;
    }
    
    return self;
}

#pragma mark - Public methods

+ (ConnectionManager *)sharedConnectionManager {
    
    static ConnectionManager* sharedInstance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance=[[ConnectionManager alloc] init];
    });
    return sharedInstance;
}

-(void)setupPeerAndSessionWithDisplayName:(NSString *)displayName {
    
    _peerID = nil;
    _session = nil;
    
    _peerID = [[MCPeerID alloc] initWithDisplayName:@"zaki"];
    
    _session = [[MCSession alloc] initWithPeer:_peerID];
    _session.delegate = self;
}

- (void)connectWithDelegate:(id)delegate withType:(ConnectionType)type {
    
    _delegate = delegate;
    _type = type;
    
    if (_advertiser == nil) {
        
        _advertiser = [[MCAdvertiserAssistant alloc] initWithServiceType:CleanerService
                                                           discoveryInfo:nil
                                                                 session:_session];
        [_advertiser start];
    }
    if (_browser == nil) {
        
        _browser = [[MCBrowserViewController alloc] initWithServiceType:CleanerService session:_session];
        _browser.delegate = self;
    }
    
    if (type == ConnectionTypeBrowser) {
        [(UIViewController *)delegate presentViewController:_browser animated:YES completion:nil];
    }
}

-(void)advertiseSelf:(BOOL)shouldAdvertise delegate:(id)delegate {
    
    _type = ConnectionTypeAdvertiser;
    _delegate = delegate;
    
    if (shouldAdvertise) {
        
        _advertiser = [[MCAdvertiserAssistant alloc] initWithServiceType:CleanerService
                                                           discoveryInfo:nil
                                                                 session:_session];
        [_advertiser start];
    }
    else{
        [_advertiser stop];
        _advertiser = nil;
    }
}

- (void)startBrowsingWithDelegate:(id)delegate {
    
    _type = ConnectionTypeBrowser;
    _delegate = delegate;
    
    if (_browser == nil) {
        _browser = [[MCBrowserViewController alloc] initWithServiceType:CleanerService session:_session];
        _browser.delegate = self;
    }
    [(UIViewController *)delegate presentViewController:_browser animated:YES completion:nil];
}

- (void)sendMessage:(NSString *)message {
    
    NSData *textData = [message dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"Send Data: %@", message);
    NSError *error = nil;
    
    [_session sendData:textData
               toPeers:_session.connectedPeers
              withMode:MCSessionSendDataReliable
                 error:&error];
    
    [_waitingTimer invalidate];
    _waitingTimer = nil;
    
    if (error) {
        [self session:_session peer:nil didChangeState:MCSessionStateNotConnected];
        NSLog(@"error %@", error.userInfo);
        NSLog(@"%@",[error localizedDescription]);
    } else {
        _waitingTimer = [NSTimer scheduledTimerWithTimeInterval:20.0 target:self selector:@selector(sendDammyData) userInfo:nil repeats:NO];
    }
}

#pragma mark - Private methods

- (void)sendDammyData {
    [self sendMessage:[NSString stringWithFormat:@"IGNORE:%f",[[NSDate date] timeIntervalSince1970]]];
}

#pragma mark - MCBrowserViewControllerDelegate

// Notifies the delegate, when the user taps the done button
- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController {
    
    if (_delegate && [_delegate respondsToSelector:@selector(didConntectedWithManager:status:)]) {
        
        NSDictionary *dict = @{@"peerID": _peerID,
                               @"state" : [NSNumber numberWithInt:MCSessionStateConnected]
                               };
        [_delegate didConntectedWithManager:self status:dict];
    }
    
    [_browser dismissViewControllerAnimated:YES completion:nil];
}

// Notifies delegate that the user taps the cancel button.
- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController {
    [_browser dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - MCSessionDelegate

// Remote peer changed state
- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state {

    if (state != MCSessionStateConnecting) {
        
        NSDictionary *dict = @{@"peerID": peerID,
                               @"state" : [NSNumber numberWithInt:state]
                               };
        
        NSLog(@"%@",peerID.displayName);
        
        if (state == MCSessionStateConnected) {
            
            if ([_delegate respondsToSelector:@selector(willConntectedWithManager:status:)]) {
                [_delegate willConntectedWithManager:self status:dict];
            }
        }
        else {
            
            if (_delegate && [_delegate respondsToSelector:@selector(didDisconntectedWithManager:status:)]) {
                [_delegate didDisconntectedWithManager:self status:dict];
            }
            
            [self stopPeer2PeerService];
        }
    }
}

// Received data from remote peer
- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID {
    
    NSString *message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"Receive Data: %@", message);
    
    //  append message to text box:
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([_delegate respondsToSelector:@selector(connectionManager:receivedString:)]) {
            [_delegate connectionManager:self receivedString:message];
        }
    });
}

// Received a byte stream from remote peer
- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID {
    
}

// Start receiving a resource from remote peer
- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress {
    
}

// Finished receiving a resource from remote peer and saved the content in a temporary location - the app is responsible for moving the file to a permanent location within its sandbox
- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error {
    
}

- (void) session:(MCSession *)session didReceiveCertificate:(NSArray *)certificate fromPeer:(MCPeerID *)peerID certificateHandler:(void (^)(BOOL accept))certificateHandler
{
    certificateHandler(YES);
}

@end
