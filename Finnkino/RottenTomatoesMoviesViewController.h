//
//  RottenTomatoesMoviesViewController.h
//  Finnkino
//
//  Created by Abdullah Atik on 1/18/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum
{
    BoxOfficeURL,
    TopMoviesURL,
    SearchMovieURL
} ListViewControllerRSSType;

@interface RottenTomatoesMoviesViewController : UITableViewController
{
    ListViewControllerRSSType rssType;
}

-(IBAction)changeType:(id)sender;

@end