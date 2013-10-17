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
extern NSString* const FKTExportCommandCompletionNotification;

@interface FKTCommand : NSObject

@property AVMutableComposition *mutableComposition;
@property AVMutableVideoComposition *mutableVideoComposition;
@property AVMutableAudioMix *mutableAudioMix;
@property CALayer *watermarkLayer;

- (id)initWithComposition:(AVMutableComposition*)composition videoComposition:(AVMutableVideoComposition *)videoComposition audioMix:(AVMutableAudioMix *)audioMix;
- (void)performWithAsset:(AVAsset*)asset;

@end

