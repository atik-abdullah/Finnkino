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
#import "FinnkinoEvent+TableRepresentation.h"

@interface FinnkinoMovieViewController ()

// finnkinoEvent holds all the movie information,received from the completion block
@property (nonatomic, strong) FinnkinoEvent *finnkinoEvent;

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

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section
{
    return (self.sectionNames)[section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.sectionNames count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [(self.sectionData)[section] count];
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
    [[cell textLabel] setText:[(self.sectionData)[[indexPath section]][[indexPath row]] objectForKey:@"title"]];
    return cell;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [@[UITableViewIndexSearch] arrayByAddingObjectsFromArray:self.sectionNames];
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
    // It has to be initialized here and not in viewDidLoad or awakeFromNib because
    // those methods are not called after the completion block has finished
    NSDictionary *aDictionary = [self.finnkinoEvent tr_tableRepresentation];
    
    self.sectionNames = [aDictionary objectForKey:@"sectionNames"];
    self.sectionData = [aDictionary objectForKey:@"sectionData"];
    
}

@end
