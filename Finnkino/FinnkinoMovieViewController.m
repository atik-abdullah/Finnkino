//
//  FinnkinoMovieViewController.m
//  Finnkino
//
//  Created by Abdullah Atik on 9/10/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//

#import "FinnkinoMovieViewController.h"
#import "FinnkinoEvent.h"
#import "FinnkinoOneMovieEvent.h"

@interface FinnkinoMovieViewController ()
@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSMutableData *xmlData;
@property (nonatomic, strong) FinnkinoEvent *finnkinoEvent;
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.finnkinoEvent movieItems] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"UITableViewCell"];
    }
    FinnkinoOneMovieEvent *oneMovieEvent = [[self.finnkinoEvent movieItems] objectAtIndex:[indexPath row]];
    [[cell textLabel] setText:[oneMovieEvent title]];
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
    // Create the parser object with the data received from the web service
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:self.xmlData];
    // Give it a delegate - ignore the warning here for now
    [parser setDelegate:self];
    // Tell it to start parsing - the document will be parsed and
    // the delegate of NSXMLParser will get all of its delegate messages
    // sent to it before this line finishes execution - it is blocking
    [parser parse];
    // Get rid of the XML data as we no longer need it
    self.xmlData = nil;
    // Get rid of the connection, no longer need it
    self.connection = nil;
    // Reload the table.. for now, the table will be empty.
    [[self tableView] reloadData];
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

#pragma mark NSXMLParser delegate methods

- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qualifiedName
    attributes:(NSDictionary *)attributeDict
{
    NSLog(@"%@ found a %@ element", self, elementName);
    if ([elementName isEqual:@"Events"])
    {
        // If the parser saw a channel, create new instance, store in our ivar
        self.finnkinoEvent = [[FinnkinoEvent alloc] init];
        
        // Give the channel object a pointer back to ourselves for later
        [self.finnkinoEvent setParentParserDelegate:self];
        
        // Set the parser's delegate to the channel object
        // There will be a warning here, ignore it warning for now
        [parser setDelegate:self.finnkinoEvent];
    }
}

@end
