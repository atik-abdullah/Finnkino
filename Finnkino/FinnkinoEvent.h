//
//  FinnkinoEvent.h
//  Finnkino
//
//  Created by Abdullah Atik on 9/10/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FinnkinoOneMovieEvent;

@interface FinnkinoEvent : NSObject <NSXMLParserDelegate, NSCoding>

@property (nonatomic, strong) NSMutableArray *movieItems;
@property (nonatomic, weak) id parentParserDelegate;

// Holds movies sorted alphabetically
@property (nonatomic, strong) NSArray *sortedMovieItems;
@end
