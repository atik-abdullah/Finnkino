//
//  RTPosterViewController.m
//  Finnkino
//
//  Created by Abdullah Atik on 10/7/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//

#import "RTPosterViewController.h"
#import "JSONSecondLevelDict.h"
#import "ImageTransformFilter.h"
#import "ImageShadowFilter.h"
#import "DecoratorView.h"
#import "JSONThirdLevelDict.h"

@interface RTPosterViewController ()

@end

@implementation RTPosterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSURL *urlFromString = [[NSURL alloc] initWithString:[[self.selection postersDetailed] postersDetailed]] ;
    NSData *data = [NSData dataWithContentsOfURL:urlFromString];
    UIImage *image = [UIImage imageWithData:data];
    
    // create a transformation

    CGAffineTransform translateTransform = CGAffineTransformMakeTranslation(-image.size.width / 5.0,
                                                                            image.size.height / 8.0);
    CGAffineTransform scaleTransform = CGAffineTransformScale(translateTransform, .75, .75);
    CGAffineTransform rotateTransform = CGAffineTransformMakeRotation(-M_PI / 10.0);

    CGAffineTransform finalTransform = CGAffineTransformConcat(scaleTransform, rotateTransform);
    
    // Create decorator classes
    id <ImageComponent> transformedImage = [[ImageTransformFilter alloc] initWithImageComponent:image transform:finalTransform];
    id <ImageComponent> finalImage = [[ImageShadowFilter alloc] initWithImageComponent:transformedImage];
        
    DecoratorView *decoratorView = [[DecoratorView alloc] initWithFrame:CGRectMake(25, 25, self.view.frame.size.width/1.2, self.view.frame.size.height/1.2)];
    [decoratorView setImage:(UIImage*)finalImage];
    [self.view addSubview:decoratorView];
}



@end
