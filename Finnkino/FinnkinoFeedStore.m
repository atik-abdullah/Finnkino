//
//  FinnkinoFeedStore.m
//  Finnkino
//
//  Created by Abdullah Atik on 9/11/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//

#import "FinnkinoFeedStore.h"
#import "FinnkinoConnection.h"
#import "FinnkinoEvent.h"
#import "FinnkinoScheduleFirstLevelElement.h"
#import "JSONFirstLevelDict.h"
#import "JSONSecondLevelDict.h"
#import "Movie.h"
#import "FKNews.h"

@interface FinnkinoFeedStore ()

// Model data from completion block
@property (nonatomic, strong) NSManagedObjectModel *model;

// Array of Movie retrieved from core data
@property (nonatomic, strong) NSMutableArray *allItems;

@end

@implementation FinnkinoFeedStore
@synthesize fetchedResultsController = fetchedResultsController_;

+ (FinnkinoFeedStore *)sharedStore
{
    static FinnkinoFeedStore *feedStore = nil;
    if (!feedStore)
        feedStore = [[FinnkinoFeedStore alloc] init];
    return feedStore;
}

- (id)init
{
    self = [super init];
    if(self)
    {
        // Read in Homepwner.xcdatamodeld
        self.model = [NSManagedObjectModel mergedModelFromBundles:nil];
        // NSLog(@"model = %@", model);
        
        NSPersistentStoreCoordinator *psc =
        [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.model];
        
        // Where does the SQLite file go?
        NSString *path = [self itemArchivePath];
        NSURL *storeURL = [NSURL fileURLWithPath:path];
        
        NSError *error = nil;
        
        if (![psc addPersistentStoreWithType:NSSQLiteStoreType
                               configuration:nil
                                         URL:storeURL
                                     options:nil
                                       error:&error])
        {
            [NSException raise:@"Open failed"
                        format:@"Reason: %@", [error localizedDescription]];
        }
        
        // Create the managed object context
        self.context = [[NSManagedObjectContext alloc] init];
        [self.context setPersistentStoreCoordinator:psc];
        
        self.context.undoManager = [[NSUndoManager alloc] init];
        self.context.undoManager.levelsOfUndo = 999;
        
        [self loadAllItems];
    }
    return self;
}

#pragma mark - Network Request Handling

- (void)fetchRSSFeedWithCompletion:(void (^)(id obj, NSError *err))block forURLType:(ChangeURLType)URLType
{
    NSURL *url;
    NSURLRequest *req;
    FinnkinoConnection *connection;
    id model;
    
    if (URLType == EventURL)
    {
        // Movie event URL
        url = [NSURL URLWithString:[[NSMutableString alloc] initWithString:@"http://www.finnkino.fi/xml/Events"]];
        // Create an empty channel
        model = [[FinnkinoEvent alloc] init];
    }
    else if (URLType == ShowURL)
    {
        // Schedule URL
        url = [NSURL URLWithString:[[NSMutableString alloc] initWithString:@"http://www.finnkino.fi/xml/Schedule/"]];
        // Create an empty channel
        model = [[FinnkinoScheduleFirstLevelElement alloc] init];
    }
    else if (URLType == NewsCategoryURL)
    {
        url = [NSURL URLWithString:[[NSMutableString alloc] initWithString:@"http://www.finnkino.fi/xml/NewsCategories/"]];
        model = [[FKNews alloc] init];
    }
    else if (URLType == NewsURL)
    {
        url = [NSURL URLWithString:[[NSMutableString alloc] initWithString:@"http://www.finnkino.fi/xml/News/"]];
        model = [[FKNews alloc] init];
    }
    
    req = [NSURLRequest requestWithURL:url];
    
    // Create a connection "actor" object that will transfer data from the server
    connection = [[FinnkinoConnection alloc] initWithRequest:req];
    
    // When the connection completes, this block from the controller will be executed.
    [connection setCompletionBlock:block];
    
    // Let the empty channel parse the returning data from the web service
    [connection setXmlRootObject:model];
    
    [connection start];
}

- (void)fetchRottenTomatoesMovies:(int)count
                   withCompletion:(void (^)(id obj, NSError *err))block
                       forURLType: (ChangeURLType) URLType
{
    NSURL *url;
    if (URLType == RottenTomatoesBoxOfficeURL)
    {
        url = [NSURL URLWithString:[NSString stringWithFormat:
                                    @"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=43txzxgnzhrpwxrnbeam9dxa&limit=%d", count]];
    }
    else if (URLType == RottenTomatoesUpcomingURL)
    {
        url = [NSURL URLWithString:[NSString stringWithFormat:
                                    @"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/upcoming.json?apikey=43txzxgnzhrpwxrnbeam9dxa&limit=%d", count]];
    }
    else if (URLType == RottenTomatoesSearchURL)
    {
        url = [NSURL URLWithString:[NSString stringWithFormat:
                                    @"http://api.rottentomatoes.com/api/public/v1.0/movies.json?apikey=43txzxgnzhrpwxrnbeam9dxa&q=sky&limit=%d", count]];
    }
    else if (URLType == SelfMovieURL)
    {
        url = [NSURL URLWithString:[NSString stringWithFormat:
                                    @"http://api.rottentomatoes.com/api/public/v1.0/movies.json?apikey=43txzxgnzhrpwxrnbeam9dxa&q=sky&limit=%d", count]];
    }
    // Prepare a request URL, including the argument from the controller
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    
    // Set up the connection
    JSONFirstLevelDict *channel = [[JSONFirstLevelDict alloc] init];
    FinnkinoConnection *connection = [[FinnkinoConnection alloc] initWithRequest:req];
    [connection setCompletionBlock:block];
    [connection setJsonRootObject:channel];
    
    // Start
    [connection start];
}

- (void)fetchRottenTomatoesMoviesWithCompletion:(void (^)(id obj, NSError *err))block
                                         forURL: (NSString *) str
{
    NSString *stringWithParameter = [[NSString alloc] init];
    stringWithParameter = [stringWithParameter stringByAppendingString:str];
    stringWithParameter = [stringWithParameter stringByAppendingString:@"?apikey=43txzxgnzhrpwxrnbeam9dxa"];
    
    NSURL *url;
    url = [NSURL URLWithString:[NSString stringWithString:stringWithParameter]];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    JSONFirstLevelDict *channel = [[JSONFirstLevelDict alloc] init];
    
    FinnkinoConnection *connection = [[FinnkinoConnection alloc] initWithRequest:req];
    [connection setCompletionBlock:block];
    [connection setJsonRootObject:channel];
    
    [connection start];
}

#pragma mark - Database Handling

- (NSFetchedResultsController *)fetchedResultsController
{
    if (fetchedResultsController_ != nil)
    {
        return fetchedResultsController_;
    }
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Movie" inManagedObjectContext:self.context];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.context sectionNameKeyPath:nil cacheName:@"Master"];
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    return fetchedResultsController_;
}

- (BOOL)saveChanges
{
    NSError *err = nil;
    BOOL successful = [self.context save:&err];
    if (!successful)
    {
        NSLog(@"Error saving: %@", [err localizedDescription]);
    }
    return successful;
}

- (Movie *)createItem:(NSDictionary *) selection
      ForFavoriteType:(FavoriteType) FavType
{
    Movie *movie = [NSEntityDescription insertNewObjectForEntityForName:@"Movie"
                                                 inManagedObjectContext:self.context];
    
    movie.favoriteCategory = [NSNumber numberWithInt:FavType];
    movie.abridgedCast = [selection objectForKey:@"title"];
    movie.genres = [selection objectForKey:@"title"];
    movie.movieId = [selection objectForKey:@"movieId"];
    movie.detailed = [selection objectForKey:@"detailed"];
    movie.original = [selection objectForKey:@"original"];
    movie.profile = [selection objectForKey:@"profile"];
    movie.thumbnail = [selection objectForKey:@"thumbnail"];
    movie.audienceRating = [selection objectForKey:@"audRating"];
    movie.audienceScore = [selection objectForKey:@"audScore"];
    movie.criticsRating = [selection objectForKey:@"crRating"];
    movie.criticsScore = [selection objectForKey:@"crScore"];
    
    [self.allItems addObject:movie];
    
    return movie;
}

- (void)removeItem:(NSArray *) arrayOfIndexPaths
{
    if ([arrayOfIndexPaths count] > 0)
    {
        NSArray *selectedItemsIndexPaths = arrayOfIndexPaths;
        
        // Delete the managed object for the given index path
        for (NSIndexPath *indexPath in selectedItemsIndexPaths)
        {
            [self.context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        }
        
        // Save the context.
        NSError *error = nil;
        if (![self.context save:&error])
        {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Utilities

- (NSString *)itemArchivePath
{
    NSArray *documentDirectories =
    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                        NSUserDomainMask, YES);
    
    // Get one and only document directory from that list
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    
    return [documentDirectory stringByAppendingPathComponent:@"store.data"];
}

- (void)loadAllItems
{
    if (!self.allItems)
    {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *e = [[self.model entitiesByName] objectForKey:@"Movie"];
        [request setEntity:e];
        
        NSSortDescriptor *sd = [NSSortDescriptor
                                sortDescriptorWithKey:@"title"
                                ascending:YES];
        [request setSortDescriptors:[NSArray arrayWithObject:sd]];
        
        NSError *error;
        NSArray *result = [self.context executeFetchRequest:request error:&error];
        
        if (!result)
        {
            [NSException raise:@"Fetch failed"
                        format:@"Reason: %@", [error localizedDescription]];
        }
        self.allItems = [[NSMutableArray alloc] initWithArray:result];
    }
}

@end
