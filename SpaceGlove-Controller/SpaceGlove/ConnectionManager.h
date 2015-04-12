//
//  ConnectionManager.h
//  Cleaner
//
//  Created by Muhammad Rashid on 24/09/2014.
//  Copyright (c) 2014 Muhammad Rashid. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ConnectionManagerDelegate.h"

@interface ConnectionManager : NSObject

@property (nonatomic, weak) id<ConnectionManagerDelegate> delegate;
@property (nonatomic, assign, readonly) BOOL isConnected;

+ (ConnectionManager *)sharedConnectionManager;

-(void)setupPeerAndSessionWithDisplayName:(NSString *)displayName;

- (void)connectWithDelegate:(id)delegate withType:(ConnectionType)type;

- (void)startBrowsingWithDelegate:(id)delegate;
-(void)advertiseSelf:(BOOL)shouldAdvertise delegate:(id)delegate;

- (void)sendMessage:(NSString *)message;

- (void)stopPeer2PeerService;

//- (void)bacgroundHandling;

//- (void)terminate;

@end
