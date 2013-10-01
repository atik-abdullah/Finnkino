//
//  FinnkinoFeedStore.h
//  Finnkino
//
//  Created by Abdullah Atik on 9/11/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FinnkinoEvent;

typedef enum {
    EventURL = 1,
    ShowURL = 2,
    RottenTomatoesBoxOfficeURL = 3,
    RottenTomatoesUpcomingURL = 4,
    RottenTomatoesSearchURL =5,
    SelfMovieURL = 6,
}ChangeURLType;

@interface FinnkinoFeedStore : NSObject

+ (FinnkinoFeedStore *)sharedStore;

- (void)fetchRSSFeedWithCompletion:(void (^)(id obj, NSError *err))block
                        forURLType: (ChangeURLType) URLType;

- (void)fetchRottenTomatoesMovies:(int)count withCompletion:(void (^)(id obj, NSError *err))block forURLType: (ChangeURLType) URLType;

@end
