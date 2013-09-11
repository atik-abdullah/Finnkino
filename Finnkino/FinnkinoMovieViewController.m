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
@property (nonatomic, strong) FinnkinoEvent *finnkinoEvent;
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

@end
