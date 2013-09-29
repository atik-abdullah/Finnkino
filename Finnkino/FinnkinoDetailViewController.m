//
//  FinnkinoDetailViewController.m
//  Finnkino
//
//  Created by Abdullah Atik on 1/16/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//

#import "FinnkinoDetailViewController.h"
#import "FinnkinoMovieContentDescriptor.h"
#import "FinnkinoFeedStore.h"
#import "FinnkinoEvent.h"

@interface FinnkinoDetailViewController ()

@end

@implementation FinnkinoDetailViewController
@synthesize selection;
@synthesize largeImageView;
@synthesize myView;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
        self.navigationController.navigationBarHidden = NO;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.label.text = [selection objectForKey:@"title"];
    
    NSURL *urlFromString = [[NSURL alloc] initWithString:[selection objectForKey:@"movieLargeImagePortraitURL"]] ;
    NSData *data = [NSData dataWithContentsOfURL:urlFromString];
    self.largeImageView.image = [UIImage imageWithData:data];
    NSArray *receivedContentDescriptorItems = [[NSArray alloc] initWithArray:[selection objectForKey:@"contentDescriptorItems"]];
    int x = 0;
    int y = 0;
    
    for (FinnkinoMovieContentDescriptor *movieContentDescriptor in receivedContentDescriptorItems)
    {
        NSString  *imageURLString = [[NSString alloc] initWithString: movieContentDescriptor.contentURL];
        
        NSURL *urlFromString = [[NSURL alloc] initWithString:imageURLString] ;
        NSData *data = [NSData dataWithContentsOfURL:urlFromString];
        UIImage *myImage = [UIImage imageWithData:data];
        UIImageView *myImageView = [[UIImageView alloc] initWithImage:myImage];
        [myImageView setFrame:CGRectMake(150+x, 150+y, 30, 30)];
        [self.myView addSubview:myImageView];
        x= 40;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
