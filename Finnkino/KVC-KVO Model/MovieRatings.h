#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface MovieRatings : JSONModel

@property (nonatomic, copy) NSString *audienceRating;
@property (nonatomic, copy) NSNumber *audienceScore;
@property (nonatomic, copy) NSString *criticsRating;
@property (nonatomic, copy) NSNumber *criticsScore;

@end
