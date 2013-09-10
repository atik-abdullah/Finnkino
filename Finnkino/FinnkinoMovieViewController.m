//
//  FinnkinoMovieViewController.m
//  Finnkino
//
//  Created by Abdullah Atik on 9/10/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//

#import "FinnkinoMovieViewController.h"

@interface FinnkinoMovieViewController ()

@end

@implementation FinnkinoMovieViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fetchEntries];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}

#pragma mark - Utility methods

- (void)fetchEntries
{
    // Create a new data container for the stuff that comes back from the service
    self.xmlData = [[NSMutableData alloc] init];
    
    // Construct a URL that will ask the service for what you want -
    NSURL *url = [NSURL URLWithString:@"http://www.finnkino.fi/xml/Events"];
 
    // Put that URL into an NSURLRequest
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
   
    // Create a connection that will exchange this request for data from the URL
    self.connection = [[NSURLConnection alloc] initWithRequest:req
                                                 delegate:self
                                         startImmediately:YES];
}

#pragma mark - Connection delegate methods

- (void)connection:(NSURLConnection *)conn didReceiveData:(NSData *)data
{
    [self.xmlData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)conn
{
    // We are just checking to make sure we are getting the XML
    NSString *xmlCheck = [[NSString alloc] initWithData:self.xmlData
                                               encoding:NSUTF8StringEncoding];
    NSLog(@"xmlCheck = %@", xmlCheck);
}

- (void)connection:(NSURLConnection *)conn
  didFailWithError:(NSError *)error
{
    // Release the connection object, we're done with it
    self.connection = nil;
    
    // Release the xmlData object, we're done with it
    self.xmlData = nil;
    
    // Grab the description of the error object passed to us
    NSString *errorString = [NSString stringWithFormat:@"Fetch failed: %@",
                             [error localizedDescription]];
    
    // Create and show an alert view with this error displayed
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error"
                                                 message:errorString
                                                delegate:nil
                                       cancelButtonTitle:@"OK"
                                       otherButtonTitles:nil];
    [av show];
}

@end
