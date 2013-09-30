//
//  FinnkinoScheduleFirstLevelElement.m
//  Finnkino
//
//  Created by Abdullah Atik on 9/30/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//

#import "FinnkinoScheduleFirstLevelElement.h"
#import "FinnkinoScheduleSecondLevelElement.h"

@implementation FinnkinoScheduleFirstLevelElement

- (id)init
{
    
    self = [super init];
    if (self)
    {
        self.showItems = [[NSMutableArray alloc] init];
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
    if ([elementName isEqual:@"Show"])
    {
        FinnkinoScheduleSecondLevelElement *showTime = [[FinnkinoScheduleSecondLevelElement alloc] init];
       
        // Set up its parent as ourselves so we can regain control of the parser
        [showTime setParentParserDelegate:self];
        
        // Turn the parser to the RSSItem
        [parser setDelegate:showTime];
        
        // Add the item to our array and release our hold on it
        [self.showItems addObject:showTime];
    }
}

@end
