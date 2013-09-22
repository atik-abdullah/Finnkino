//
//  FinnkinoEvent+TableRepresentation.m
//  Finnkino
//
//  Created by Abdullah Atik on 9/21/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//

#import "FinnkinoEvent+TableRepresentation.h"
#import "FinnkinoOneMovieEvent+TableRepresentation.h"

@implementation FinnkinoEvent (TableRepresentation)

- (NSDictionary*) tr_tableRepresentation
{
    // Holds one single movie information
    NSDictionary *aMovieInformationDict;
    NSMutableArray *arrayOfMovies = [[NSMutableArray alloc] init];
    
    // Convert each movie information to dictionary
    for (FinnkinoOneMovieEvent *aMovie in [self sortedMovieItems])
    {
        aMovieInformationDict = [aMovie tr_tableRepresentation];
        
        // Create an array of dictionary(aMovieInformationDict)
        [arrayOfMovies addObject:aMovieInformationDict];
    }

    NSMutableArray *sectionNames = [NSMutableArray array];
    NSMutableArray *sectionData = [NSMutableArray array];
    
    NSString* previous = @"";
    
    // From one long list of array divide them into small chunk of arrays and then add the small chunks to an array , the output is an array of arrays.
    for (NSDictionary* aMovieDictionary in arrayOfMovies)
    {
        
        // Each title having common first letter belongs to one smaller chunk
        NSString* c = [[aMovieDictionary objectForKey:@"title" ] substringToIndex:1];
        
        // If a different letter encountered than previous begin a new smaller chunk
        if (![c isEqualToString: previous])
        {
            previous = c;
            [sectionNames addObject: [c uppercaseString]];
            NSMutableArray* oneSection = [NSMutableArray array];
            [sectionData addObject: oneSection];
        }
        
        // If same letter encountered keep adding to the same small chunk
        [[sectionData lastObject] addObject: aMovieDictionary];
    }
    
    return [NSDictionary dictionaryWithObjectsAndKeys:sectionData , @"sectionData", sectionNames, @"sectionNames", nil];
}

@end
