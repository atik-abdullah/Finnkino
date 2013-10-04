//
//  FinnkinoConnection.m
//  Finnkino
//
//  Created by Abdullah Atik on 9/11/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//

#import "FinnkinoConnection.h"
#import "JSONFirstLevelDict.h"

static NSMutableArray *sharedConnectionList = nil;

@interface FinnkinoConnection ()
@property (nonatomic, strong) NSURLConnection *connection;
@end

@implementation FinnkinoConnection

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
    
    // xmlRootObject determines the delegate for xml parser (in our case which is FinnkinoEvent)
    // xmlRootObject should have been set by FinnkinoFeedStore before making a
    // NSURLConnection connection request which is encapsulated by this class in -(void)start method.
    if([self xmlRootObject])
    {
        // Create a parser with the incoming data and let the root object parse
        // its contents
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:self.xmlData];
        
        // Set the delegate to FinnkinoEvent(xmlRootObject)object
        [parser setDelegate:[self xmlRootObject]];
        
        // Start parsing, delegate FinnkinoEvent will take care of it
        [parser parse];
        
        // After parsing the FinnkinoEvent is in-memory holding the parsed 
        // xml information converted to tree of objects. Grab a copy of that
        // object becuase after it goes out of scope it will be erased from memory
        rootObject = [self xmlRootObject];
    }
    else if([self jsonRootObject])
    {
        // Turn JSON data into model objects
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:self.xmlData
                                                                 options:0
                                                                   error:nil];
        
        // Have the root object pull its data from the dictionary
        [[self jsonRootObject] readFromJSONDictionary:jsonDict];
        rootObject = [self jsonRootObject];
    }
    // Then, pass the grabbed object to the completion block - remember,
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
