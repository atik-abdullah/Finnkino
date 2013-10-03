#import <Foundation/Foundation.h>
#import "JSONModel.h"

@class MovieAlternateIds;
@class MovieLinks;
@class MoviePosters;
@class MovieRatings;
@class MovieReleaseDates;

@interface Movie : JSONModel

@property (nonatomic, copy) NSArray *abridgedCast;
@property (nonatomic, copy) NSArray *abridgedDirector;
@property (nonatomic, retain) MovieAlternateIds *alternateIds;
@property (nonatomic, copy) NSString *criticsConsensus;
@property (nonatomic, retain) MovieLinks *links;
@property (nonatomic, copy) NSString *movieId;
@property (nonatomic, copy) NSString *mpaaRating;
@property (nonatomic, copy) NSArray *genres;
@property (nonatomic, copy) NSString *studio;
@property (nonatomic, retain) MoviePosters *posters;
@property (nonatomic, retain) MovieRatings *ratings;
@property (nonatomic, retain) MovieReleaseDates *releaseDates;
@property (nonatomic, copy) id runtime;
@property (nonatomic, copy) NSString *synopsis;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSNumber *year;

@end
