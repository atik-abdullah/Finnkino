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
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *movieMicroImagePortraitURL;
@property (nonatomic, strong) NSString *movieSmallImagePortraitURL;
@property (nonatomic, strong) NSString *movieLargeImagePortraitURL;
@property (nonatomic, strong) NSString *movieSmallImageLandscapeURL;
@property (nonatomic, strong) NSString *movieLargeImageLandscapeURL;
@property (nonatomic, strong) NSMutableArray *contentDescriptorItems;
@end
