//
//  JSONModel.m
//  testkvc
//
//  Created by Abdullah Atik on 10/3/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//

#import "JSONModel.h"

@implementation JSONModel

- (id) initWithDictionary:(NSMutableDictionary*) jsonObject
{
    if(self = [super init])
    {
        self = [self init];
        [self setValuesForKeysWithDictionary:jsonObject];
    }
    return self;
}

@end
