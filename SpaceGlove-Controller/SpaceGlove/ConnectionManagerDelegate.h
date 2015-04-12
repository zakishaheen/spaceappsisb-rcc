//
//  ConnectionManagerDelegate.h
//  Cleaner
//
//  Created by Muhammad Rashid on 24/09/2014.
//  Copyright (c) 2014 Muhammad Rashid. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ConnectionType) {
    ConnectionTypeBrowser = 1,
    ConnectionTypeAdvertiser = 2,
    ConnectionTypeNone = 3,
};

static NSString *const CleanerService = @"robo-service";

@protocol ConnectionManagerDelegate <NSObject>


@optional
- (void)connectionManager:(id)connectionManager receivedString:(NSString *)received;
- (void)connectionManager:(id)connectionManager receivedSream:(NSInputStream *)received;

- (void)willConntectedWithManager:(id)connectionManager status:(NSDictionary*)stateDic;
- (void)didConntectedWithManager:(id)connectionManager status:(NSDictionary*)stateDic;
- (void)didDisconntectedWithManager:(id)connectionManager status:(NSDictionary*)stateDic;

@end
