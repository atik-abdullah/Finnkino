//
//  FinnkinoNewsViewController.m
//  Finnkino
//
//  Created by Abdullah Atik on 1/21/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//

#import "FinnkinoNewsViewController.h"
#import "FinnkinoNewsViewCell.h"
#import "FinnkinoFeedStore.h"
#import "FKNews.h"
#import "FKNewsArticle.h"
#import "FKNewsArticleCategory.h"
#import "ArticleEditViewController.h"

#define kHeadlineSectionHeight  26
#define kRegularSectionHeight   18

@interface FinnkinoNewsViewController ()
@property (nonatomic, strong) NSDictionary *newsDictionary;
@property (nonatomic, strong) FKNews *rootObjectForNewsCategory;
@property (nonatomic, strong) FKNews *rootObjectForNewsArticle;
@end

@implementation FinnkinoNewsViewController
{
    NSMutableArray *invokerStack;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView setBackgroundColor:kVerticalTableBackgroundColor];
    self.tableView.rowHeight = kCellHeight + (kRowVerticalPadding * 0.5) + ((kRowVerticalPadding * 0.5) * 0.5);
    [self fetchEntriesForNewsCategory];
    invokerStack = [[NSMutableArray alloc] init];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.newsDictionary.allKeys count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"NewsViewCell";
    FinnkinoNewsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil)
    {
        cell = [[FinnkinoNewsViewCell alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, tableView.frame.size.height)];
    }
    
    NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES selector:@selector(localizedCompare:)];
    NSArray* sortedCategories = [self.newsDictionary.allKeys sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    NSString *categoryName = [sortedCategories objectAtIndex:indexPath.section];
    NSMutableArray *currentCategory = [self.newsDictionary objectForKey:categoryName];
    cell.articles = currentCategory;
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 0 ? kHeadlineSectionHeight : kRegularSectionHeight;
}

// Implement - (NSString *)tableView:titleForHeaderInSection: instead if you don't want customized view
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *customSectionHeaderView;
    UILabel *titleLabel;
    UIFont *labelFont;
    UIButton *button;
    
    if (section == 0)
    {
        customSectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, kHeadlineSectionHeight)];
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, tableView.frame.size.width, kHeadlineSectionHeight)];
        labelFont = [UIFont boldSystemFontOfSize:20];
        UIImage *editImage = [UIImage imageNamed:@"edit-icon.png"];
        /* make button one pixel less high than customView above, to account for separator line */
        button = [[UIButton alloc] initWithFrame: CGRectMake(290, 0, 25, 25)];
        button.alpha = 0.7;
        [button setImage: editImage forState: UIControlStateNormal];
    }
    else
    {
        customSectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, kRegularSectionHeight)];
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, tableView.frame.size.width, kRegularSectionHeight)];
        labelFont = [UIFont boldSystemFontOfSize:13];
        UIImage *editImage = [UIImage imageNamed:@"edit-icon.png"];
        /* make button one pixel less high than customView above, to account for separator line */
        button = [[UIButton alloc] initWithFrame: CGRectMake(300, 0, 20, 20)];
        button.alpha = 0.7;
        [button setImage: editImage forState: UIControlStateNormal];
    }
    customSectionHeaderView.backgroundColor = [UIColor colorWithRed:0 green:0.40784314 blue:0.21568627 alpha:0.95];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    titleLabel.font = labelFont;
    
    NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES selector:@selector(localizedCompare:)];
    NSArray* sortedCategories = [self.newsDictionary.allKeys sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    NSString *categoryName = [sortedCategories objectAtIndex:section];
    titleLabel.text = [categoryName substringFromIndex:1];
    [customSectionHeaderView addSubview:titleLabel];
    [customSectionHeaderView addSubview: button];

    /* Prepare target-action */
    button.tag = section;
    [button addTarget: self action: @selector(headerTapped:)
     forControlEvents: UIControlEventTouchUpInside];
    NSMutableArray *currentCategory = [self.newsDictionary objectForKey:categoryName];

    NSMethodSignature *sig = [self methodSignatureForSelector:@selector(headerTappedInvoker:)];
    NSInvocation *undoAction = [NSInvocation invocationWithMethodSignature:sig];
    [undoAction setTarget:self];
    [undoAction setSelector:@selector(headerTappedInvoker:)];
    [undoAction setArgument:&currentCategory atIndex:2];
    [undoAction retainArguments];
    [invokerStack addObject:undoAction];
    
    return customSectionHeaderView;
}

#pragma mark- Utility Methods

- (void)fetchEntriesForNewsCategory
{
    void (^completionBlock)(FKNews *obj, NSError *err) = ^(FKNews *obj, NSError *err) {

        // When the request completes, this block will be called.
        if(!err)
        {
            // If everything went ok, grab the channel object and
            // reload the table.
            self.rootObjectForNewsCategory = obj;
            [self fetchEntriesForNews];
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
    [[FinnkinoFeedStore sharedStore] fetchRSSFeedWithCompletion:completionBlock forURLType:NewsCategoryURL];
}

- (void)fetchEntriesForNews
{
    void (^completionBlock)(FKNews *obj, NSError *err) = ^(FKNews *obj, NSError *err) {
        
        // When the request completes, this block will be called.
        if(!err)
        {
            // If everything went ok, grab the channel object and
            self.rootObjectForNewsArticle = obj;
            NSMutableDictionary *testDictionary = [[NSMutableDictionary alloc] init];
            
            for (FKNewsArticleCategory *aEvent in self.rootObjectForNewsCategory.articleCategoryItems)
            {
                NSMutableArray *testArray = [[NSMutableArray alloc] init];
                for (FKNewsArticle *bEvent in self.rootObjectForNewsArticle.articleItems)
                {
                    if ([[bEvent newsArticleCategoryName] isEqualToString: aEvent.categoryName])
                    {
                        [testArray addObject:bEvent.newsArticleDictionary];
                    }
                }
                [testDictionary setObject:testArray forKey:[aEvent categoryName]];
            }
            self.newsDictionary = testDictionary;
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
    [[FinnkinoFeedStore sharedStore] fetchRSSFeedWithCompletion:completionBlock forURLType:NewsURL];
}

#pragma mark - Touch Action

- (void) headerTapped: (UIButton*) sender
{
    /* do what you want in response to section header tap */
    NSInvocation *sendData = [invokerStack objectAtIndex:sender.tag];
    [sendData invoke];
}

- (void) headerTappedInvoker:(NSMutableArray *) article
{
    /* do what you want in response to section header tap */
    ArticleEditViewController *aevc = [[ArticleEditViewController alloc] init];
    aevc.articles = article;
    [self.navigationController pushViewController:aevc animated:YES];
}

@end
