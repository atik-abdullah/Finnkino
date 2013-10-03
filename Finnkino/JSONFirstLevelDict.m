//
//  JSONFirstLevelDict.m
//  Finnkino
//
//  Created by Abdullah Atik on 9/30/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//

#import "JSONFirstLevelDict.h"
#import "JSONSecondLevelDict.h"

@interface JSONFirstLevelDict ()

@end

@implementation JSONFirstLevelDict

- (id)init
{
    self = [super init];
    if (self)
    {
        self.movieItems = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)readFromJSONDictionary:(NSDictionary *)d
{
    if ([d objectForKey:@"movies"])
    {
        NSArray *movies = [d objectForKey:@"movies"];
        for(NSDictionary *entry in movies)
        {
            JSONSecondLevelDict *i = [[JSONSecondLevelDict alloc] init];
            
            // Pass the entry dictionary to the item so it can grab its ivars
            [i readFromJSONDictionary:entry];
            [self.movieItems addObject:i];
        }
    }
    else if ([d objectForKey:@"genres"])
    {
        self.movieGenreNames = [d objectForKey:@"genres"];
    }
}

@end
