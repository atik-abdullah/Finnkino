//
//  FinnkinoConnection.m
//  Finnkino
//
//  Created by Abdullah Atik on 9/11/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//

#import "FinnkinoConnection.h"

static NSMutableArray *sharedConnectionList = nil;

@implementation FinnkinoConnection
@synthesize xmlRootObject;
@synthesize request;
@synthesize completionBlock;
@synthesize xmlData;
@synthesize connection;

- (id)initWithRequest:(NSURLRequest *)req
{
    self = [super init];
    
    if (self)
    {
        [self setRequest:req];
    }
    return self;
}

- (void)start
{
    // Initialize container for data collected from NSURLConnection
    self.xmlData = [[NSMutableData alloc] init];
    
    // Spawn connection
    self.connection = [[NSURLConnection alloc] initWithRequest:[self request]
                                                         delegate:self
                                                 startImmediately:YES];
    if (!sharedConnectionList)
        sharedConnectionList = [[NSMutableArray alloc] init];
    [sharedConnectionList addObject:self];
}

#pragma mark - Connection delegate methods

- (void)connection:(NSURLConnection *)conn didReceiveData:(NSData *)data
{
    [self.xmlData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)conn
{
    id rootObject = nil;
    
    // If there is a "root object"
    if([self xmlRootObject])
    {
        // Create a parser with the incoming data and let the root object parse
        // its contents
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:self.xmlData];
        [parser setDelegate:[self xmlRootObject]];
        [parser parse];
        rootObject = [self xmlRootObject];
    }
    
    // Then, pass the root object to the completion block - remember,
    // this is the block that the controller supplied.
    if([self completionBlock])
        [self completionBlock](rootObject, nil);
    
    // Now, destroy this connection
    [sharedConnectionList removeObject:self];
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    // Pass the error from the connection to the completionBlock
    if([self completionBlock])
        [self completionBlock](nil, error);
    
    // Destroy this connection
    [sharedConnectionList removeObject:self];
}

@end
