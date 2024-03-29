//
//  FinnkinoConnection.h
//  Finnkino
//
//  Created by Abdullah Atik on 9/11/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONSerializable.h"

@interface FinnkinoConnection : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate, NSXMLParserDelegate>

// Request URL to the web service
@property (nonatomic, copy) NSURLRequest *request;

// Completion block, that will be called when parsing is finished
// parameter "obj" is either xmlRootObject or jsonRootObject
@property (nonatomic, strong) void (^completionBlock)(id obj, NSError *err);

// When the web service completes and if data is xml, it parses data in xmlRootObject
@property (nonatomic, strong) id <NSXMLParserDelegate> xmlRootObject;

// When the web service completes and if data is xml, it parses data in jsonRootObject
@property (nonatomic, strong) id <JSONSerializable> jsonRootObject;

// Holds the downloaded data
@property (nonatomic, strong) NSMutableData *xmlData;

// Custom initializer method
- (id)initWithRequest:(NSURLRequest *)req;

// Start to download the data in requested URL
- (void)start;

@end
