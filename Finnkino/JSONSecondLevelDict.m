//
//  JSONSecondLevelElement.m
//  Finnkino
//
//  Created by Abdullah Atik on 9/30/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//

#import "JSONSecondLevelDict.h"
#import "JSONThirdLevelDict.h"

@interface JSONSecondLevelDict ()

@end

@implementation JSONSecondLevelDict

- (id)init
{
    self = [super init];
    if (self)
    {
        self.castItems = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)readFromJSONDictionary:(NSDictionary *)d
{
    self.jsonTitle = [d objectForKey:@"title"];

    // Poster
    JSONThirdLevelDict *postersElement = [[JSONThirdLevelDict alloc] init];
    [postersElement readFromJSONDictionary:[d objectForKey:@"posters"]];
    self.postersOriginal = postersElement;
    self.postersProfile = postersElement;
    self.postersThumbnail = postersElement;
    self.postersDetailed = postersElement;
    
    // Rlease date
    JSONThirdLevelDict *releaseDate = [[JSONThirdLevelDict alloc] init];
    [releaseDate readFromJSONDictionary:[d objectForKey:@"release_dates"]];
    self.releaseDatesElement = releaseDate;
    
    // Runtime
    int  aRuntime = [[d objectForKey:@"runtime"] intValue]/60;
    int  bRuntime = [[d objectForKey:@"runtime"] intValue]%60;
    NSString *prepareString = [NSString stringWithFormat:@"%d",aRuntime];
    prepareString = [prepareString stringByAppendingString:@"hr "];
    prepareString = [prepareString stringByAppendingString:[NSString stringWithFormat:@"%d",bRuntime]];
    prepareString = [prepareString stringByAppendingString:@" min"];
    self.runtime = prepareString;
    
    // Rating
    JSONThirdLevelDict *ratingElement = [[JSONThirdLevelDict alloc] init];
    [ratingElement readFromJSONDictionary:[d objectForKey:@"ratings"]];
    self.criticsRatingElement = ratingElement;
    self.criticsScoreElement = ratingElement;
    self.audienceRatingElement = ratingElement;
    self.audienceScoreElement = ratingElement;

    // Link to this Movie
    JSONThirdLevelDict *linkElement = [[JSONThirdLevelDict alloc] init];
    [linkElement readFromJSONDictionary:[d objectForKey:@"links"]];
    self.linkSelfElement = linkElement;
    
    // Actors
    NSArray *starring = [d objectForKey:@"abridged_cast"];
    for(NSDictionary *anActor in starring)
    {
        JSONThirdLevelDict *i = [[JSONThirdLevelDict alloc] init];
        
        // Pass the entry dictionary to the item so it can grab its ivars
        [i readFromJSONDictionary:anActor];
        [self.castItems addObject:i];
    }
}

@end
