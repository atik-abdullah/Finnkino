//
//  FinnkinoOneMovieEvent+TableRepresentation.m
//  Finnkino
//
//  Created by Abdullah Atik on 9/21/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//

#import "FinnkinoOneMovieEvent+TableRepresentation.h"

@implementation FinnkinoOneMovieEvent (TableRepresentation)

- (NSDictionary*) tr_tableRepresentation
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            self.title , @"title",
            self.movieSmallImagePortraitURL, @"movieSmallImagePortraitURL",
            self.movieMicroImagePortraitURL, @"movieMicroImagePortraitURL",
            self.movieLargeImagePortraitURL, @"movieLargeImagePortraitURL",
            self.movieSmallImageLandscapeURL, @"movieSmallImageLandscapeURL",
            self.movieLargeImagePortraitURL, @"movieLargeImagePortraitURL",
            self.contentDescriptorItems, @"contentDescriptorItems",
            self.movieTrailerURL, @"movieTrailerURL",
            nil];
}

@end
