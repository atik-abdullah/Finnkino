//
//  RottenTomatoesMoviesViewController.m
//  Finnkino
//
//  Created by Abdullah Atik on 1/18/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//

#import "RottenTomatoesMoviesViewController.h"
#import "FinnkinoFeedStore.h"
#import "JSONFirstLevelDict.h"
#import "JSONSecondLevelDict.h"
#import "JSONThirdLevelDict.h"
#import "RottenTomatoesDetailViewController.h"

@interface RottenTomatoesMoviesViewController ()

// Received from completion block, holds the data model
@property (nonatomic, strong) JSONFirstLevelDict *allEvents;

@end

@implementation RottenTomatoesMoviesViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fetchEntries];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[self.allEvents movieItems] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // We have only one type of cell
    static NSString *cellIdentifier = @"plainCell";
    
    // Ask table view for previously used cell of the specified type
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    // Get pointer to label
    UILabel *cellLabel = (UILabel *)[cell viewWithTag:1];
    
    // Get pointer to image view
    UIImageView *cellImageView = (UIImageView *) [cell viewWithTag:2];
    
    // Create a background thread
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    // Download image in the background thread
    dispatch_async(concurrentQueue, ^
                   {
                       // Retrieve the URL for image
                       NSURL *urlFromString = [[NSURL alloc] initWithString:[[[[self.allEvents movieItems] objectAtIndex:indexPath.row] postersThumbnail] postersThumbnail]] ;
                       
                       // Download the raw image data
                       NSData *data = [NSData dataWithContentsOfURL:urlFromString];
                       
                       // Create UIImage from raw data
                       UIImage *myImage = [UIImage imageWithData:data];
                       
                       // Set the image in main thread
                       dispatch_async(dispatch_get_main_queue(), ^
                                      {
                                          cellImageView.image = myImage;
                                      });
                   });
    
    // Set the label text
    cellLabel.text = [[[self.allEvents movieItems] objectAtIndex:indexPath.row] jsonTitle];
    return cell;
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    RottenTomatoesDetailViewController *rtdvc = segue.destinationViewController;
    
    if ([rtdvc respondsToSelector:@selector(setDelegate:)])
    {
        [rtdvc setValue:self forKey:@"delegate"];
    }
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    if ([rtdvc respondsToSelector:@selector(setSelection:)])
    {
        [rtdvc setValue:[[self.allEvents movieItems] objectAtIndex:indexPath.row] forKey:@"selection"];
    }
}

#pragma mark - Interface Builder methods

- (void)changeType:(id)sender
{
    rssType = [sender selectedSegmentIndex];
    [self fetchEntries];
}

#pragma mark - Utility Methods
- (void)fetchEntries
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
            // If everything went ok, grab the channel object and
            self.allEvents = obj;
            
            // Reload the table.
            [[self tableView] reloadData];
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
    if(rssType == BoxOfficeURL)
    {
        [[FinnkinoFeedStore sharedStore] fetchRottenTomatoesMovies:50 withCompletion:completionBlock forURLType:RottenTomatoesBoxOfficeURL];
    }
    else if(rssType == TopMoviesURL )
    {
        [[FinnkinoFeedStore sharedStore] fetchRottenTomatoesMovies:50 withCompletion:completionBlock forURLType:RottenTomatoesUpcomingURL];
    }
    else if (rssType == SearchMovieURL)
    {
        [[FinnkinoFeedStore sharedStore] fetchRottenTomatoesMovies:10 withCompletion:completionBlock forURLType:RottenTomatoesSearchURL];
    }
}

@end
