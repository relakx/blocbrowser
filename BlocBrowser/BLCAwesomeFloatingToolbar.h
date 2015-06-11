//
//  BLCAwesomeFloatingToolbar.h
//  BlocBrowser
//
//  Created by Joseph Blanco on 5/25/15.
//  Copyright (c) 2015 Blancode. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BLCAwesomeFloatingToolbar;

@protocol BLCAwesomeFloatingToolbarDelegate <NSObject>

@optional
- (void) floatingToolbar:(BLCAwesomeFloatingToolbar *)toolbar didSelectButton: (UIButton *)button;
- (void) floatingToolbar:(BLCAwesomeFloatingToolbar *)toolbar didTryToPanWithOffset:(CGPoint)offset;
- (void) floatingToolbar:(BLCAwesomeFloatingToolbar *)toolbar didTryToPinchWithScale:(CGFloat)scale;


@end

@interface BLCAwesomeFloatingToolbar : UIView

- (instancetype) initWithFourTitles:(NSArray *)titles;

- (void) setEnabled:(BOOL)enabled forButtonWithTitle:(NSString *)title;

@property (nonatomic, weak) id <BLCAwesomeFloatingToolbarDelegate> delegate;

@end