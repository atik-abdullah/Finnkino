//
//  FinnkinoDetailViewController.h
//  Finnkino
//
//  Created by Abdullah Atik on 1/16/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FinnkinoDetailViewController : UITableViewController

@property (nonatomic, weak) IBOutlet UILabel *label;
@property (nonatomic, weak) IBOutlet UIImageView *largeImageView;
@property (nonatomic, weak) IBOutlet UIView *myView;
@property (nonatomic, copy) NSDictionary *selection;

@end
