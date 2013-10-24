//
//  FKNewsArticleCategory.m
//  Finnkino
//
//  Created by Abdullah Atik on 10/23/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//

#import "FKNewsArticleCategory.h"

@interface FKNewsArticleCategory ()
@property (nonatomic) NSMutableString *currentParsedCharacterData;
@end

@implementation FKNewsArticleCategory
{
    BOOL _accumulatingParsedCharacterData;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        self.currentParsedCharacterData = [[NSMutableString alloc] init];
        self.categoryID = [[NSMutableString alloc] init];
        self.categoryName = [[NSMutableString alloc] init];
    }
    return self;
}

- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qualifiedName
    attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqual:@"ID"] ||
        [elementName isEqual:@"Name"])
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
        self.currentParsedCharacterData = [[NSMutableString alloc] init];
        [self.currentParsedCharacterData appendString:str];
    }
}

- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
{
    if ([elementName isEqual:@"NewsArticleCategory"])
    {
        [parser setDelegate:self.parentParserDelegate];
    }
    else if ([elementName isEqual:@"ID"])
    {
        NSString *localString = [[NSString alloc] initWithString:self.currentParsedCharacterData];
        [self setCategoryID:localString];
    }
    else if ([elementName isEqual:@"Name"])
    {
        NSString *localString = [[NSString alloc] initWithString:self.currentParsedCharacterData];
        [self setCategoryName:localString];
    }
    _accumulatingParsedCharacterData = NO;
}

@end
