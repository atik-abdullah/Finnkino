#import "Movie.h"

#import "AbridgedCast.h"
#import "AbridgedDirector.h"
#import "MovieAlternateIds.h"
#import "MovieLinks.h"
#import "MoviePosters.h"
#import "MovieRatings.h"
#import "MovieReleaseDates.h"

@implementation Movie

- (void)setValue:(id)value forKey:(NSString *)key {

    if ([key isEqualToString:@"abridged_cast"]) {

        if ([value isKindOfClass:[NSArray class]]) {

            NSMutableArray *myMembers = [NSMutableArray arrayWithCapacity:[value count]];
            for (id valueMember in value) {
                AbridgedCast *populatedMember = [[AbridgedCast alloc] initWithDictionary:valueMember];
                [myMembers addObject:populatedMember];
            }

            self.abridgedCast = myMembers;

        }

    }else if ([key isEqualToString:@"abridged_directors"]) {
        
        if ([value isKindOfClass:[NSArray class]]) {
            
            NSMutableArray *myMembers = [NSMutableArray arrayWithCapacity:[value count]];
            for (id valueMember in value) {
                AbridgedDirector *populatedMember = [[AbridgedDirector alloc] initWithDictionary:valueMember];
                [myMembers addObject:populatedMember];
            }
            
            self.abridgedCast = myMembers;
            
        }
        
    }else if ([key isEqualToString:@"genres"]) {
        
        if ([value isKindOfClass:[NSArray class]]) {
            
            NSMutableArray *myMembers = [NSMutableArray arrayWithCapacity:[value count]];
            for (id valueMember in value) {
                [myMembers addObject:valueMember];
            }
            
            self.genres = myMembers;
            
        }
        
    }    
    else if ([key isEqualToString:@"alternate_ids"]) {

        if ([value isKindOfClass:[NSDictionary class]]) {
            self.alternateIds = [[MovieAlternateIds alloc] initWithDictionary:value];
        }

    } else if ([key isEqualToString:@"links"]) {

        if ([value isKindOfClass:[NSDictionary class]]) {
            self.links = [[MovieLinks alloc] initWithDictionary:value];
        }

    } else if ([key isEqualToString:@"posters"]) {

        if ([value isKindOfClass:[NSDictionary class]]) {
            self.posters = [[MoviePosters alloc] initWithDictionary:value];
        }

    } else if ([key isEqualToString:@"ratings"]) {

        if ([value isKindOfClass:[NSDictionary class]]) {
            self.ratings = [[MovieRatings alloc] initWithDictionary:value];
        }

    } else if ([key isEqualToString:@"release_dates"]) {

        if ([value isKindOfClass:[NSDictionary class]]) {
            self.releaseDates = [[MovieReleaseDates alloc] initWithDictionary:value];
        }

    } else {
        [super setValue:value forKey:key];
    }

}


- (void)setValue:(id)value forUndefinedKey:(NSString *)key {

    if ([key isEqualToString:@"abridged_cast"]) {
        [self setValue:value forKey:@"abridgedCast"];
    } else if ([key isEqualToString:@"alternate_ids"]) {
        [self setValue:value forKey:@"alternateIds"];
    } else if ([key isEqualToString:@"critics_consensus"]) {
        [self setValue:value forKey:@"criticsConsensus"];
    } else if ([key isEqualToString:@"id"]) {
        [self setValue:value forKey:@"movieId"];
    } else if ([key isEqualToString:@"mpaa_rating"]) {
        [self setValue:value forKey:@"mpaaRating"];
    } else if ([key isEqualToString:@"release_dates"]) {
        [self setValue:value forKey:@"releaseDates"];
    } else {
        [super setValue:value forUndefinedKey:key];
    }

}



@end
