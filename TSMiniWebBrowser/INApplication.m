//
//  INApplication.m
//  ClickableLinks
//
//  Created by Jesus Victorio on 16/10/13.
//  Copyright (c) 2013 Inbox. All rights reserved.
//

#import "INApplication.h"

#import "OpenInChromeController.h"

NSString *const kPCOpenUrlNotification = @"kPCOpenUrlNotification";
NSString *const kPCOpenUrlNotificationUrlKey = @"kPCOpenUrlNotificationUrlKey";

NSString *const kPCUrlSuffSaf = @"kPCUrlSuffSaf";
NSString *const kPCUrlSuffChr = @"kPCUrlSuffChr";

@interface INApplication ()

@property (nonatomic, strong) OpenInChromeController *openInChromeController;

@end

@implementation INApplication

-(BOOL)openURL:(NSURL *)url inApp:(INOpenUrlType)urlType
{
    if (urlType==INOpenUrlTypeInApp)
    {
        if  ([self.delegate respondsToSelector:@selector(openURL:)])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:kPCOpenUrlNotification
                                                                object:nil
                                                              userInfo:@{kPCOpenUrlNotificationUrlKey:url}];
        }
        
        return YES;
    }
    else if(urlType==INOpenUrlTypeChrome)
    {
        NSURL *callbackURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@://",self.urlScheme]];
        
        if (!self.openInChromeController)
        {
            self.openInChromeController = [[OpenInChromeController alloc] init];
        }
        
        return [self.openInChromeController openInChrome:url
                                         withCallbackURL:callbackURL
                                            createNewTab:YES];
    }
    else
    {
        return [super openURL:url];
    }
}
-(BOOL)openURL:(NSURL *)url
{
    NSString *myString = [url absoluteString];
    NSString *kind =[myString substringWithRange:NSMakeRange([myString length]-kPCUrlSuffChr.length, kPCUrlSuffChr.length)];
    
    if([kind isEqual:kPCUrlSuffSaf])
    {
        NSString *urltemp = [myString substringWithRange:NSMakeRange(0,[myString length]-kPCUrlSuffSaf.length)];
        NSURL *urlend= [[NSURL alloc] initWithString:urltemp];
        
        return [self openURL:urlend inApp:INOpenUrlTypeSafari];
    }
    else if([kind isEqual:kPCUrlSuffChr])
    {
        NSString *urltemp = [myString substringWithRange:NSMakeRange(0,[myString length]-kPCUrlSuffChr.length)];
        NSURL *urlend= [[NSURL alloc] initWithString:urltemp];
        
        return [self openURL:urlend inApp:INOpenUrlTypeChrome];
    }
    else if (([myString rangeOfString:@"googlechrome-x-callback:"].location != NSNotFound) || ([myString rangeOfString:@"googlechrome:"].location != NSNotFound))
    {
        return [self openURL:url inApp:INOpenUrlTypeSafari];
    }
    else
    {
        return [self openURL:url inApp:INOpenUrlTypeInApp];
    }
}

@end
