#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface MoviePosters : JSONModel

@property (nonatomic, copy) NSString *detailed;
@property (nonatomic, copy) NSString *original;
@property (nonatomic, copy) NSString *profile;
@property (nonatomic, copy) NSString *thumbnail;

@end
