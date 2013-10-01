//
//  JSONThirdLevelDict.m
//  Finnkino
//
//  Created by Abdullah Atik on 9/30/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//

#import "JSONThirdLevelDict.h"

@interface JSONThirdLevelDict ()
//JSON Data structure
@property (nonatomic, strong) NSMutableString *castTitle;
@end

@implementation JSONThirdLevelDict

- (void)readFromJSONDictionary:(NSDictionary *)d
{
    self.castTitle = [d objectForKey:@"name"];
}

@end
