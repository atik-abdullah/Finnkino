//
//  FinnkinoOneMovieEvent.m
//  Finnkino
//
//  Created by Abdullah Atik on 9/10/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//

#import "FinnkinoOneMovieEvent.h"

@interface FinnkinoOneMovieEvent ()
@property (nonatomic) NSMutableString *currentParsedCharacterData;
@end

@implementation FinnkinoOneMovieEvent
{
    BOOL _accumulatingParsedCharacterData;
}

@synthesize parentParserDelegate;

- (id)init
{
    self = [super init];
    if (self)
    {
        _currentParsedCharacterData = [[NSMutableString alloc] init];
    }
    return self;
}

- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qualifiedName
    attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqual:@"OriginalTitle"])
    {
    // The contents are collected in parser:foundCharacters:.
    _accumulatingParsedCharacterData = YES;
    // The mutable string needs to be reset to empty.
    [self.currentParsedCharacterData setString:@""];
}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)str
{
    if (_accumulatingParsedCharacterData)
    {
        // If the current element is one whose content we care about, append 'string'
        // to the property that holds the content of the current element.
        //
        [self.currentParsedCharacterData appendString:str];
    }
}

- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
{
    if ([elementName isEqual:@"Title"])
    {
        [self setTitle:self.currentParsedCharacterData];
        NSLog(@"%@ found a %@ element", self, self.title);
    }
    
    if ([elementName isEqual:@"Event"])
    {
        [parser setDelegate:self.parentParserDelegate];
    }
    
    _accumulatingParsedCharacterData = NO;
}

@end
