//
//  FKNewsArticleCategory.h
//  Finnkino
//
//  Created by Abdullah Atik on 10/23/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FKNewsArticleCategory : NSObject <NSXMLParserDelegate>

@property (nonatomic, weak) id parentParserDelegate;

@property (nonatomic, strong) NSString *categoryID;
@property (nonatomic, strong) NSString *categoryName;

@end
