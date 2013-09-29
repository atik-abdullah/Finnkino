//
//  FinnkinoMovieContentDescriptor.m
//  Finnkino
//
//  Created by Abdullah Atik on 1/16/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//

#import "FinnkinoMovieContentDescriptor.h"

@interface FinnkinoMovieContentDescriptor ()
@property (nonatomic, strong) NSMutableString *currentString;
@end

@implementation FinnkinoMovieContentDescriptor

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qualifiedName
    attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqual:@"ImageURL"])
    {
        self.currentString = [[NSMutableString alloc] init];
        self.contentURL = self.currentString;
    }
}

- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
{
    // If the element that ended was the channel, give up control to
    // who gave us control in the first place
    self.currentString = nil;
    
    if ([elementName isEqual:@"ContentDescriptor"])
    {
        [parser setDelegate:self.parentParserDelegate];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)str
{
    [self.currentString appendString:[NSString stringWithFormat:@"%@",str]];
}

@end
