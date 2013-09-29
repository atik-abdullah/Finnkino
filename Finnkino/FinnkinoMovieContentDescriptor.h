//
//  FinnkinoMovieContentDescriptor.h
//  Finnkino
//
//  Created by Abdullah Atik on 1/16/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FinnkinoMovieContentDescriptor: NSObject <NSXMLParserDelegate>

@property (nonatomic, weak) id parentParserDelegate;
@property (nonatomic, strong) NSMutableString *contentURL;

@end
