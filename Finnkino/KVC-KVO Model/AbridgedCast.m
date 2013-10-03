#import "AbridgedCast.h"

@implementation AbridgedCast

- (void)setValue:(id)value forKey:(NSString *)key {

    if ([key isEqualToString:@"characters"]) {

        if ([value isKindOfClass:[NSArray class]]) {

            NSMutableArray *myMembers = [NSMutableArray arrayWithCapacity:[value count]];
            for (id valueMember in value) {
                [myMembers addObject:valueMember];
            }

            self.characters = myMembers;

        }

    } else {
        [super setValue:value forKey:key];
    }

}


- (void)setValue:(id)value forUndefinedKey:(NSString *)key {

    if ([key isEqualToString:@"id"]) {
        [self setValue:value forKey:@"abridgedCastId"];
    } else {
        [super setValue:value forUndefinedKey:key];
    }

}



@end
