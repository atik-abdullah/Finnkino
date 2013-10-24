//
//  FKNewsArticle.h
//  Finnkino
//
//  Created by Abdullah Atik on 10/23/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FKNewsArticle : NSObject <NSXMLParserDelegate>

@property (nonatomic, weak) id parentParserDelegate;

@property (nonatomic, strong) NSString *newsArticleTitle;
@property (nonatomic, strong) NSString *newsArticlePublishDate;
@property (nonatomic, strong) NSString *newsArticleImageURL;
@property (nonatomic, strong) NSString *newsArticleCategoryName;
@property (nonatomic, strong) NSMutableDictionary *newsArticleDictionary;

@end
