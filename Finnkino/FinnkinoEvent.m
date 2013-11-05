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
@property (nonatomic, strong) FinnkinoOneMovieEvent *movieEvent;
@end

@implementation FinnkinoEvent

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

#pragma mark- Cache

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.movieItems forKey:@"movieItems"];
    [aCoder encodeObject:self.sortedMovieItems forKey:@"sortedMovieItems"];

}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        self.movieItems = [aDecoder decodeObjectForKey:@"movieItems"];
        self.sortedMovieItems = [aDecoder decodeObjectForKey:@"sortedMovieItems"];
    }
    return self;
}

@end
