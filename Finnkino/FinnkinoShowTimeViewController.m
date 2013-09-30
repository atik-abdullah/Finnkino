//
//  FinnkinoShowTimeViewController.m
//  Finnkino
//
//  Created by Abdullah Atik on 1/17/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//

#import "FinnkinoShowTimeViewController.h"
#import "FinnkinoFeedStore.h"
#import "FinnkinoScheduleSecondLevelElement.h"
#import "FinnkinoScheduleFirstLevelElement.h"

@interface FinnkinoShowTimeViewController ()

// Datasource for table view
@property (nonatomic, strong) NSArray *filteredArray;

@end

@implementation FinnkinoShowTimeViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

#pragma mark - View lifecycle

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
    return [self.filteredArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"plainCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    // Configure the cell...
    UILabel *cellLabel = (UILabel *)[cell viewWithTag:1];
    
    FinnkinoScheduleSecondLevelElement *test = (self.filteredArray)[indexPath.row] ;
    cellLabel.text = test.theatreAndAuditorium;
    
    return cell;
}

#pragma mark - Utility methods

- (void)fetchEntries
{
    void (^completionBlock)(FinnkinoScheduleFirstLevelElement *obj, NSError *err) = ^(FinnkinoScheduleFirstLevelElement *obj, NSError *err) {
        
        // When the request completes, this block will be called.
        if(!err)
        {
            // If everything went ok, grab the channel object
            FinnkinoScheduleFirstLevelElement *allShows = obj;
            
            // copy array of show times to local array, so original datasource wont be modified
            NSArray *arrOfShows =  [[NSMutableArray alloc ] initWithArray:allShows.showItems];
            
            // Create a search predicate
            NSPredicate *sPredicate = [NSPredicate predicateWithFormat:@"showTitle CONTAINS %@", [self.selection objectForKey:@"title"]];
            
            // Use the search predicate on local array and update tableview datasource
            self.filteredArray = [arrOfShows filteredArrayUsingPredicate:sPredicate];
            
            // Reload table view
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
    [[FinnkinoFeedStore sharedStore] fetchRSSFeedWithCompletion:completionBlock forURLType:ShowURL];
}

@end
