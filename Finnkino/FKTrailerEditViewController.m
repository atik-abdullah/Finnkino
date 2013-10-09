//
//  FKTrailerEditViewController.m
//  Finnkino
//
//  Created by Abdullah Atik on 10/9/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//

#import "FKTrailerEditViewController.h"
#import "FinnkinoConnection.h"

@interface FKTrailerEditViewController ()

@end

@implementation FKTrailerEditViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:[self.selection objectForKey:@"movieTrailerURL"]]];
    [self fetchEntriesWithRequest:req];
}

#pragma mark - Utility Methods
- (void)fetchEntriesWithRequest:(NSURLRequest *) req
{
    UIView *currentTitleView = [[self navigationItem] titleView];
    UIActivityIndicatorView *aiView = [[UIActivityIndicatorView alloc]
                                       initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [[self navigationItem] setTitleView:aiView];
    [aiView startAnimating];
    
    
    void (^completionBlock)( id obj, NSError *err) = ^(id obj, NSError *err)
    {
        // When the request completes, this block will be called.
        [[self navigationItem] setTitleView:currentTitleView];
        
        if(!err)
        {
            // If everything went ok, grab the data
            if (obj)
            {
                [self writeToFile:obj];
            }
            // Reload the table.
        }
        else
        {
            // If things went bad, show an alert view
            NSString *errorString = [NSString stringWithFormat:@"Fetch failed: %@",
                                     [err localizedDescription]];
            
            // Create and show an alert view with this error displayed
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error"
                                                         message:errorString
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
            [av show];
        }
    };
    
    FinnkinoConnection *connection = [[FinnkinoConnection alloc] initWithRequest:req];
    [connection setCompletionBlock:completionBlock];
    [connection start];
    
}

- (void)writeToFile:(NSData *) object
{
    NSScanner *scanner = [NSScanner scannerWithString:[self.selection objectForKey:@"movieTrailerURL"]];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString  *documentsDirectory = [paths objectAtIndex:0];
    NSString  *filePath;
    
    // Scan past the "http:// " before the magnitude.
    if ([scanner scanString:@"http://" intoString:NULL])
    {
        NSString *location = nil;
        if ([scanner scanUpToCharactersFromSet:
             [NSCharacterSet illegalCharacterSet] intoString:&location])
        {
            // fin.clip-1.filmtrailer.com/11195_41463_a_6.mp4 remove the slash "/" from the string
            // otherwise it will be treated as file under directory "fin.clip-1.filmtrailer.com"
            NSArray * array = [location componentsSeparatedByString:@"/"];
            if (array)
            {
                NSString * desiredString = (NSString *)[array lastObject]; //or whichever the index
                filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,desiredString];
            }
        }
    }
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        [object writeToFile:filePath atomically:YES];
    }
}

@end
