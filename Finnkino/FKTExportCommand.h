//
//  FKTExportCommand.h
//  Finnkino
//
//  Created by Abdullah Atik on 10/16/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//

#import "FKTCommand.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface FKTExportCommand : FKTCommand

@property AVAssetExportSession *exportSession;

@end
