#import "MovieLinks.h"

@implementation MovieLinks


- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    if ([key isEqualToString:@"self"]) {
        [self setValue:value forKey:@"linkself"];
    }
}

@end
