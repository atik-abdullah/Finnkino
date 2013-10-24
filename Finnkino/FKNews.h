//
//  FKNews.h
//  Finnkino
//
//  Created by Abdullah Atik on 10/23/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FKNews : NSObject <NSXMLParserDelegate>

@property (nonatomic, strong) NSMutableArray *articleItems;
@property (nonatomic, strong) NSMutableArray *articleCategoryItems;

@end
