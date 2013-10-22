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
#import "FinnkinoDetailViewController.h"
#import "PhotoRecord.h"

@interface FinnkinoMovieViewController ()

// Holds all the movie information,received from the completion block
@property (nonatomic, strong) FinnkinoEvent *finnkinoEvent;

// An array of arrays containing Dictionary
@property (nonatomic, strong) NSMutableArray* sectionData;

// An array of section headers
@property (nonatomic, strong) NSMutableArray* sectionNames;

// It's an array of filtered Movie Dictionary, not array of arrays of movie dict
@property (nonatomic, strong) NSArray* filteredSectionData;

// Switch to determine if datasource needs to be filtered
@property (nonatomic, assign) BOOL isFiltered;

// It's an array of Movie Dictionary, not array of arrays of movie dict
@property (nonatomic, strong) NSArray *arrayOfMovieDictionary;

// Switch to determine if datasource needs to be filtered
@property (nonatomic, assign) BOOL hideIndexTools;

@end

@implementation FinnkinoMovieViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"Header"];
    
    // Colorize index that runs down the right side
    self.tableView.sectionIndexColor = [UIColor blueColor];
    self.tableView.sectionIndexTrackingBackgroundColor = [UIColor blackColor];
    
    // Set the scope bar initially which contains button"begins with" and "contains"
    [self.movieSearchBar setShowsScopeBar:NO];
    [self.movieSearchBar sizeToFit];
    [self fetchEntries];
}

- (void)viewWillAppear:(BOOL)animated
{
    // Hide the navigation bar , it has to be here since when popped
    //  back from Detail view viewDidLoad method is not called
    self.navigationController.navigationBarHidden = YES;
}

#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section
{
    if((self.isFiltered == YES) || (self.hideIndexTools == YES))
    {
        return nil;
    }
    return (self.sectionNames)[section];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (index > 0)
    {
        // The index is offset by one to allow for the extra search
        // icon inserted at the front of the index
        return index-1;
    }
    else
    {
        // The first entry in the index is for the search icon so we return
        // section not found and force the table to scroll to the top
        self.tableView.contentOffset = CGPointZero;
        return NSNotFound;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if((self.isFiltered == YES) || (self.hideIndexTools))
    {
        return 1;
    }
    return [self.sectionNames count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.isFiltered == YES)
    {
        return [self.filteredSectionData count];
    }
    else if (self.hideIndexTools == YES)
    {
        return [self.arrayOfMovieDictionary count];
    }
    else
    {
        return [(self.sectionData)[section] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:@"plainCell"];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"plainCell"];
    }

    // Create Label
    UILabel *cellLabel = (UILabel *)[cell viewWithTag:2];
    NSDictionary *currentDictionary;

    if(self.isFiltered == YES)
    {
        // Set the title to the label
        cellLabel.text = [(self.filteredSectionData)[[indexPath row]] objectForKey:@"title"];
        currentDictionary = (self.filteredSectionData)[indexPath.row];
    }
    else if (self.hideIndexTools == YES)
    {

        // Set the title to the label
        cellLabel.text = [self.arrayOfMovieDictionary[indexPath.row] objectForKey:@"title"];
        currentDictionary = self.arrayOfMovieDictionary[indexPath.row];
    }
    else
    {
        // Set the title to the label
        cellLabel.text = [(self.sectionData)[[indexPath section]][[indexPath row]] objectForKey:@"title"];

        currentDictionary = (self.sectionData)[indexPath.section][indexPath.row];
    }

    // Create ImageView
    UIImageView *cellImageView = (UIImageView *) [cell viewWithTag:1];

    // Create URL from String
    NSURL *urlFromString = [[NSURL alloc] initWithString:[currentDictionary objectForKey:@"movieSmallImagePortraitURL"]] ;

    // Download image from created URL
    NSData *data = [NSData dataWithContentsOfURL:urlFromString];

    // Create Image from Downloaded raw Data
    UIImage *myImage = [UIImage imageWithData:data];

    cellImageView.image = myImage;
    return cell;
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UITableViewCell *cell = [tableView
//                             dequeueReusableCellWithIdentifier:@"plainCell"];
//    if (cell == nil)
//    {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
//                                      reuseIdentifier:@"plainCell"];
//    }
//    
//    // Create Label
//    UILabel *cellLabel = (UILabel *)[cell viewWithTag:2];
//    
//    // Create ImageView
//    UIImageView *cellImageView = (UIImageView *) [cell viewWithTag:1];
//        
//    // 2: The data source contains instances of PhotoRecord. Get a hold of each of them based on the indexPath of the row.
//    PhotoRecord *aRecord = (self.photos) [[indexPath section]][[indexPath row]];
//    
//    // 3: Inspect the PhotoRecord. If its image is downloaded, display the image, the image name, and stop the activity indicator.
//    if (aRecord.hasImage)
//    {
//        [((UIActivityIndicatorView *)cell.accessoryView) stopAnimating];
//        cellImageView.image = aRecord.image;
//        cellLabel.text = aRecord.name;
//    }
//    // 4: If downloading the image has failed, display a placeholder to display the failure, and stop the activity indicator.
//    else if (aRecord.isFailed)
//    {
//        [((UIActivityIndicatorView *)cell.accessoryView) stopAnimating];
//        cell.imageView.image = [UIImage imageNamed:@"Failed.png"];
//        cell.textLabel.text = @"Failed to load";
//        
//    }
//    // 5: Otherwise, the image has not been downloaded yet. Start the download and filtering operations (theyíre not yet implemented), and display a placeholder that indicates you are working on it. Start the activity indicator to show user something is going on.
//    else
//    {
//        [((UIActivityIndicatorView *)cell.accessoryView) startAnimating];
//        cell.imageView.image = [UIImage imageNamed:@"Placeholder.png"];
//        cell.textLabel.text = @"";
//        
//        if (!tableView.dragging && !tableView.decelerating)
//        {
//            [self startOperationsForPhotoRecord:aRecord atIndexPath:indexPath];
//        }
//    }
//    return cell;
//}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if((self.isFiltered == YES) || (self.hideIndexTools == YES))
    {
        return nil;
    }
    return [@[UITableViewIndexSearch] arrayByAddingObjectsFromArray:self.sectionNames];
}

#pragma mark - Table view delegate

// further trick to prevent header view from appearing in search results table

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return UITableViewAutomaticDimension;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewHeaderFooterView* h =
    [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"Header"];
    if (![h.tintColor isEqual: [UIColor redColor]])
        NSLog(@"creating new header view"); // this will prove we're reusing views
    h.tintColor = [UIColor redColor]; // this will prove we're using these reusable views
    return h;
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    FinnkinoDetailViewController *fdvc = segue.destinationViewController;
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    NSDictionary *selection;
    
    // Check if destination view controller has property named selection
    if ([fdvc respondsToSelector:@selector(setSelection:)])
    {
        if(self.isFiltered == YES)
        {
            // Prepare selection info
            selection = (self.filteredSectionData)[[indexPath row]];
            [fdvc setValue:selection forKey:@"selection"];
        }
        else
        {
            // Prepare selection info
            selection = (self.sectionData)[[indexPath section]][[indexPath row]];
            [fdvc setValue:selection forKey:@"selection"];
        }
    }
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self.movieSearchBar setShowsScopeBar:YES];
    
    if(searchText.length == 0)
    {
        self.isFiltered = NO;
    }
    else
    {
        self.isFiltered = YES;
        [self filterData];
    }
    [self.tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.movieSearchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.movieSearchBar resignFirstResponder];
    self.hideIndexTools = NO;
    [self.tableView reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
{
    [self filterData];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsScopeBar = YES;
    [searchBar sizeToFit];
    [searchBar setShowsCancelButton:YES animated:YES];
    self.hideIndexTools = YES;
    [self.tableView reloadData];
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    searchBar.showsScopeBar = NO;
    [searchBar sizeToFit];
    [searchBar setShowsCancelButton:NO animated:YES];
    return YES;
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
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
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
    self.arrayOfMovieDictionary = [aDictionary objectForKey:@"arrayOfMovies"];
}

- (void) filterData
{
    NSPredicate* p = [NSPredicate predicateWithBlock:
                      ^BOOL(id obj, NSDictionary *d){
                          NSDictionary* s = obj;
                          NSStringCompareOptions options = NSCaseInsensitiveSearch;
                          if (self.movieSearchBar.selectedScopeButtonIndex == 0)
                              options |= NSAnchoredSearch;
                          return ([[s objectForKey:@"title"] rangeOfString:self.movieSearchBar.text
                                                                   options:options].location != NSNotFound);
                      }];
    self.filteredSectionData = [self.arrayOfMovieDictionary filteredArrayUsingPredicate:p];
}

@end
