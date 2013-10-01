//
//  JSONSecondLevelElement.h
//  Finnkino
//
//  Created by Abdullah Atik on 9/30/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONSerializable.h"

@interface JSONSecondLevelDict : NSObject < JSONSerializable >
//JSON Data structure
@property (nonatomic, strong) NSMutableString *postersThumbnail;
@property (nonatomic, strong) NSMutableString *postersProfile;
@property (nonatomic, strong) NSMutableString *postersDetailed;
@property (nonatomic, strong) NSMutableString *postersOriginal;
@property (nonatomic, strong) NSMutableString *jsonTitle;
@property (nonatomic, strong) NSString *criticsScore;
@property (nonatomic, strong) NSMutableString *criticsRating;
@property (nonatomic, strong) NSMutableString *audienceRating;
@property (nonatomic, strong) NSString *audienceScore;
@property (nonatomic, strong) NSMutableArray *castItems;
@property (nonatomic, strong) NSString *releseDatesTheater;
@property (nonatomic, strong) NSString *runtime;
@property (nonatomic, strong) NSString *linksSelf;
@end
