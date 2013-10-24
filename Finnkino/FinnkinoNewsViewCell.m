//
//  FinnkinoNewsViewCell.m
//  Finnkino
//
//  Created by Abdullah Atik on 1/21/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//

#import "FinnkinoNewsViewCell.h"
#import "FinnkinoInnerTableCell.h"

@implementation FinnkinoNewsViewCell

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        self.tableViewForOtherTableViewsCell = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kCellHeight, kTableLength)];
        self.tableViewForOtherTableViewsCell.showsVerticalScrollIndicator = NO;
        self.tableViewForOtherTableViewsCell.showsHorizontalScrollIndicator = NO;
        self.tableViewForOtherTableViewsCell.transform = CGAffineTransformMakeRotation(-M_PI * 0.5);
        [self.tableViewForOtherTableViewsCell setFrame:CGRectMake(kRowHorizontalPadding * 0.5, kRowVerticalPadding * 0.5, kTableLength - kRowHorizontalPadding, kCellHeight)];
        
        self.tableViewForOtherTableViewsCell.rowHeight = kCellWidth;
        self.tableViewForOtherTableViewsCell.backgroundColor = kHorizontalTableBackgroundColor;
        
        self.tableViewForOtherTableViewsCell.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.tableViewForOtherTableViewsCell.separatorColor = [UIColor clearColor];
        
        self.tableViewForOtherTableViewsCell.dataSource = self;
        self.tableViewForOtherTableViewsCell.delegate = self;
        [self addSubview:self.tableViewForOtherTableViewsCell];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.articles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"NewsCell";
    
    FinnkinoInnerTableCell *cell = (FinnkinoInnerTableCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[FinnkinoInnerTableCell alloc] initWithFrame:CGRectMake(0, 0, kCellWidth, kCellHeight)];
    }
    __block NSDictionary *currentArticle = [self.articles objectAtIndex:indexPath.row];
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(concurrentQueue, ^{
        NSURL *urlFromString = [[NSURL alloc] initWithString:[currentArticle objectForKey:@"ImageURL"]] ;
        NSData *data = [NSData dataWithContentsOfURL:urlFromString];
        UIImage *myImage = [UIImage imageWithData:data];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.newsImage.image = myImage;
        });
    });
    cell.newstitleLabel.text = [currentArticle objectForKey:@"Title"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.articles removeObjectAtIndex:indexPath.row];
    [self.tableViewForOtherTableViewsCell reloadData];
}

@end
