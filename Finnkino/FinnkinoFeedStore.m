//
//  FinnkinoFeedStore.m
//  Finnkino
//
//  Created by Abdullah Atik on 9/11/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//

#import "FinnkinoFeedStore.h"
#import "FinnkinoConnection.h"
#import "FinnkinoEvent.h"

@implementation FinnkinoFeedStore

+ (FinnkinoFeedStore *)sharedStore
{
    static FinnkinoFeedStore *feedStore = nil;
    if (!feedStore)
        feedStore = [[FinnkinoFeedStore alloc] init];
    return feedStore;
}

- (void)fetchRSSFeedWithCompletion:(void (^)(FinnkinoEvent *obj, NSError *err))block forURLType:(ChangeURLType)URLType
{
    NSURL *url;
    if (URLType == EventURL)
    {
        url = [NSURL URLWithString:[[NSMutableString alloc] initWithString:@"http://www.finnkino.fi/xml/Events"]];
    }
    else if (URLType == ShowURL)
    {
        url = [NSURL URLWithString:[[NSMutableString alloc] initWithString:@"http://www.finnkino.fi/xml/Schedule/"]];
        
    }
    
    // Create an empty channel
    FinnkinoEvent *events = [[FinnkinoEvent alloc] init];
    
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    
    // Create a connection "actor" object that will transfer data from the server
    FinnkinoConnection *connection = [[FinnkinoConnection alloc] initWithRequest:req];
    
    // When the connection completes, this block from the controller will be executed.
    [connection setCompletionBlock:block];
    
    // Let the empty channel parse the returning data from the web service
    [connection setXmlRootObject:events];
    
    [connection start];
}

@end
