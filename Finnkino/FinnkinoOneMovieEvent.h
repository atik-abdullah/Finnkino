//
//  FinnkinoOneMovieEvent.h
//  Finnkino
//
//  Created by Abdullah Atik on 9/10/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FinnkinoOneMovieEvent : NSObject <NSXMLParserDelegate>

@property (nonatomic, weak) id parentParserDelegate;
@property (nonatomic, strong) NSMutableString *title;

@end
