//
//  FKTCommand.m
//  Finnkino
//
//  Created by Abdullah Atik on 10/15/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//

#import "FKTCommand.h"

NSString* const FKTEditCommandCompletionNotification = @"FKTEditCommandCompletionNotification";
NSString* const FKTExportCommandCompletionNotification = @"FKTExportCommandCompletionNotification";

@implementation FKTCommand

- (id)initWithComposition:(AVMutableComposition *)composition videoComposition:(AVMutableVideoComposition *)videoComposition audioMix:(AVMutableAudioMix *)audioMix
{
	self = [super init];
	if(self != nil)
    {
		self.mutableComposition = composition;
        self.mutableVideoComposition = videoComposition;
        self.mutableAudioMix = audioMix;
	}
	return self;
}

- (void)performWithAsset:(AVAsset*)asset
{
	[self doesNotRecognizeSelector:_cmd];
}

@end
