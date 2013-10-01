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

- (void)readFromJSONDictionary:(NSDictionary *)d
{
    self.jsonTitle = [d objectForKey:@"title"];
    self.postersOriginal = [[d objectForKey:@"posters"] objectForKey:@"original"];
    self.postersThumbnail = [[d objectForKey:@"posters"] objectForKey:@"thumbnail"];
    self.postersDetailed = [[d objectForKey:@"posters"] objectForKey:@"detailed"];
    
    self.releseDatesTheater = [[d objectForKey:@"release_dates"] objectForKey:@"theater"];
    
    int  aRuntime = [[d objectForKey:@"runtime"] intValue]/60;
    int  bRuntime = [[d objectForKey:@"runtime"] intValue]%60;
    
    NSString *prepareString = [NSString stringWithFormat:@"%d",aRuntime];
    prepareString = [prepareString stringByAppendingString:@"hr "];
    prepareString = [prepareString stringByAppendingString:[NSString stringWithFormat:@"%d",bRuntime]];
    prepareString = [prepareString stringByAppendingString:@" min"];
    
    self.runtime = prepareString;
    
    self.criticsRating = [[d objectForKey:@"ratings"] objectForKey:@"critics_rating"];
    self.audienceRating = [[d objectForKey:@"ratings"] objectForKey:@"audience_rating"];
    NSNumber * aNumb =[[d objectForKey:@"ratings"] objectForKey:@"critics_score"];
    self.criticsScore = [aNumb stringValue];
    NSNumber * bNumb =[[d objectForKey:@"ratings"] objectForKey:@"audience_score"];
    self.audienceScore = [bNumb stringValue];
    
    NSArray *starring = [d objectForKey:@"abridged_cast"];
    
    for(NSDictionary *anActor in starring)
    {
        JSONThirdLevelDict *i = [[JSONThirdLevelDict alloc] init];
        
        // Pass the entry dictionary to the item so it can grab its ivars
        [i readFromJSONDictionary:anActor];
        [self.castItems addObject:i];
    }
    
    self.linksSelf = [[d objectForKey:@"links"] objectForKey:@"self"];
    
    
}

@end
