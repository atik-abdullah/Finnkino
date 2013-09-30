//
//  FinnkinoScheduleSecondLevelElement.h
//  Finnkino
//
//  Created by Abdullah Atik on 9/30/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FinnkinoScheduleSecondLevelElement : NSObject <NSXMLParserDelegate>

@property (nonatomic, weak) id parentParserDelegate;
@property (nonatomic, strong) NSMutableString *theatreAndAuditorium;
@property (nonatomic, strong) NSString *showTitle;

@end
