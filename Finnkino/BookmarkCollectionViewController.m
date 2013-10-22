//
//  BookmarkCollectionViewController.m
//  Finnkino
//
//  Created by Abdullah Atik on 10/17/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "BookmarkCollectionViewController.h"
#import "FinnkinoFeedStore.h"
#import "BookmarkViewCell.h"

#define SYSBARBUTTON(ITEM, SELECTOR) [[UIBarButtonItem alloc] initWithBarButtonSystemItem:ITEM target:self action:SELECTOR]

static NSString *CellIdentifier = @"BookmarkViewCell";

@interface BookmarkCollectionViewController ()

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property(nonatomic) BOOL editing;
@property(nonatomic, strong) NSMutableArray *selectedMovies;
@property(nonatomic) UIToolbar *toolbar;

- (IBAction)editButtonTapped:(id)sender;

@end

@implementation BookmarkCollectionViewController
{
    NSMutableArray *_objectChanges;
    NSMutableArray *_sectionChanges;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.fetchedResultsController = [[FinnkinoFeedStore sharedStore] fetchedResultsController];
    self.fetchedResultsController.delegate = self;
    self.context = [[FinnkinoFeedStore sharedStore] context];
    _objectChanges = [NSMutableArray array];
    _sectionChanges = [NSMutableArray array];
    self.selectedMovies = [@[] mutableCopy];

    self.toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 100.0f, 45.0f)];
    self.toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.navigationItem.titleView = self.toolbar;
    [self setBarButtonItems];
}

#pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BookmarkViewCell *cell = (BookmarkViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSURL *urlFromString = [[NSURL alloc] initWithString:[object valueForKey:@"detailed"]] ;
    NSData *data = [NSData dataWithContentsOfURL:urlFromString];
    [cell setImage:[UIImage imageWithData:data]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(!self.editing)
    {
        [self.collectionView deselectItemAtIndexPath:indexPath animated:YES];
    }
    else
        [self.selectedMovies addObject:indexPath];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.editing)
        [self.selectedMovies removeObject:indexPath];
}

#pragma mark - NSFetchedResultsController Delegate
- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    
    NSMutableDictionary *change = [NSMutableDictionary new];
    
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            change[@(type)] = @(sectionIndex);
            break;
        case NSFetchedResultsChangeDelete:
            change[@(type)] = @(sectionIndex);
            break;
    }
    
    [_sectionChanges addObject:change];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    NSMutableDictionary *change = [NSMutableDictionary new];
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            change[@(type)] = newIndexPath;
            break;
        case NSFetchedResultsChangeDelete:
            change[@(type)] = indexPath;
            break;
        case NSFetchedResultsChangeUpdate:
            change[@(type)] = indexPath;
            break;
        case NSFetchedResultsChangeMove:
            change[@(type)] = @[indexPath, newIndexPath];
            break;
    }
    [_objectChanges addObject:change];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    if ([_sectionChanges count] > 0)
    {
        [self.collectionView performBatchUpdates:^{
            
            for (NSDictionary *change in _sectionChanges)
            {
                [change enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, id obj, BOOL *stop) {
                    
                    NSFetchedResultsChangeType type = [key unsignedIntegerValue];
                    switch (type)
                    {
                        case NSFetchedResultsChangeInsert:
                            [self.collectionView insertSections:[NSIndexSet indexSetWithIndex:[obj unsignedIntegerValue]]];
                            break;
                        case NSFetchedResultsChangeDelete:
                            [self.collectionView deleteSections:[NSIndexSet indexSetWithIndex:[obj unsignedIntegerValue]]];
                            break;
                        case NSFetchedResultsChangeUpdate:
                            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:[obj unsignedIntegerValue]]];
                            break;
                    }
                }];
            }
        } completion:nil];
    }
    
    if ([_objectChanges count] > 0 && [_sectionChanges count] == 0)
    {
        [self.collectionView performBatchUpdates:^{
            
            for (NSDictionary *change in _objectChanges)
            {
                [change enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, id obj, BOOL *stop) {
                    
                    NSFetchedResultsChangeType type = [key unsignedIntegerValue];
                    switch (type)
                    {
                        case NSFetchedResultsChangeInsert:
                            [self.collectionView insertItemsAtIndexPaths:@[obj]];
                            break;
                        case NSFetchedResultsChangeDelete:
                            [self.collectionView deleteItemsAtIndexPaths:@[obj]];
                            break;
                        case NSFetchedResultsChangeUpdate:
                            [self.collectionView reloadItemsAtIndexPaths:@[obj]];
                            break;
                        case NSFetchedResultsChangeMove:
                            [self.collectionView moveItemAtIndexPath:obj[0] toIndexPath:obj[1]];
                            break;
                    }
                }];
            }
        } completion:nil];
    }
    
    [_sectionChanges removeAllObjects];
    [_objectChanges removeAllObjects];
}

#pragma mark - IBAction

-(IBAction)editButtonTapped:(id)sender
{
    UIBarButtonItem *shareButton = (UIBarButtonItem *)sender;

    // 1
    if (!self.editing)
    {
        self.editing = YES;
        [shareButton setStyle:UIBarButtonItemStyleDone];
        [shareButton setTitle:@"Delete"];
        [self.collectionView setAllowsMultipleSelection:YES];
    }
    else
    {
        // 2
        self.editing = NO;
        [shareButton setStyle:UIBarButtonItemStyleBordered];
        [shareButton setTitle:@"Edit"];
        [self.collectionView setAllowsMultipleSelection:NO];

        // 3
        [[FinnkinoFeedStore sharedStore] removeItem:self.selectedMovies];
        [self setBarButtonItems];
        
        // 4
        for(NSIndexPath *indexPath in self.collectionView.indexPathsForSelectedItems)
        {
            [self.collectionView deselectItemAtIndexPath:indexPath animated:NO];
        }
        [self.selectedMovies removeAllObjects];
    }
}

- (void) undo
{
    [self.context.undoManager undo];
    [self setBarButtonItems];
}

- (void) redo
{
    [self.context.undoManager redo];
    [self setBarButtonItems];
}

#pragma mark - Utility methods

- (void) setBarButtonItems
{
    NSMutableArray *items = [NSMutableArray array];
    UIBarButtonItem *spacer = SYSBARBUTTON(UIBarButtonSystemItemFlexibleSpace, nil);
    [items addObject:spacer];

    UIBarButtonItem *undo = SYSBARBUTTON(UIBarButtonSystemItemUndo, @selector(undo));
    undo.enabled = self.context.undoManager.canUndo;
    [items addObject:undo];
    [items addObject:spacer];
    
    UIBarButtonItem *redo = SYSBARBUTTON(UIBarButtonSystemItemRedo, @selector(redo));
    redo.enabled = self.context.undoManager.canRedo;
    [items addObject:redo];
    [items addObject:spacer];    
    self.toolbar.items = items;
}

@end
