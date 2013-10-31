//
//  RottenTomatoesMoviesViewController.h
//  Finnkino
//
//  Created by Abdullah Atik on 1/18/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PendingOperations.h"
#import "ImageDownloader.h"
#import "ImageFiltration.h"

typedef enum
{
    BoxOfficeURL,
    UpcomingURL,
    SearchMovieURL
} ListViewControllerRSSType;

@interface RottenTomatoesMoviesViewController : UITableViewController <ImageDownloaderDelegate, ImageFiltrationDelegate>
{
    ListViewControllerRSSType rssType;
}

-(IBAction)changeType:(id)sender;

@end
