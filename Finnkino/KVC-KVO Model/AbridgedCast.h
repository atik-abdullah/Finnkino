#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface AbridgedCast : JSONModel 
@property (nonatomic, copy) NSString *abridgedCastId;
@property (nonatomic, copy) NSArray *characters;
@property (nonatomic, copy) NSString *name;

@end
