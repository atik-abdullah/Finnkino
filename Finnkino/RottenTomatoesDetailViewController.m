//
//  RottenTomatoesDetailAndTableViewController.m
//  Finnkino
//
//  Created by Abdullah Atik on 1/20/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//
#ifdef USE_KVC_KVO_MODEL
#import "RottenTomatoesDetailViewController.h"
#import "FinnkinoFeedStore.h"
#import "Movie.h"
#import "AbridgedCast.h"
#import "MovieRatings.h"
#import "MovieReleaseDates.h"
#import "MoviePosters.h"
#import "MovieLinks.h"

@interface RottenTomatoesDetailViewController ()
//
@property (nonatomic, strong) NSString *selfMovieURL;
// Model data from completion block
@property (nonatomic, strong) Movie *model;
@end

@implementation RottenTomatoesDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    if (self.selection)
    {
        [self configureView];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
	// Do any additional setup after loading the view.
    if (self.selection)
    {
        [self configureView];
        
        // It will retrieve the genre of the movie
        [self fetchEntries];
    }
}

#pragma mark - Utility Methods
- (void)fetchEntries
{
    void (^completionBlock)(id obj, NSError *err) = ^(id obj, NSError *err) {
        
        // When the request completes, this block will be called.
        if(!err)
        {
            // If everything went ok, grab the channel object and
            self.model = obj;
            
            // reload the table.
            [self configureModel];
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
    // Initiate the request...
    [[FinnkinoFeedStore sharedStore] fetchRottenTomatoesMoviesWithCompletion:completionBlock
                                                                      forURL:self.selfMovieURL];
}

-(void) configureModel
{
    // not in nib any more so can't use awakeFromNib for this
    NSString *genreTitle = [[NSMutableString alloc] init];
    for(NSString *aMovieGenre in self.model.genres)
    {
        genreTitle = [genreTitle stringByAppendingString:aMovieGenre];
        genreTitle = [genreTitle stringByAppendingString:@","];
        NSLog(@"genreTitle %@", genreTitle);
    }
    self.genreLabel.text =genreTitle;
}

-(void) configureView
{
    // Set Movie Name title
    self.movieNamelabel.text = [self.selection title];
    
    // Set critics and audience score
    NSString *criticsScorePercent = [[[[self.selection ratings] criticsScore] stringValue] stringByAppendingString:@"%"];
    NSString *audienceScorePercent = [[[[self.selection ratings] audienceScore] stringValue] stringByAppendingString:@"%"];
    self.criticsScore.text = criticsScorePercent;
    self.audienceScore.text = audienceScorePercent;
    
    // Create a string of all movie actors casted
    NSString *castTitle = [[NSMutableString alloc] init];
    for (AbridgedCast *aVar in [self.selection abridgedCast])
    {
        castTitle = [castTitle stringByAppendingString:aVar.name];
        castTitle = [castTitle stringByAppendingString:@","];
        NSLog(@"castTitle %@", castTitle);
    }
    
    // Set the actor casted label
    self.actorNameLabel.text = castTitle;
    
    // Create Date formatter
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    // Create date with the date formatter
    NSDate *dates1 = [dateFormatter dateFromString:[[self.selection releaseDates] theater]];
    [dateFormatter setDateFormat:@"dd MMM yyyy"];
    
    // Creat a date string from the Date
    NSString *dateString = [dateFormatter stringForObjectValue:dates1];
    
    // Set the date label
    self.releaseDateTheaterLabel.text = dateString;
    
    // Set label for the duration of movie
    self.runTimeLabel.text = [[self.selection runtime] stringValue];
    
    NSURL *urlFromString = [[NSURL alloc] initWithString:[[self.selection posters] detailed]] ;
    NSData *data = [NSData dataWithContentsOfURL:urlFromString];
    self.profileImageView.image = [UIImage imageWithData:data];
    
    UIImage *myfreshImage = [UIImage imageNamed:@"fresh.png"];
    UIImageView *myImageView = [[UIImageView alloc] initWithImage:myfreshImage];
    [myImageView setFrame:CGRectMake(0, 0, 30, 30)];
    [self.myButtonView addSubview:myImageView];
    
    UIImage *myAudience = [UIImage imageNamed:@"audience_up"];
    UIImageView *myImageView2 = [[UIImageView alloc] initWithImage:myAudience];
    [myImageView2 setFrame:CGRectMake(0, 40, 30, 30)];
    [self.myButtonView addSubview:myImageView2];
    self.selfMovieURL =  [[self.selection links] linkself];
}
@end
#else

#import "RottenTomatoesDetailViewController.h"
#import "FinnkinoFeedStore.h"
#import "JSONFirstLevelDict.h"
#import "JSONSecondLevelDict.h"
#import "JSONThirdLevelDict.h"

@interface RottenTomatoesDetailViewController ()
// 
@property (nonatomic, strong) NSString *selfMovieURL;
// Model data from completion block
@property (nonatomic, strong) JSONFirstLevelDict *model;
@end

@implementation RottenTomatoesDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    if (self.selection)
    {
        [self configureView];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
	// Do any additional setup after loading the view.
    if (self.selection)
    {
        [self configureView];
        
        // It will retrieve the genre of the movie 
        [self fetchEntries];
    }
}

#pragma mark - Utility Methods
- (void)fetchEntries
{
    void (^completionBlock)(id obj, NSError *err) = ^(id obj, NSError *err) {
        
        // When the request completes, this block will be called.
        if(!err)
        {
            // If everything went ok, grab the channel object and
            self.model = obj;

            // reload the table.
            [self configureModel];
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
    // Initiate the request...
    [[FinnkinoFeedStore sharedStore] fetchRottenTomatoesMoviesWithCompletion:completionBlock
                                                                      forURL:self.selfMovieURL];
}

-(void) configureModel
{
    // not in nib any more so can't use awakeFromNib for this
    NSString *genreTitle = [[NSMutableString alloc] init];
    for(NSString *aMovieGenre in self.model.movieGenreNames)
    {
        genreTitle = [genreTitle stringByAppendingString:aMovieGenre];
        genreTitle = [genreTitle stringByAppendingString:@","];
        NSLog(@"castTitle %@", genreTitle);
    }
    self.genreLabel.text =genreTitle;
}

-(void) configureView
{
    // Set Movie Name title
    self.movieNamelabel.text = [self.selection jsonTitle];
    
    // Set critics and audience score
    NSString *criticsScorePercent = [[[[self.selection criticsScoreElement] criticsScore] stringValue] stringByAppendingString:@"%"];
    NSString *audienceScorePercent = [[[[self.selection audienceScoreElement] audienceScore] stringValue] stringByAppendingString:@"%"];
    self.criticsScore.text = criticsScorePercent;
    self.audienceScore.text = audienceScorePercent;
    
    // Create a string of all movie actors casted
    NSString *castTitle = [[NSMutableString alloc] init];
    for (JSONThirdLevelDict *aVar in [self.selection castItems])
    {
        castTitle = [castTitle stringByAppendingString:aVar.castTitle];
        castTitle = [castTitle stringByAppendingString:@","];
        NSLog(@"castTitle %@", castTitle);
    }
    
    // Set the actor casted label
    self.actorNameLabel.text = castTitle;
    
    // Create Date formatter
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];

    // Create date with the date formatter
    NSDate *dates1 = [dateFormatter dateFromString:[[self.selection releaseDatesElement] releaseDatesTheater]];
    [dateFormatter setDateFormat:@"dd MMM yyyy"];
    
    // Creat a date string from the Date
    NSString *dateString = [dateFormatter stringForObjectValue:dates1];
    
    // Set the date label
    self.releaseDateTheaterLabel.text = dateString;
    
    // Set label for the duration of movie
    self.runTimeLabel.text = [self.selection runtime];
    
    NSURL *urlFromString = [[NSURL alloc] initWithString:[[self.selection postersDetailed] postersDetailed]] ;
    NSData *data = [NSData dataWithContentsOfURL:urlFromString];
    self.profileImageView.image = [UIImage imageWithData:data];
    
    UIImage *myfreshImage = [UIImage imageNamed:@"fresh.png"];
    UIImageView *myImageView = [[UIImageView alloc] initWithImage:myfreshImage];
    [myImageView setFrame:CGRectMake(0, 0, 30, 30)];
    [self.myButtonView addSubview:myImageView];
    
    UIImage *myAudience = [UIImage imageNamed:@"audience_up"];
    UIImageView *myImageView2 = [[UIImageView alloc] initWithImage:myAudience];
    [myImageView2 setFrame:CGRectMake(0, 40, 30, 30)];
    [self.myButtonView addSubview:myImageView2];
    self.selfMovieURL =  [[self.selection linkSelfElement] linksSelf];
}
@end
#endif
