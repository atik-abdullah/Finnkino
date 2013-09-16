//
//  FinnkinoMovieViewController.m
//  Finnkino
//
//  Created by Abdullah Atik on 9/10/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//

#import "FinnkinoMovieViewController.h"
#import "FinnkinoEvent.h"
#import "FinnkinoOneMovieEvent.h"
#import "FinnkinoFeedStore.h"

@interface FinnkinoMovieViewController ()

// finnkinoEvent holds all the movie information,received from the completion block
@property (nonatomic, strong) FinnkinoEvent *finnkinoEvent;

// An array of dictionary - each movie in finnkinoEvent will be converted in dictionary
// in -configureModel , then added to the arrayOfMovies.
@property (nonatomic, strong) NSMutableArray *arrayOfMovies;

// An array of arrays containing Dictionary
@property (nonatomic, strong) NSMutableArray* sectionData;

// An array of section headers
@property (nonatomic, strong) NSMutableArray* sectionNames;
@end

@implementation FinnkinoMovieViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fetchEntries];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.finnkinoEvent movieItems] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"UITableViewCell"];
    }
    FinnkinoOneMovieEvent *oneMovieEvent = [[self.finnkinoEvent movieItems] objectAtIndex:[indexPath row]];
    [[cell textLabel] setText:[oneMovieEvent title]];
    return cell;
}

#pragma mark - Utility methods

- (void)fetchEntries
{
    void (^completionBlock)(FinnkinoEvent *obj, NSError *err) = ^(FinnkinoEvent *obj, NSError *err)
    {
        // When the request completes, this block will be called.
        if(!err)
        {
            // If everything went ok, grab the channel object and
            // reload the table.
            self.finnkinoEvent = obj;
            [self configureModel];

            // If table view is not reloaded executing next line will crash
            [self.tableView reloadData];
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
    [[FinnkinoFeedStore sharedStore] fetchRSSFeedWithCompletion:completionBlock forURLType:EventURL];
}

-(void) configureModel
{    
    // Holds one single movie information
    NSMutableDictionary *aMovieInformationDict;

    // It has to be initialized here and not in viewDidLoad or awakeFromNib because
    // those methods are not called after the completion block has finished
    self.arrayOfMovies = [[NSMutableArray alloc] init];
    
    // Convert each movie information to dictionary
    for (FinnkinoOneMovieEvent *aMovie in [self.finnkinoEvent sortedMovieItems])
    {
        aMovieInformationDict = [NSDictionary dictionaryWithObjectsAndKeys:aMovie.title , @"title", nil];
        
        // Create an array of dictionary(aMovieInformationDict)
        [self.arrayOfMovies addObject:aMovieInformationDict];
    }
    
    self.sectionNames = [NSMutableArray array];
    self.sectionData = [NSMutableArray array];
    
    NSString* previous = @"";
    
    // From one long list of array divide them into small chunk of arrays and then add the small chunks to an array , the output is an array of arrays.
    for (NSDictionary* aMovieDictionary in self.arrayOfMovies)
    {
        
        // Each title having common first letter belongs to one smaller chunk
        NSString* c = [[aMovieDictionary objectForKey:@"title" ] substringToIndex:1];
        
        // If a different letter encountered than previous begin a new smaller chunk
        if (![c isEqualToString: previous])
        {
            previous = c;
            [self.sectionNames addObject: [c uppercaseString]];
            NSMutableArray* oneSection = [NSMutableArray array];
            [self.sectionData addObject: oneSection];
        }
        
        // If same letter encountered keep adding to the same small chunk
        [[self.sectionData lastObject] addObject: aMovieDictionary];
    }
    NSLog(@"%@", self.sectionNames);
    NSLog(@"%@", self.sectionData);
}

@end
