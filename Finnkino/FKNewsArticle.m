//
//  FKNewsArticle.m
//  Finnkino
//
//  Created by Abdullah Atik on 10/23/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//

#import "FKNewsArticle.h"

@interface FKNewsArticle ()
@property (nonatomic) NSMutableString *currentParsedCharacterData;
@end

@implementation FKNewsArticle
{
    BOOL _accumulatingParsedCharacterData;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        self.currentParsedCharacterData = [[NSMutableString alloc] init];
        self.newsArticleTitle = [[NSMutableString alloc] init];
        self.newsArticlePublishDate = [[NSMutableString alloc] init];
        self.newsArticleImageURL = [[NSMutableString alloc] init];
        self.newsArticleCategoryName = [[NSMutableString alloc] init];
        self.newsArticleDictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qualifiedName
    attributes:(NSDictionary *)attributeDict
{
 if ([elementName isEqual:@"Title"] ||
     [elementName isEqual:@"ImageURL"]||
     [elementName isEqual:@"PublishDate"]||
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
    if ([elementName isEqual:@"NewsArticle"])
    {
        [parser setDelegate:self.parentParserDelegate];
    }
    else if ([elementName isEqual:@"Title"])
    {
        NSString *localString = [[NSString alloc] initWithString:self.currentParsedCharacterData];
        [self setNewsArticleTitle:localString];
        [self.newsArticleDictionary setObject:self.newsArticleTitle forKey:@"Title"];
    }
    else if ([elementName isEqual:@"ImageURL"])
    {
        NSString *localString = [[NSString alloc] initWithString:self.currentParsedCharacterData];
        [self setNewsArticleImageURL:localString];
        [self.newsArticleDictionary setObject:self.newsArticleImageURL forKey:@"ImageURL"];
    }
    else if ([elementName isEqual:@"PublishDate"])
    {
        NSString *localString = [[NSString alloc] initWithString:self.currentParsedCharacterData];
        [self setNewsArticlePublishDate:localString];
        [self.newsArticleDictionary setObject:self.newsArticlePublishDate forKey:@"PublishDate"];
    }
    else if ([elementName isEqual:@"Name"])
    {
        NSString *localString = [[NSString alloc] initWithString:self.currentParsedCharacterData];
        [self setNewsArticleCategoryName:localString];
        [self.newsArticleDictionary setObject:self.newsArticleCategoryName forKey:@"categoryName"];
    }
    _accumulatingParsedCharacterData = NO;
}

@end
