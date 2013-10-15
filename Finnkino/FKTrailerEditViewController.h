//
//  FKTrailerEditViewController.h
//  Finnkino
//
//  Created by Abdullah Atik on 10/9/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>

@interface FKTrailerEditViewController : UIViewController

@property (nonatomic, strong) NSDictionary *selection;
@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, strong) NSString *filePath;
@property AVPlayer *player;
@property AVPlayerLayer *playerLayer;
@property AVAsset *inputAsset;
@property AVMutableComposition *composition;
@property AVMutableVideoComposition *videoComposition;
@property AVMutableAudioMix *audioMix;
@property CALayer *watermarkLayer;

@property IBOutlet UIActivityIndicatorView *loadingSpinner;
@property IBOutlet UILabel *unplayableLabel;
@property IBOutlet UILabel *noVideoLabel;
@property IBOutlet UILabel *protectedVideoLabel;
@property IBOutlet UIBarButtonItem *playPauseButton;
@property IBOutlet UIView *playerView;

- (IBAction)playPauseToggle:(id)sender;
- (IBAction)loadMovieButtonPressed:(id)sender;

@end
