//
//  FKTCommand.m
//  Finnkino
//
//  Created by Abdullah Atik on 10/15/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//

#import "FKTCommand.h"

NSString* const FKTEditCommandCompletionNotification = @"FKTEditCommandCompletionNotification";

@implementation FKTCommand

- (id)initWithComposition:(AVMutableComposition *)composition
{
	self = [super init];
	if(self != nil)
    {
		self.mutableComposition = composition;
	}
	return self;
}

- (void)performWithAsset:(AVAsset*)asset
{
	[self doesNotRecognizeSelector:_cmd];
}

@end
