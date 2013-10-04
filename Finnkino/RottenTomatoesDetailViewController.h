//
//  RottenTomatoesDetailAndTableViewController.h
//  Finnkino
//
//  Created by Abdullah Atik on 1/20/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JSONSecondLevelDict;
@interface RottenTomatoesDetailViewController : UITableViewController

@property IBOutlet UILabel *movieNamelabel;
@property IBOutlet UILabel *criticsScore;
@property IBOutlet UILabel *audienceScore;
@property IBOutlet UILabel *actorNameLabel;
@property IBOutlet UILabel *releaseDateTheaterLabel;
@property IBOutlet UILabel *runTimeLabel;
@property IBOutlet UILabel *genreLabel;
@property (nonatomic, strong) JSONSecondLevelDict *selection;
@property (nonatomic, weak) IBOutlet UIImageView *profileImageView;
@property (nonatomic, weak) IBOutlet UIView *myButtonView;

@end
