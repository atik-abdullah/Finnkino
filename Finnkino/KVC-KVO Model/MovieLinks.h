#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface MovieLinks : JSONModel

@property (nonatomic, copy) NSString *alternate;
@property (nonatomic, copy) NSString *cast;
@property (nonatomic, copy) NSString *clips;
@property (nonatomic, copy) NSString *reviews;
@property (nonatomic, copy) NSString *linkself;
@property (nonatomic, copy) NSString *similar;

@end
