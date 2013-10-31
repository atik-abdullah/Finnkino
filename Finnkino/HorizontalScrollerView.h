//
//  HorizontalScrollerView.h
//  Finnkino
//
//  Created by Abdullah Atik on 10/28/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//
#import <UIKit/UIKit.h>
@class HorizontalScrollerView;

@protocol HorizontalScrollerDelegate <NSObject>
@required
// ask the delegate how many views he wants to present inside the horizontal scroller
- (NSInteger)numberOfViewsForHorizontalScroller:(HorizontalScrollerView*)scroller;

// ask the delegate to return the view that should appear at <index>
- (UIView*)horizontalScroller:(HorizontalScrollerView*)scroller viewAtIndex:(int)index;

// inform the delegate what the view at <index> has been clicked
- (void)horizontalScroller:(HorizontalScrollerView*)scroller clickedViewAtIndex:(int)index;

@optional
// ask the delegate for the index of the initial view to display. this method is optional
// and defaults to 0 if it's not implemented by the delegate
- (NSInteger)initialViewIndexForHorizontalScroller:(HorizontalScrollerView*)scroller;
@end

@interface HorizontalScrollerView : UIView

@property (weak) id<HorizontalScrollerDelegate> delegate;

- (void)reload;

@end
