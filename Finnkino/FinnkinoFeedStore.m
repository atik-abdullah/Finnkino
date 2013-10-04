//
//  FinnkinoFeedStore.m
//  Finnkino
//
//  Created by Abdullah Atik on 9/11/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//

#import "FinnkinoFeedStore.h"
#import "FinnkinoConnection.h"
#import "FinnkinoEvent.h"
#import "FinnkinoScheduleFirstLevelElement.h"
#import "JSONFirstLevelDict.h"

@implementation FinnkinoFeedStore

+ (FinnkinoFeedStore *)sharedStore
{
    static FinnkinoFeedStore *feedStore = nil;
    if (!feedStore)
        feedStore = [[FinnkinoFeedStore alloc] init];
    return feedStore;
}

- (void)fetchRSSFeedWithCompletion:(void (^)(id obj, NSError *err))block forURLType:(ChangeURLType)URLType
{
    NSURL *url;
    NSURLRequest *req;
    FinnkinoConnection *connection;
    id model;
    
    if (URLType == EventURL)
    {
        // Movie event URL
        url = [NSURL URLWithString:[[NSMutableString alloc] initWithString:@"http://www.finnkino.fi/xml/Events"]];
        // Create an empty channel
        model = [[FinnkinoEvent alloc] init];
    }
    else if (URLType == ShowURL)
    {
        // Schedule URL
        url = [NSURL URLWithString:[[NSMutableString alloc] initWithString:@"http://www.finnkino.fi/xml/Schedule/"]];
        // Create an empty channel
        model = [[FinnkinoScheduleFirstLevelElement alloc] init];
    }
    
    req = [NSURLRequest requestWithURL:url];
    
    // Create a connection "actor" object that will transfer data from the server
    connection = [[FinnkinoConnection alloc] initWithRequest:req];
    
    // When the connection completes, this block from the controller will be executed.
    [connection setCompletionBlock:block];
    
    // Let the empty channel parse the returning data from the web service
    [connection setXmlRootObject:model];
    
    [connection start];
}

- (void)fetchRottenTomatoesMovies:(int)count
                   withCompletion:(void (^)(id obj, NSError *err))block
                       forURLType: (ChangeURLType) URLType
{
    NSURL *url;
    if (URLType == RottenTomatoesBoxOfficeURL)
    {
        url = [NSURL URLWithString:[NSString stringWithFormat:
                                    @"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=43txzxgnzhrpwxrnbeam9dxa&limit=%d", count]];
    }
    else if (URLType == RottenTomatoesUpcomingURL)
    {
        url = [NSURL URLWithString:[NSString stringWithFormat:
                                    @"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/upcoming.json?apikey=43txzxgnzhrpwxrnbeam9dxa&limit=%d", count]];
    }
    else if (URLType == RottenTomatoesSearchURL)
    {
        url = [NSURL URLWithString:[NSString stringWithFormat:
                                    @"http://api.rottentomatoes.com/api/public/v1.0/movies.json?apikey=43txzxgnzhrpwxrnbeam9dxa&q=sky&limit=%d", count]];
    }
    else if (URLType == SelfMovieURL)
    {
        url = [NSURL URLWithString:[NSString stringWithFormat:
                                    @"http://api.rottentomatoes.com/api/public/v1.0/movies.json?apikey=43txzxgnzhrpwxrnbeam9dxa&q=sky&limit=%d", count]];
    }
    // Prepare a request URL, including the argument from the controller
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    
    // Set up the connection
    JSONFirstLevelDict *channel = [[JSONFirstLevelDict alloc] init];
    FinnkinoConnection *connection = [[FinnkinoConnection alloc] initWithRequest:req];
    [connection setCompletionBlock:block];
    [connection setJsonRootObject:channel];
    
    // Start
    [connection start];
}

- (void)fetchRottenTomatoesMoviesWithCompletion:(void (^)(id obj, NSError *err))block
                                         forURL: (NSString *) str
{
    NSString *stringWithParameter = [[NSString alloc] init];
    stringWithParameter = [stringWithParameter stringByAppendingString:str];
    stringWithParameter = [stringWithParameter stringByAppendingString:@"?apikey=43txzxgnzhrpwxrnbeam9dxa"];
    
    NSURL *url;
    url = [NSURL URLWithString:[NSString stringWithString:stringWithParameter]];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    JSONFirstLevelDict *channel = [[JSONFirstLevelDict alloc] init];
    
    FinnkinoConnection *connection = [[FinnkinoConnection alloc] initWithRequest:req];
    [connection setCompletionBlock:block];
    [connection setJsonRootObject:channel];
    
    [connection start];
}

@end
