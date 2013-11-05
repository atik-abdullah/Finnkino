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
{
    BOOL _accumulatingParsedCharacterData;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        self.currentString = [[NSMutableString alloc] init];
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
        _accumulatingParsedCharacterData = YES;
    }
}

- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
{  
    if ([elementName isEqual:@"ContentDescriptor"])
    {
        [parser setDelegate:self.parentParserDelegate];
    }
    else if ([elementName isEqual:@"ImageURL"])
    {
        NSMutableString *localString = [[NSMutableString alloc] initWithString:self.currentString];
        self.contentURL = localString;
    }
    _accumulatingParsedCharacterData = NO;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)str
{
    self.currentString = [[NSMutableString alloc] init];
    [self.currentString appendString:[NSString stringWithFormat:@"%@",str]];
}

#pragma mark- Cache

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.contentURL forKey:@"contentURL"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        self.contentURL = [aDecoder decodeObjectForKey:@"contentURL"];
    }
    return self;
}

@end
