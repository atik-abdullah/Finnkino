#import "MovieRatings.h"

@implementation MovieRatings

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {

    if ([key isEqualToString:@"audience_score"]) {
        [self setValue:value forKey:@"audienceScore"];
    } else if ([key isEqualToString:@"critics_rating"]) {
        [self setValue:value forKey:@"criticsRating"];
    }else if ([key isEqualToString:@"audience_rating"]) {
        [self setValue:value forKey:@"audienceRating"];
    }else if ([key isEqualToString:@"critics_score"]) {
        [self setValue:value forKey:@"criticsScore"];
    } else {
        [super setValue:value forUndefinedKey:key];
    }

}



@end
