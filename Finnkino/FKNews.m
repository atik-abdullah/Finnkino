//
//  FKNews.m
//  Finnkino
//
//  Created by Abdullah Atik on 10/23/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//

#import "FKNews.h"
#import "FKNewsArticle.h"
#import "FKNewsArticleCategory.h"

@implementation FKNews

- (id)init
{
    self = [super init];
    if (self)
    {
        self.articleItems = [[NSMutableArray alloc] init];
        self.articleCategoryItems = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark - NSXMLParserDelegate

- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qualifiedName
    attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqual:@"NewsArticle"])
    {
        FKNewsArticle *newsArticle = [[FKNewsArticle alloc] init];
        
        // Set up its parent as ourselves so we can regain control of the parser
        [newsArticle setParentParserDelegate:self];
        
        // Turn the parser to the RSSItem
        [parser setDelegate:newsArticle];
        // Add the item to our array and release our hold on it
        [self.articleItems addObject:newsArticle];
    }
    else if ([elementName isEqual:@"NewsArticleCategory"])
    {
        FKNewsArticleCategory *newsArticleCategory = [[FKNewsArticleCategory alloc] init];
        
        // Set up its parent as ourselves so we can regain control of the parser
        [newsArticleCategory setParentParserDelegate:self];
        
        // Turn the parser to the RSSItem
        [parser setDelegate:newsArticleCategory];
        // Add the item to our array and release our hold on it
        [self.articleCategoryItems addObject:newsArticleCategory];
    }
}

@end
