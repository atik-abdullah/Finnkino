//
//  FinnkinoFeedStore.h
//  Finnkino
//
//  Created by Abdullah Atik on 9/11/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class FinnkinoEvent;
@class JSONSecondLevelDict;

typedef enum {
    EventURL = 1,
    ShowURL = 2,
    RottenTomatoesBoxOfficeURL = 3,
    RottenTomatoesUpcomingURL = 4,
    RottenTomatoesSearchURL =5,
    SelfMovieURL = 6,
}ChangeURLType;

typedef enum {
    HaveWatched = 1,
    WantToWatch = 2,
    Favorite = 3,
}FavoriteType;

@interface FinnkinoFeedStore : NSObject

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSManagedObjectContext *context;

+ (FinnkinoFeedStore *)sharedStore;

- (void)fetchRSSFeedWithCompletion:(void (^)(id obj, NSError *err))block
                        forURLType: (ChangeURLType) URLType;

- (void)fetchRottenTomatoesMovies:(int)count withCompletion:(void (^)(id obj, NSError *err))block forURLType: (ChangeURLType) URLType;

- (void)fetchRottenTomatoesMoviesWithCompletion:(void (^)(id obj, NSError *err))block
                                         forURL: (NSString *) str;

- (FinnkinoFeedStore *)createItem:(NSDictionary *) item
                  ForFavoriteType:(FavoriteType) favoriteType;
- (BOOL)saveChanges;

- (void)removeItem:(NSArray *) arrayOfIndexPaths;


@end
