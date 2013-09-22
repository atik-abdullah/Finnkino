//
//  FinnkinoEvent.m
//  Finnkino
//
//  Created by Abdullah Atik on 9/10/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//

#import "FinnkinoEvent.h"
#import "FinnkinoOneMovieEvent.h"

@interface FinnkinoEvent ()
@property (nonatomic, strong) NSMutableString *currentString;
@end

@implementation FinnkinoEvent
@synthesize movieItems;
@synthesize parentParserDelegate;
@synthesize sortedMovieItems;

- (id)init
{
    self = [super init];
    if (self)
    {
        // Create the container for the RSSItems this channel has;
        // we'll create the RSSItem class shortly.
        self.movieItems = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qualifiedName
    attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqual:@"Event"])
    {
        // When we find an item, create an instance of FinnkinoOneMovieEvent
        self.movieEvent = [[FinnkinoOneMovieEvent alloc] init];
        
        // Set up its parent as ourselves so we can regain control of the parser
        [self.movieEvent setParentParserDelegate:self];
        
        // Turn the parser to the RSSItem
        [parser setDelegate:self.movieEvent];
        
        // Add the item to our array and release our hold on it
        [self.movieItems addObject:self.movieEvent];
        self.sortedMovieItems = [self.movieItems sortedArrayUsingSelector:@selector(nameAscCompare:)];
    }
    
}

- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
{
    // If we were in an element that we were collecting the string for,
    // this appropriately releases our hold on it and the permanent ivar keeps
    // ownership of it. If we weren't parsing such an element, currentString
    // is nil already.
    self.currentString = nil;
    // If the element that ended was the channel, give up control to
    // who gave us control in the first place
    if ([elementName isEqual:@"Event"])
        [parser setDelegate:parentParserDelegate];
}

@end
