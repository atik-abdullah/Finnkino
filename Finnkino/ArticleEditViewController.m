//
//  ArticleEditViewController.m
//  Finnkino
//
//  Created by Abdullah Atik on 10/28/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//

#import "ArticleEditViewController.h"
#import "FinnkinoNewsViewController.h"

@interface ArticleEditViewController ()

@end

@implementation ArticleEditViewController
{
    UITableView *dataTable;
    
    NSDictionary *currentArticleData;
    int currentArticleIndex;
    HorizontalScrollerView *scroller;
    
    UIToolbar *toolbar;
    // We will use this array as a stack to push and pop operation for the undo option
    NSMutableArray *undoStack;
    
    // We don't want to pollute main data source "articles"
    NSMutableArray *operatedArticles;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // 1
    self.view.backgroundColor = [UIColor colorWithRed:0.76f green:0.81f blue:0.87f alpha:1];
    currentArticleIndex = 0;
    
    //2
    operatedArticles = self.articles;

    // Set up tableview that presents the article data
    dataTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 120, self.view.frame.size.width, self.view.frame.size.height-120) style:UITableViewStyleGrouped];
    dataTable.delegate = self;
    dataTable.dataSource = self;
    dataTable.backgroundView = nil;
    [self.view addSubview:dataTable];
    
    // Set up horizontal scroller view
    scroller = [[HorizontalScrollerView alloc] initWithFrame:CGRectMake(0, 70, self.view.frame.size.width, 120)];
    scroller.backgroundColor = [UIColor colorWithRed:0.24f green:0.35f blue:0.49f alpha:1];
    scroller.delegate = self;
    [self.view addSubview:scroller];
    
    [self showDataForArticleAtIndex:currentArticleIndex];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveCurrentState) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    // Set up toolbar
    toolbar = [[UIToolbar alloc] init];
    UIBarButtonItem *undoItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemUndo target:self action:@selector(undoAction)];
    undoItem.enabled = NO;
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *delete = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteArticle)];
    [toolbar setItems:@[undoItem,space,delete]];
    [self.view addSubview:toolbar];
    undoStack = [[NSMutableArray alloc] init];
}

- (void)viewWillLayoutSubviews
{
    toolbar.frame = CGRectMake(0, self.view.frame.size.height-94, self.view.frame.size.width, 44);
    dataTable.frame = CGRectMake(0, 130, self.view.frame.size.width, self.view.frame.size.height - 200);
}

- (void)reloadScroller
{
    operatedArticles = self.articles;
    if (currentArticleIndex < 0) currentArticleIndex = 0;
    else if (currentArticleIndex >= operatedArticles.count) currentArticleIndex = operatedArticles.count-1;
    [scroller reload];
    
    [self showDataForArticleAtIndex:currentArticleIndex];
}

- (void)showDataForArticleAtIndex:(int)articleIndex
{
    // defensive code: make sure the requested index is lower than the amount of article
    if (articleIndex < operatedArticles.count)
    {
        // save the articles data to present it later in the tableview
        currentArticleData = operatedArticles[articleIndex];
    }
    else
    {
        currentArticleData = nil;
    }
    
    // we have the data we need, let's refresh our tableview
    [dataTable reloadData];
}

- (void)addArticle:(NSDictionary*)article atIndex:(int)index
{
    [operatedArticles insertObject:article atIndex:index];
    [self reloadScroller];
}

- (void)deleteArticle
{
    // 1
    NSDictionary *deletedArticle = operatedArticles[currentArticleIndex];
    
    // 2
    NSMethodSignature *sig = [self methodSignatureForSelector:@selector(addArticle:atIndex:)];
    NSInvocation *undoAction = [NSInvocation invocationWithMethodSignature:sig];
    [undoAction setTarget:self];
    [undoAction setSelector:@selector(addArticle:atIndex:)];
    [undoAction setArgument:&deletedArticle atIndex:2];
    [undoAction setArgument:&currentArticleIndex atIndex:3];
    [undoAction retainArguments];
    
    // 3
    [undoStack addObject:undoAction];
    
    // 4
    [operatedArticles removeObjectAtIndex:currentArticleIndex];
    [self reloadScroller];
    
    // 5
    [toolbar.items[0] setEnabled:YES];
}

- (void)undoAction
{
    if (undoStack.count > 0)
    {
        NSInvocation *undoAction = [undoStack lastObject];
        [undoStack removeLastObject];
        [undoAction invoke];
    }
    
    if (undoStack.count == 0)
    {
        [toolbar.items[0] setEnabled:NO];
    }
}

#pragma mark - UITableViewDelegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = @"Title";
    cell.detailTextLabel.text = @"Title";
    
    return cell;
}

#pragma mark - HorizontalScrollerDelegate methods

- (void)horizontalScroller:(HorizontalScrollerView *)scroller clickedViewAtIndex:(int)index
{
    currentArticleIndex = index;
    [self showDataForArticleAtIndex:index];
}

- (NSInteger)numberOfViewsForHorizontalScroller:(HorizontalScrollerView *)scroller
{
    return operatedArticles.count;
}

- (UIView*)horizontalScroller:(HorizontalScrollerView *)scroller viewAtIndex:(int)index
{
    NSDictionary *article = operatedArticles[index];
    return [[ArticleEditView alloc] initWithFrame:CGRectMake(0, 0, 100, 100) articleCover:[article objectForKey:@"ImageURL" ]];
}

- (NSInteger)initialViewIndexForHorizontalScroller:(HorizontalScrollerView *)scroller
{
    return currentArticleIndex;
}

@end
