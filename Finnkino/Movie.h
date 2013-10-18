//
//  Movie.h
//  Finnkino
//
//  Created by Abdullah Atik on 10/17/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Movie : NSManagedObject

@property (nonatomic, retain) NSString * abridgedCast;
@property (nonatomic, retain) NSString * genres;
@property (nonatomic, retain) NSNumber * favoriteCategory;
@property (nonatomic, retain) NSString * movieId;
@property (nonatomic, retain) NSString * detailed;
@property (nonatomic, retain) NSString * original;
@property (nonatomic, retain) NSString * profile;
@property (nonatomic, retain) NSString * thumbnail;
@property (nonatomic, retain) NSString * audienceRating;
@property (nonatomic, retain) NSString * audienceScore;
@property (nonatomic, retain) NSString * criticsRating;
@property (nonatomic, retain) NSString * criticsScore;
@property (nonatomic, retain) NSString * runtime;
@property (nonatomic, retain) NSString * synopsis;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * year;

@end
