#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface MovieReleaseDates : JSONModel

@property (nonatomic, copy) NSString *dvd;
@property (nonatomic, copy) NSString *theater;

@end
