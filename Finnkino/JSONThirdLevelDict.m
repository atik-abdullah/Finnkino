//
//  JSONThirdLevelDict.m
//  Finnkino
//
//  Created by Abdullah Atik on 9/30/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//

#import "JSONThirdLevelDict.h"

@interface JSONThirdLevelDict ()

@end

@implementation JSONThirdLevelDict

- (void)readFromJSONDictionary:(NSDictionary *)d
{
    self.castTitle = [d objectForKey:@"name"];
    
    // Poster Elements
    self.postersOriginal = [d objectForKey:@"original"];
    self.postersThumbnail = [d objectForKey:@"thumbnail"];
    self.postersDetailed = [d objectForKey:@"detailed"];
    self.postersProfile = [d objectForKey:@"profile"];
    self.releaseDatesTheater = [d objectForKey:@"theater"];
    
    // Rating Elements
    self.criticsRating = [d objectForKey:@"critics_rating"];
    self.audienceRating = [d objectForKey:@"audience_rating"];
    self.criticsScore =[d objectForKey:@"critics_score"];
    self.audienceScore =[d objectForKey:@"audience_score"];
    
    // Link to self
    self.linksSelf = [d objectForKey:@"self"];
}

@end
