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

- (id)init
{
    self = [super init];
    if (self)
    {
        self.currentParsedCharacterData = [[NSMutableString alloc] init];
        self.title = [[NSMutableString alloc] init];
        self.movieImageURL = [[NSMutableString alloc] init];
    }
    return self;
}

- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qualifiedName
    attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqual:@"OriginalTitle"]||[elementName isEqual:@"EventSmallImagePortrait"])
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
        [self.currentParsedCharacterData appendString:str];
    }
}

- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
{
    if ([elementName isEqual:@"Event"])
    {
        [parser setDelegate:self.parentParserDelegate];
    }
    else if ([elementName isEqual:@"OriginalTitle"])
    {
        NSString *localString = [[NSString alloc] initWithString:self.currentParsedCharacterData];
        [self setTitle:localString];
    }
    else if ([elementName isEqual:@"EventSmallImagePortrait"])
    {
        NSString *localString = [[NSString alloc] initWithString:self.currentParsedCharacterData];
        self.movieImageURL = localString;
    }
    _accumulatingParsedCharacterData = NO;
}

- (NSComparisonResult)nameAscCompare:(FinnkinoOneMovieEvent *)fkv
{
	return [self.title caseInsensitiveCompare:[fkv title]];
}

@end
