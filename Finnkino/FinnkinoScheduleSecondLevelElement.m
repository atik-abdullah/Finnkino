//
//  FinnkinoScheduleSecondLevelElement.m
//  Finnkino
//
//  Created by Abdullah Atik on 9/30/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//

#import "FinnkinoScheduleSecondLevelElement.h"

@interface FinnkinoScheduleSecondLevelElement ()
@property (nonatomic, strong) NSMutableString *currentParsedCharacterData;
@end

@implementation FinnkinoScheduleSecondLevelElement
{
    BOOL _accumulatingParsedCharacterData;
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
        
        self.currentParsedCharacterData = [[NSMutableString alloc] init];
        self.showTitle = self.currentParsedCharacterData;
    }
    else if ([elementName isEqual:@"TheatreAndAuditorium"])
    {
        self.currentParsedCharacterData = [[NSMutableString alloc] init];
        self.theatreAndAuditorium = self.currentParsedCharacterData;
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)str
{
    [self.currentParsedCharacterData appendString:[NSString stringWithFormat:@"%@",str]];
}

- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
{
    if ([elementName isEqual:@"Show"])
    {
        [parser setDelegate:self.parentParserDelegate];
    }
    else if ([elementName isEqual:@"OriginalTitle"])
    {
        NSString *localString = [[NSString alloc] initWithString:self.currentParsedCharacterData];
        self.showTitle = localString;
    }
    _accumulatingParsedCharacterData = NO;
}

@end
