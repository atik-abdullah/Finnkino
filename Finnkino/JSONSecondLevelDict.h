//
//  JSONSecondLevelElement.h
//  Finnkino
//
//  Created by Abdullah Atik on 9/30/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONSerializable.h"

@class JSONThirdLevelDict;
@interface JSONSecondLevelDict : NSObject < JSONSerializable >
//JSON Data structure
@property (nonatomic, strong) NSMutableString *jsonTitle;

@property (nonatomic, strong) NSString *runtime;

// Holds array of third level element
@property (nonatomic, strong) NSMutableArray *castItems;
@property (nonatomic, strong) JSONThirdLevelDict *postersThumbnail;
@property (nonatomic, strong) JSONThirdLevelDict *postersProfile;
@property (nonatomic, strong) JSONThirdLevelDict *postersDetailed;
@property (nonatomic, strong) JSONThirdLevelDict *postersOriginal;
@property (nonatomic, strong) JSONThirdLevelDict *releaseDatesElement;
@property (nonatomic, strong) JSONThirdLevelDict *criticsScoreElement;
@property (nonatomic, strong) JSONThirdLevelDict *criticsRatingElement;
@property (nonatomic, strong) JSONThirdLevelDict *audienceRatingElement;
@property (nonatomic, strong) JSONThirdLevelDict *audienceScoreElement;
@property (nonatomic, strong) JSONThirdLevelDict *linkSelfElement;

@end
