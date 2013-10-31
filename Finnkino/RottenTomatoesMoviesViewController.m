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

// 4: You donít need the data source as-is. You are going to create instances of PhotoRecord using the property list. So, change the class of ìphotosî from NSDictionary to NSMutableArray, so that you can update the array of photos.
@property (nonatomic, strong) NSMutableArray *photos; // main data source of controller

// 5: This property is used to track pending operations.
@property (nonatomic, strong) PendingOperations *pendingOperations;

@end

@implementation RottenTomatoesMoviesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fetchEntries];
}

#pragma mark -
#pragma mark - Lazy instantiation

- (PendingOperations *)pendingOperations
{
    if (!_pendingOperations)
    {
        _pendingOperations = [[PendingOperations alloc] init];
    }
    return _pendingOperations;
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
    
    // 2: The data source contains instances of PhotoRecord. Get a hold of each of them based on the indexPath of the row.
    PhotoRecord *aRecord = [self.photos objectAtIndex:indexPath.row];
    
    // 3: Inspect the PhotoRecord. If its image is downloaded, display the image, the image name, and stop the activity indicator.
    if (aRecord.hasImage)
    {
        [((UIActivityIndicatorView *)cell.accessoryView) stopAnimating];
        cellImageView.image = aRecord.image;
        cellLabel.text = aRecord.name;
        
    }
    // 4: If downloading the image has failed, display a placeholder to display the failure, and stop the activity indicator.
    else if (aRecord.isFailed)
    {
        [((UIActivityIndicatorView *)cell.accessoryView) stopAnimating];
        cellImageView.image = [UIImage imageNamed:@"Failed.png"];
        cellLabel.text = @"Failed to load";
    }
    // 5: Otherwise, the image has not been downloaded yet. Start the download and filtering operations (theyíre not yet implemented), and display a placeholder that indicates you are working on it. Start the activity indicator to show user something is going on.
    else
    {
        [((UIActivityIndicatorView *)cell.accessoryView) startAnimating];
        cellImageView.image = [UIImage imageNamed:@"Placeholder.png"];
        cellLabel.text = @"";
        
        if (!tableView.dragging && !tableView.decelerating)
        {
            [self startOperationsForPhotoRecord:aRecord atIndexPath:indexPath];
        }
    }
    return cell;
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    RottenTomatoesDetailViewController *rtdvc = segue.destinationViewController;
    
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
            [self configureModel];
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
    else if(rssType == UpcomingURL )
    {
        [[FinnkinoFeedStore sharedStore] fetchRottenTomatoesMovies:50 withCompletion:completionBlock forURLType:RottenTomatoesUpcomingURL];
    }
    else if (rssType == SearchMovieURL)
    {
        [[FinnkinoFeedStore sharedStore] fetchRottenTomatoesMovies:10 withCompletion:completionBlock forURLType:RottenTomatoesSearchURL];
    }
}

- (void)configureModel
{
    // An array of arrays containing Dictionary - Dictionary
    NSMutableArray *datasource = [self.allEvents movieItems];
    
    // 6: Create a NSMutableArray and iterate through all objects and keys in the dictionary, create a PhotoRecord instance, and store it in the array.
    NSMutableArray *records = [NSMutableArray array];
    
    for (JSONSecondLevelDict *oneItem in datasource)
    {
        PhotoRecord *record = [[PhotoRecord alloc] init];
        record.URL = [NSURL URLWithString:[[oneItem postersThumbnail] postersThumbnail]];
        record.name = [oneItem jsonTitle];
        [records addObject:record];
        record = nil;
    }
    // 7: Once you are done, point the _photo to the array of records, reload the table view and stop the network activity indicator. You also release the ìplistî instance variable.
    self.photos = records;
}

#pragma mark -
#pragma mark - Operations

// 1: To keep it simple, you pass in an instance of PhotoRecord that requires operations, along with its indexPath.
- (void)startOperationsForPhotoRecord:(PhotoRecord *)record atIndexPath:(NSIndexPath *)indexPath
{    
    // 2: You inspect it to see whether it has an image; if so, then ignore it.
    if (!record.hasImage)
    {
        // 3: If it does not have an image, start downloading the image by calling startImageDownloadingForRecord:atIndexPath: (which will be implemented shortly). Youíll do the same for filtering operations: if the image has not yet been filtered, call startImageFiltrationForRecord:atIndexPath: (which will also be implemented shortly).
        [self startImageDownloadingForRecord:record atIndexPath:indexPath];
    }
    if (!record.isFiltered)
    {
        [self startImageFiltrationForRecord:record atIndexPath:indexPath];
    }
}

- (void)startImageDownloadingForRecord:(PhotoRecord *)record atIndexPath:(NSIndexPath *)indexPath
{    
    // 1: First, check for the particular indexPath to see if there is already an operation in downloadsInProgress for it. If so, ignore it.
    if (![self.pendingOperations.downloadsInProgress.allKeys containsObject:indexPath])
    {
        // 2: If not, create an instance of ImageDownloader by using the designated initializer, and set ListViewController as the delegate. Pass in the appropriate indexPath and a pointer to the instance of PhotoRecord, and then add it to the download queue. You also add it to downloadsInProgress to help keep track of things.
        // Start downloading
        ImageDownloader *imageDownloader = [[ImageDownloader alloc] initWithPhotoRecord:record atIndexPath:indexPath delegate:self];
        [self.pendingOperations.downloadsInProgress setObject:imageDownloader forKey:indexPath];
        [self.pendingOperations.downloadQueue addOperation:imageDownloader];
    }
}

- (void)startImageFiltrationForRecord:(PhotoRecord *)record atIndexPath:(NSIndexPath *)indexPath
{    
    // 3: If not, create an instance of ImageDownloader by using the designated initializer, and set ListViewController as the delegate. Pass in the appropriate indexPath and a pointer to the instance of PhotoRecord, and then add it to the download queue. You also add it to downloadsInProgress to help keep track of things.
    if (![self.pendingOperations.filtrationsInProgress.allKeys containsObject:indexPath])
    {
        // 4: If not, start one by using the designated initializer.
        // Start filtration
        ImageFiltration *imageFiltration = [[ImageFiltration alloc] initWithPhotoRecord:record atIndexPath:indexPath delegate:self];
        
        // 5: This one is a little tricky. You first must check to see if this particular indexPath has a pending download; if so, you make this filtering operation dependent on that. Otherwise, you donít need dependency.
        ImageDownloader *dependency = [self.pendingOperations.downloadsInProgress objectForKey:indexPath];
        if (dependency)
            [imageFiltration addDependency:dependency];
        
        [self.pendingOperations.filtrationsInProgress setObject:imageFiltration forKey:indexPath];
        [self.pendingOperations.filtrationQueue addOperation:imageFiltration];
    }
}

#pragma mark -
#pragma mark - ImageDownloader delegate

- (void)imageDownloaderDidFinish:(ImageDownloader *)downloader
{    
    // 1: Check for the indexPath of the operation, whether it is a download, or filtration.
    NSIndexPath *indexPath = downloader.indexPathInTableView;
    
    // 2: Get hold of the PhotoRecord instance.
    PhotoRecord *theRecord = downloader.photoRecord;
    
    // 3: Replace the updated PhotoRecord in the main data source (Photos array).
    [self.photos replaceObjectAtIndex:indexPath.row withObject:theRecord];
    
    // 4: Update UI.
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    // 5: Remove the operation from downloadsInProgress (or filtrationsInProgress).
    [self.pendingOperations.downloadsInProgress removeObjectForKey:indexPath];
}

#pragma mark -
#pragma mark - ImageFiltration delegate

- (void)imageFiltrationDidFinish:(ImageFiltration *)filtration
{
    NSIndexPath *indexPath = filtration.indexPathInTableView;
    PhotoRecord *theRecord = filtration.photoRecord;
    
    [self.photos replaceObjectAtIndex:indexPath.row withObject:theRecord];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.pendingOperations.filtrationsInProgress removeObjectForKey:indexPath];
}

#pragma mark -
#pragma mark - UIScrollView delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    // 1: As soon as the user starts scrolling, you will want to suspend all operations and take a look at what the user wants to see.
    [self suspendAllOperations];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    // 2: If the value of decelerate is NO, that means the user stopped dragging the table view. Therefore you want to resume suspended operations, cancel operations for offscreen cells, and start operations for onscreen cells.
    if (!decelerate)
    {
        [self loadImagesForOnscreenCells];
        [self resumeAllOperations];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 3: This delegate method tells you that table view stopped scrolling, so you will do the same as in #2.
    [self loadImagesForOnscreenCells];
    [self resumeAllOperations];
}

#pragma mark -
#pragma mark - Cancelling, suspending, resuming queues / operations

- (void)suspendAllOperations
{
    [self.pendingOperations.downloadQueue setSuspended:YES];
    [self.pendingOperations.filtrationQueue setSuspended:YES];
}

- (void)resumeAllOperations
{
    [self.pendingOperations.downloadQueue setSuspended:NO];
    [self.pendingOperations.filtrationQueue setSuspended:NO];
}

- (void)cancelAllOperations
{
    [self.pendingOperations.downloadQueue cancelAllOperations];
    [self.pendingOperations.filtrationQueue cancelAllOperations];
}

- (void)loadImagesForOnscreenCells
{
    // 1: Get a set of visible rows.
    NSSet *visibleRows = [NSSet setWithArray:[self.tableView indexPathsForVisibleRows]];
    
    // 2: Get a set of all pending operations (download and filtration).
    NSMutableSet *pendingOperations = [NSMutableSet setWithArray:[self.pendingOperations.downloadsInProgress allKeys]];
    [pendingOperations addObjectsFromArray:[self.pendingOperations.filtrationsInProgress allKeys]];
    
    NSMutableSet *toBeCancelled = [pendingOperations mutableCopy];
    NSMutableSet *toBeStarted = [visibleRows mutableCopy];
    
    // 3: Rows (or indexPaths) that need an operation = visible rows ñ pendings.
    [toBeStarted minusSet:pendingOperations];
    
    // 4: Rows (or indexPaths) that their operations should be cancelled = pendings ñ visible rows.
    [toBeCancelled minusSet:visibleRows];
    
    // 5: Loop through those to be cancelled, cancel them, and remove their reference from PendingOperations.
    for (NSIndexPath *anIndexPath in toBeCancelled)
    {
        ImageDownloader *pendingDownload = [self.pendingOperations.downloadsInProgress objectForKey:anIndexPath];
        [pendingDownload cancel];
        [self.pendingOperations.downloadsInProgress removeObjectForKey:anIndexPath];
        
        ImageFiltration *pendingFiltration = [self.pendingOperations.filtrationsInProgress objectForKey:anIndexPath];
        [pendingFiltration cancel];
        [self.pendingOperations.filtrationsInProgress removeObjectForKey:anIndexPath];
    }
    toBeCancelled = nil;
    
    // 6: Loop through those to be started, and call startOperationsForPhotoRecord:atIndexPath: for each.
    for (NSIndexPath *anIndexPath in toBeStarted)
    {
        
        PhotoRecord *recordToProcess = [self.photos objectAtIndex:anIndexPath.row];
        [self startOperationsForPhotoRecord:recordToProcess atIndexPath:anIndexPath];
    }
    toBeStarted = nil;
}

@end