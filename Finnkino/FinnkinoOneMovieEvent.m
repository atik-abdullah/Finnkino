//
//  FinnkinoOneMovieEvent.m
//  Finnkino
//
//  Created by Abdullah Atik on 9/10/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//

#import "FinnkinoOneMovieEvent.h"
#import "FinnkinoMovieContentDescriptor.h"

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
        self.movieSmallImagePortraitURL = [[NSMutableString alloc] init];
        self.movieMicroImagePortraitURL = [[NSMutableString alloc] init];
        self.movieLargeImagePortraitURL = [[NSMutableString alloc] init];
        self.movieSmallImageLandscapeURL = [[NSMutableString alloc] init];
        self.movieLargeImageLandscapeURL = [[NSMutableString alloc] init];
        self.contentDescriptorItems = [[NSMutableArray alloc] init];
        self.movieTrailerURL = [[NSMutableString alloc] init];
    }
    return self;
}

- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qualifiedName
    attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqual:@"OriginalTitle"]||[elementName isEqual:@"EventSmallImagePortrait"]||[elementName isEqual:@"EventLargeImagePortrait"]||[elementName isEqual:@"EventSmallImageLandscape"]||[elementName isEqual:@"EventLargeImageLandscape"]||[elementName isEqual:@"Location"])
    {
        // The contents are collected in parser:foundCharacters:.
        _accumulatingParsedCharacterData = YES;
        
        // The mutable string needs to be reset to empty.
        [self.currentParsedCharacterData setString:@""];
    }
    
    else if ([elementName isEqual:@"ContentDescriptor"])
    {
        FinnkinoMovieContentDescriptor *contentDescriptorEvent = [[FinnkinoMovieContentDescriptor alloc] init];
        // Set up its parent as ourselves so we can regain control of the parser
        [contentDescriptorEvent setParentParserDelegate:self];
        [parser setDelegate:contentDescriptorEvent];
        [self.contentDescriptorItems addObject:contentDescriptorEvent];
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
        [self setMovieSmallImagePortraitURL:localString];
    }
    else if ([elementName isEqual:@"EventMicroImagePortrait"])
    {
        NSString *localString = [[NSString alloc] initWithString:self.currentParsedCharacterData];
        [self setMovieMicroImagePortraitURL:localString];
    }
    else if ([elementName isEqual:@"EventLargeImagePortrait"])
    {
        NSString *localString = [[NSString alloc] initWithString:self.currentParsedCharacterData];
        [self setMovieLargeImagePortraitURL:localString];
    }
    else if ([elementName isEqual:@"EventSmallImageLandscape"])
    {
        NSString *localString = [[NSString alloc] initWithString:self.currentParsedCharacterData];
        [self setMovieSmallImageLandscapeURL:localString];
    }
    else if ([elementName isEqual:@"EventLargeImageLandscape"])
    {
        NSString *localString = [[NSString alloc] initWithString:self.currentParsedCharacterData];
        [self setMovieLargeImageLandscapeURL:localString ];
    }
    else if ([elementName isEqual:@"Location"])
    {
        NSMutableString *localString = [[NSMutableString alloc] initWithString:self.currentParsedCharacterData];
        self.movieTrailerURL = localString;
    }
    _accumulatingParsedCharacterData = NO;
}

- (NSComparisonResult)nameAscCompare:(FinnkinoOneMovieEvent *)fkv
{
	return [self.title caseInsensitiveCompare:[fkv title]];
}

#pragma mark- Cache

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.movieMicroImagePortraitURL forKey:@"movieMicroImagePortraitURL"];
    [aCoder encodeObject:self.movieSmallImagePortraitURL forKey:@"movieSmallImagePortraitURL"];
    [aCoder encodeObject:self.movieLargeImagePortraitURL forKey:@"movieLargeImagePortraitURL"];
    [aCoder encodeObject:self.movieSmallImageLandscapeURL forKey:@"movieSmallImageLandscapeURL"];
    [aCoder encodeObject:self.movieLargeImageLandscapeURL forKey:@"movieLargeImageLandscapeURL"];
    [aCoder encodeObject:self.contentDescriptorItems forKey:@"contentDescriptorItems"];
    [aCoder encodeObject:self.movieTrailerURL forKey:@"movieTrailerURL"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        [self setTitle:[aDecoder decodeObjectForKey:@"title"]];
        [self setMovieMicroImagePortraitURL:[aDecoder decodeObjectForKey:@"movieMicroImagePortraitURL"]];
        [self setMovieSmallImagePortraitURL:[aDecoder decodeObjectForKey:@"movieSmallImagePortraitURL"]];
        [self setMovieLargeImagePortraitURL:[aDecoder decodeObjectForKey:@"movieLargeImagePortraitURL"]];
        [self setMovieSmallImageLandscapeURL:[aDecoder decodeObjectForKey:@"movieSmallImageLandscapeURL"]];
        [self setMovieLargeImageLandscapeURL:[aDecoder decodeObjectForKey:@"movieLargeImageLandscapeURL"]];
        [self setContentDescriptorItems:[aDecoder decodeObjectForKey:@"contentDescriptorItems"]];
        [self setMovieTrailerURL:[aDecoder decodeObjectForKey:@"movieTrailerURL"]];
    }
    return self;
}

@end
