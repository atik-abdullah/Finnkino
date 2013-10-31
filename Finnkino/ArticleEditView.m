//
//  ArticleEditView.m
//  Finnkino
//
//  Created by Abdullah Atik on 10/28/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//

#import "ArticleEditView.h"

@implementation ArticleEditView
{
    UIImageView *coverImage;
    UIActivityIndicatorView *indicator;
}

- (id)initWithFrame:(CGRect)frame articleCover:(NSString*)articleCover
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor blackColor];
        // the coverImage has a 5 pixels margin from its frame
        coverImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, frame.size.width-10, frame.size.height-10)];
        [self addSubview:coverImage];
        
        indicator = [[UIActivityIndicatorView alloc] init];
        indicator.center = self.center;
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        [indicator startAnimating];
        [self addSubview:indicator];
        
        
        dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        
        dispatch_async(concurrentQueue, ^{
            NSURL *urlFromString = [[NSURL alloc] initWithString:articleCover] ;
            NSData *data = [NSData dataWithContentsOfURL:urlFromString];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [coverImage setImage:[UIImage imageWithData:data]];
                [indicator stopAnimating];
            });
        });
        
    }
    return self;
}

@end
