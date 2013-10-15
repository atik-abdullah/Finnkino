//
//  FKTrailerEditViewController.m
//  Finnkino
//
//  Created by Abdullah Atik on 10/9/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//

#import "FKTrailerEditViewController.h"
#import "FinnkinoConnection.h"
#import "FKTCommand.h"
#import "FKTTrimCommand.h"
#import "FKTRotateCommand.h"
#import "FKTCropCommand.h"
#import "FKTAddMusicCommand.h"
#import "FKTAddWaterMarkCommand.h"

#define kTrimIndex 0
#define kRotateIndex 1
#define kCropIndex 2
#define kAddMusicIndex 3
#define kAddWatermarkIndex 4

static void *FKTPlayerItemStatusContext = &FKTPlayerItemStatusContext;
static void *FKTPlayerLayerReadyForDisplay = &FKTPlayerLayerReadyForDisplay;

NSString *kStatusKey		= @"status";
NSString *kCurrentItemKey	= @"currentItem";

@interface FKTrailerEditViewController ()

@end

@implementation FKTrailerEditViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.playerView setBackgroundColor:[UIColor blackColor]];
	[[self view] addSubview:self.playerView];
	[[self view] setAutoresizesSubviews:YES];
	[[self playerView] setAutoresizesSubviews:YES];
    
    [self checkIfFileAlreadyDownloaded];
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"playerLayer.readyForDisplay"];
    [self removeObserver:self forKeyPath:@"player.currentItem.status"];
}

#pragma mark - Utility Methods

- (void)fetchEntriesWithRequest:(NSURLRequest *) req
{
    UIView *currentTitleView = [[self navigationItem] titleView];
    UIActivityIndicatorView *aiView = [[UIActivityIndicatorView alloc]
                                       initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [[self navigationItem] setTitleView:aiView];
    [aiView startAnimating];
    
    
    void (^completionBlock)( id obj, NSError *err) = ^(id obj, NSError *err)
    {
        // When the request completes, this block will be called.
        [[self navigationItem] setTitleView:currentTitleView];
        
        if(!err)
        {
            // If everything went ok, grab the data
            if (obj)
            {
                [obj writeToFile:self.filePath atomically:YES];
            }
        }
        else
        {
            // If things went bad, show an alert view
            NSString *errorString = [NSString stringWithFormat:@"Fetch failed: %@",
                                     [err localizedDescription]];
            
            // Create and show an alert view with this error displayed
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error"
                                                         message:errorString
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
            [av show];
        }
    };
    FinnkinoConnection *connection = [[FinnkinoConnection alloc] initWithRequest:req];
    [connection setCompletionBlock:completionBlock];
    [connection start];
}

- (void)checkIfFileAlreadyDownloaded
{
    NSScanner *scanner = [NSScanner scannerWithString:[self.selection objectForKey:@"movieTrailerURL"]];
    
    // Scan past the "http:// " before the magnitude.
    if ([scanner scanString:@"http://" intoString:NULL])
    {
        NSString *location = nil;
        if ([scanner scanUpToCharactersFromSet:
             [NSCharacterSet illegalCharacterSet] intoString:&location])
        {
            // fin.clip-1.filmtrailer.com/11195_41463_a_6.mp4 remove the slash "/" from the string
            // otherwise it will be treated as file under directory "fin.clip-1.filmtrailer.com"
            NSArray * array = [location componentsSeparatedByString:@"/"];
            if (array)
            {
                self.fileName = (NSString *)[array lastObject]; //or whichever the index
                if (self.fileName)
                {
                    [self constructFilePath];
                }
            }
        }
    }
    if (![[NSFileManager defaultManager] fileExistsAtPath:self.filePath])
    {
        NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:[self.selection objectForKey:@"movieTrailerURL"]]];
        [self fetchEntriesWithRequest:req];
    }
}

- (void)constructFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString  *documentsDirectory = [paths objectAtIndex:0];
    self.filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,self.fileName];
}

#pragma mark - Notifications

- (void)editCommandCompletionNotificationReceiver:(NSNotification*) notification
{
	if ([[notification name] isEqualToString:FKTEditCommandCompletionNotification])
    {
		// Update the document's composition, video composition etc
		self.composition = [[notification object] mutableComposition];
        self.videoComposition = [[notification object] mutableVideoComposition];
		self.audioMix = [[notification object] mutableAudioMix];
		if([[notification object] watermarkLayer])
			self.watermarkLayer = [[notification object] watermarkLayer];

		dispatch_async( dispatch_get_main_queue(), ^{
			[self reloadPlayerView];
		});
	}
}

#pragma mark - IBAction methods

- (IBAction)loadMovieButtonPressed:(id)sender
{
	AVAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:self.filePath] options:nil];
    
	// Load the values of AVAsset keys to inspect subsequently
	NSArray *assetKeysToLoadAndTest = @[@"playable", @"composable", @"tracks", @"duration"];
    
    // Tells the asset to load the values of any of the specified keys that are not already loaded.
	[asset loadValuesAsynchronouslyForKeys:assetKeysToLoadAndTest completionHandler:
	 ^{
		 dispatch_async( dispatch_get_main_queue(),
						^{
							// IMPORTANT: Must dispatch to main queue in order to operate on the AVPlayer and AVPlayerItem.
							[self setUpPlaybackOfAsset:asset withKeys:assetKeysToLoadAndTest];
						});
	 }];
    
    self.inputAsset = asset;

	// Create AVPlayer, add rate and status observers
	[self setPlayer:[[AVPlayer alloc] init]];
	[self addObserver:self forKeyPath:@"player.currentItem.status" options:NSKeyValueObservingOptionNew context:FKTPlayerItemStatusContext];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(editCommandCompletionNotificationReceiver:)
												 name:FKTEditCommandCompletionNotification
											   object:nil];
    
}

- (IBAction)playPauseToggle:(id)sender
{
	if ([[self player] rate] != 1.f)
    {
		if ([self currentTime] == [self duration])
			[self setCurrentTime:0.f];
		[[self player] play];
	}
    else
    {
		[[self player] pause];
	}
}

- (IBAction)edit:(id)sender
{
	int tag = [sender tag];
	// Disable the operation just selected
	[sender setEnabled:NO];
	
	FKTCommand *editCommand;
	
	switch (tag)
    {
		case kTrimIndex:
			editCommand = [[FKTTrimCommand alloc] initWithComposition:self.composition videoComposition:self.videoComposition audioMix:self.audioMix];
			break;
        case kRotateIndex:
			editCommand = [[FKTRotateCommand alloc] initWithComposition:self.composition videoComposition:self.videoComposition audioMix:self.audioMix];
			break;
        case kCropIndex:
			editCommand = [[FKTCropCommand alloc] initWithComposition:self.composition videoComposition:self.videoComposition audioMix:self.audioMix];
			break;
        case kAddMusicIndex:
			editCommand = [[FKTAddMusicCommand alloc] initWithComposition:self.composition videoComposition:self.videoComposition audioMix:self.audioMix];
			break;
        case kAddWatermarkIndex:
			editCommand = [[FKTAddWaterMarkCommand alloc] initWithComposition:self.composition videoComposition:self.videoComposition audioMix:self.audioMix];
			break;
		default:
			break;
	}
	[editCommand performWithAsset:self.inputAsset];
}

#pragma mark - Playback

- (void)setUpPlaybackOfAsset:(AVAsset *)asset withKeys:(NSArray *)keys
{
	// This method is called when AVAsset has completed loading the specified array of keys.
	// playback of the asset is set up here.
	
	// Check whether the values of each of the keys we need has been successfully loaded.
	for (NSString *key in keys)
    {
		NSError *error = nil;
		
		if ([asset statusOfValueForKey:key error:&error] == AVKeyValueStatusFailed)
        {
			[self stopLoadingAnimationAndHandleError:error];
			return;
		}
	}
	
	if (![asset isPlayable])
    {
		// Asset cannot be played. Display the "Unplayable Asset" label.
		[self stopLoadingAnimationAndHandleError:nil];
		[[self unplayableLabel] setHidden:NO];
		return;
	}
	
	if (![asset isComposable])
    {
		// Asset cannot be used to create a composition (e.g. it may have protected content).
		[self stopLoadingAnimationAndHandleError:nil];
		[[self protectedVideoLabel] setHidden:NO];
		return;
	}
	
	// Set up an AVPlayerLayer
	if ([[asset tracksWithMediaType:AVMediaTypeVideo] count] != 0)
    {
		// Create an AVPlayerLayer and add it to the player view if there is video, but hide it until it's ready for display
		AVPlayerLayer *newPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:[self player]];
		[newPlayerLayer setFrame:[[[self playerView] layer] bounds]];
		[newPlayerLayer setHidden:YES];
		[[[self playerView] layer] addSublayer:newPlayerLayer];
		[self setPlayerLayer:newPlayerLayer];
		[self addObserver:self forKeyPath:@"playerLayer.readyForDisplay" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:FKTPlayerLayerReadyForDisplay];
	}
	else
    {
		// This asset has no video tracks. Show the "No Video" label.
		[self stopLoadingAnimationAndHandleError:nil];
		[[self noVideoLabel] setHidden:NO];
	}
	// Create a new AVPlayerItem and make it the player's current item.
	AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:asset];
	[[self player] replaceCurrentItemWithPlayerItem:playerItem];
}

- (void)stopLoadingAnimationAndHandleError:(NSError *)error
{
	[[self loadingSpinner] stopAnimating];
	[[self loadingSpinner] setHidden:YES];
	if (error) {
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[error localizedDescription]
															message:[error localizedFailureReason]
														   delegate:nil
												  cancelButtonTitle:@"OK"
												  otherButtonTitles:nil];
		[alertView show];
	}
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
	if (context == FKTPlayerItemStatusContext)
    {
		AVPlayerStatus status = [change[NSKeyValueChangeNewKey] integerValue];
		BOOL enable = NO;
		switch (status)
        {
			case AVPlayerItemStatusUnknown:
				break;
			case AVPlayerItemStatusReadyToPlay:
				enable = YES;
				break;
			case AVPlayerItemStatusFailed:
				[self stopLoadingAnimationAndHandleError:[[[self player] currentItem] error]];
				break;
		}
		[[self playPauseButton] setEnabled:enable];
	}
    else if (context == FKTPlayerLayerReadyForDisplay)
    {
		if ([change[NSKeyValueChangeNewKey] boolValue] == YES)
        {
			// The AVPlayerLayer is ready for display. Hide the loading spinner and show the video.
			[self stopLoadingAnimationAndHandleError:nil];
			[[self playerLayer] setHidden:NO];
		}
	}
    else
    {
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	}
}

- (double)duration
{
	AVPlayerItem *playerItem = [[self player] currentItem];
	
	if ([playerItem status] == AVPlayerItemStatusReadyToPlay)
		return CMTimeGetSeconds([[playerItem asset] duration]);
	else
		return 0.f;
}

- (double)currentTime
{
	return CMTimeGetSeconds([[self player] currentTime]);
}

- (void)setCurrentTime:(double)time
{
	[[self player] seekToTime:CMTimeMakeWithSeconds(time, 1)];
}

- (void)reloadPlayerView
{
	// This method is called every time a tool has been applied to a composition
	// It reloads the player view with the updated composition
	// Create a new AVPlayerItem and make it our player's current item.
    self.videoComposition.animationTool = NULL;
	AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:self.composition];
    playerItem.videoComposition = self.videoComposition;
    playerItem.audioMix = self.audioMix;
    if(self.watermarkLayer)
    {
		self.watermarkLayer.position = CGPointMake([[self playerView] bounds].size.width/2, [[self playerView] bounds].size.height);
		[[[self playerView] layer] addSublayer:self.watermarkLayer];
	}
	[[self player] replaceCurrentItemWithPlayerItem:playerItem];
}

@end
