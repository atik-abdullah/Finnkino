//
//  ArticleEditViewController.h
//  Finnkino
//
//  Created by Abdullah Atik on 10/28/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HorizontalScrollerView.h"
#import "ArticleEditView.h"

@class FinnkinoNewsViewController;
@interface ArticleEditViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, HorizontalScrollerDelegate>

@property (nonatomic, retain) NSMutableArray *articles;

@end
