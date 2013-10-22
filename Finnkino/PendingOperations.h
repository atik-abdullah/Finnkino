//
//  PendingOperations.h
//  ClassicPhotos
//
//  Created by Abdullah Atik on 1/18/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PendingOperations : NSObject

@property (nonatomic, strong) NSMutableDictionary *downloadsInProgress;
@property (nonatomic, strong) NSOperationQueue *downloadQueue;

@property (nonatomic, strong) NSMutableDictionary *filtrationsInProgress;
@property (nonatomic, strong) NSOperationQueue *filtrationQueue;

@end