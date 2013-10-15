//
//  FKTTrimCommand.m
//  Finnkino
//
//  Created by Abdullah Atik on 10/16/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//

#import "FKTTrimCommand.h"

@implementation FKTTrimCommand

- (void)performWithAsset:(AVAsset*)asset
{
	AVAssetTrack *assetVideoTrack = nil;
	AVAssetTrack *assetAudioTrack = nil;
	
	// Check if the asset contains video and audio tracks
	if ([[asset tracksWithMediaType:AVMediaTypeVideo] count] != 0)
    {
		assetVideoTrack = [asset tracksWithMediaType:AVMediaTypeVideo][0];
	}
	if ([[asset tracksWithMediaType:AVMediaTypeAudio] count] != 0)
    {
		assetAudioTrack = [asset tracksWithMediaType:AVMediaTypeAudio][0];
	}
	
	
	CMTime insertionPoint = kCMTimeZero;
	NSError *error = nil;
	
	// Trim to half duration
	double halfDuration = CMTimeGetSeconds([asset duration])/2.0;
	CMTime trimmedDuration = CMTimeMakeWithSeconds(halfDuration, 1);
	
	
	// Step 1
	//  Create a composition with the given asset and insert audio and video tracks for half the duration into it from the asset
	if(!self.mutableComposition)
    {
		// Check if a composition already exists, i.e., another tool has been applied
		// Create a new composition
		self.mutableComposition = [AVMutableComposition composition];
		
		// Insert half time range of the video and audio tracks from AVAsset
		if(assetVideoTrack != nil)
        {
			AVMutableCompositionTrack *compositionVideoTrack = [self.mutableComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
			[compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, trimmedDuration) ofTrack:assetVideoTrack atTime:insertionPoint error:&error];
		}
		if(assetAudioTrack != nil)
        {
			AVMutableCompositionTrack *compositionAudioTrack = [self.mutableComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
			[compositionAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, trimmedDuration) ofTrack:assetAudioTrack atTime:insertionPoint error:&error];
		}
	}
    else
    {
		// Remove the second half of the existing composition to trim
		[self.mutableComposition removeTimeRange:CMTimeRangeMake(trimmedDuration, [self.mutableComposition duration])];
	}
	
	// Step 2
	// Notify AVSEViewController about trim operation completion
	[[NSNotificationCenter defaultCenter] postNotificationName:FKTEditCommandCompletionNotification object:self];
}

@end
