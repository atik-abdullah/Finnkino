//
//  FKTCommand.h
//  Finnkino
//
//  Created by Abdullah Atik on 10/15/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//

#import <Foundation/Foundation.h>


#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

extern NSString* const FKTEditCommandCompletionNotification;

@interface FKTCommand : NSObject

@property AVMutableComposition *mutableComposition;

- (id)initWithComposition:(AVMutableComposition*)composition;
- (void)performWithAsset:(AVAsset*)asset;

@end

