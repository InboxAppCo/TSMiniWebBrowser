//
//  INApplication.h
//  ClickableLinks
//
//  Created by Jesus Victorio on 16/10/13.
//  Copyright (c) 2013 Inbox. All rights reserved.
//

typedef enum  {
	INOpenUrlTypeInApp,
	INOpenUrlTypeSafari,
    INOpenUrlTypeChrome
} INOpenUrlType;

extern NSString *const kPCOpenUrlNotification;
extern NSString *const kPCOpenUrlNotificationUrlKey;

extern NSString *const kPCUrlSuffSaf;
extern NSString *const kPCUrlSuffChr;

@interface INApplication : UIApplication

@property (nonatomic, strong) NSString *urlScheme;

-(BOOL)openURL:(NSURL *)url inApp:(INOpenUrlType)urlType;

@end
