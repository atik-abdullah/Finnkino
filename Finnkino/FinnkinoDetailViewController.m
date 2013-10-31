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
#import "FinnkinoShowTimeViewController.h"

@interface FinnkinoDetailViewController ()

@end

@implementation FinnkinoDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.label.text = [self.selection objectForKey:@"title"];
    [self configureImage];
    [self configureContentDescriptor];
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *dvc = segue.destinationViewController;
    
    if ([dvc respondsToSelector:@selector(setSelection:)])
    {
        // prepare selection info
        [dvc setValue:self.selection forKey:@"selection"];
    }
    
}

#pragma mark - Private

- (void)configureImage
{
    NSURL *urlFromString = [[NSURL alloc] initWithString:[self.selection objectForKey:@"movieLargeImagePortraitURL"]] ;
    NSData *data = [NSData dataWithContentsOfURL:urlFromString];
    UIImage *image = [UIImage imageWithData:data];
    [self.largeImageView setImage:image];
}

- (void)configureContentDescriptor
{
    NSArray *receivedContentDescriptorItems = [[NSArray alloc] initWithArray:[self.selection objectForKey:@"contentDescriptorItems"]];
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

@end
