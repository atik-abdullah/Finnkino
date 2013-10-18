//
//  RottenTomatoesDetailAndTableViewController.m
//  Finnkino
//
//  Created by Abdullah Atik on 1/20/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//
#import "RottenTomatoesDetailViewController.h"
#import "FinnkinoFeedStore.h"
#import "JSONFirstLevelDict.h"
#import "JSONSecondLevelDict.h"
#import "JSONThirdLevelDict.h"
#import "RTPosterViewController.h"

#define kWantToWatchIndex 0
#define kHaveWatchedIndex 1
#define kFavoriteIndex 2

@interface RottenTomatoesDetailViewController ()
//
@property (nonatomic, strong) NSString *selfMovieURL;
// Model data from completion block
@property (nonatomic, strong) JSONFirstLevelDict *model;

// Data to save in Core data
@property (nonatomic, strong) NSString *abridgedCast;
@property (nonatomic, strong) NSString *genres;
@property (nonatomic, strong) NSString *movieId;
@property (nonatomic, strong) NSString *detailed;
@property (nonatomic, strong) NSString *original;
@property (nonatomic, strong) NSString *profile;
@property (nonatomic, strong) NSString *thumbnail;

@property (nonatomic, strong) NSString *audRating;
@property (nonatomic, strong) NSString *audScore;
@property (nonatomic, strong) NSString *crRating;
@property (nonatomic, strong) NSString *crScore;

@property (nonatomic, strong) NSString *runtime;
@property (nonatomic, strong) NSString *synopsis;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *releaseDate;

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
    for(NSString *aMovieGenre in self.model.movieGenreNames)
    {
        self.genres = [self.genres stringByAppendingString:aMovieGenre];
        self.genres = [self.genres stringByAppendingString:@","];
        NSLog(@"castTitle %@", self.genres);
    }
    self.genreLabel.text = self.genres;
}

-(void) configureView
{
    // Set Movie Name title
    self.title = [self.selection jsonTitle];
    self.movieNamelabel.text = self.title;
    
    // Set critics and audience score
    self.crScore = [[[[self.selection criticsScoreElement] criticsScore] stringValue] stringByAppendingString:@"%"];
    self.audScore = [[[[self.selection audienceScoreElement] audienceScore] stringValue] stringByAppendingString:@"%"];
    self.criticsScore.text = self.crScore;
    self.audienceScore.text = self.audScore;
    
    // Create a string of all movie actors casted
    self.abridgedCast = [[NSMutableString alloc] init];
    for (JSONThirdLevelDict *aVar in [self.selection castItems])
    {
        self.abridgedCast = [self.abridgedCast stringByAppendingString:aVar.castTitle];
        self.abridgedCast = [self.abridgedCast stringByAppendingString:@","];
    }
    
    // Set the actor casted label
    self.actorNameLabel.text = self.abridgedCast;
    
    // Create Date formatter
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    // Create date with the date formatter
    NSDate *dates1 = [dateFormatter dateFromString:[[self.selection releaseDatesElement] releaseDatesTheater]];
    
    // Creat a date string from the Date
    self.releaseDate = [dateFormatter stringFromDate:dates1];
    
    // Set the date label
    self.releaseDateTheaterLabel.text = self.releaseDate;
    
    // Set label for the duration of movie
    self.runtime = [self.selection runtime];
    self.runTimeLabel.text =self.runtime;
    
    // Set the movie poster
    self.detailed = [[self.selection postersDetailed] postersDetailed];
    self.original = [[self.selection postersDetailed] postersOriginal];
    self.profile = [[self.selection postersDetailed] postersProfile];
    self.thumbnail = [[self.selection postersDetailed] postersThumbnail];
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

#pragma mark - segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    RTPosterViewController *rtpvc = segue.destinationViewController;
    
    if ([rtpvc respondsToSelector:@selector(setSelection:)])
    {
        [rtpvc setValue:self.selection forKey:@"selection"];
    }
}

#pragma mark - IBAction

- (IBAction)addToFavorite:(id)sender
{
    int tag = [sender tag];
    
    NSDictionary *saveInCoreData = [NSDictionary dictionaryWithObjectsAndKeys:
                                    self.abridgedCast , @"abridgedCast",
                                    self.genres, @"genres",
                                    self.detailed, @"detailed",
                                    self.original, @"original",
                                    self.thumbnail, @"thumbnail",
                                    self.profile, @"profile",
                                    self.audScore, @"audScore",
                                    self.audRating, @"audRating",
                                    self.crScore, @"crScore",
                                    self.crRating, @"crRating",
                                    self.runtime, @"runtime",
                                    self.synopsis, @"synopsis",
                                    self.title, @"title",
                                    self.releaseDate, @"releaseDate",nil];
    
	switch (tag)
    {
		case kWantToWatchIndex:
            [[FinnkinoFeedStore sharedStore] createItem: saveInCoreData ForFavoriteType:WantToWatch];
            break;
        case kHaveWatchedIndex:
            [[FinnkinoFeedStore sharedStore] createItem: saveInCoreData ForFavoriteType:WantToWatch];
			break;
        case kFavoriteIndex:
            [[FinnkinoFeedStore sharedStore] createItem: saveInCoreData ForFavoriteType:WantToWatch];
			break;
		default:
			break;
	}
    [[FinnkinoFeedStore sharedStore] saveChanges];
}

@end
