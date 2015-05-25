//
//  BLCWebBrowserViewController.h
//  BlocBrowser
//
//  Created by Joseph Blanco on 5/24/15.
//  Copyright (c) 2015 Blancode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BLCWebBrowserViewController : UIViewController

/**
 Replaces the web view with a fresh one, erasing all history. Also updates the URL field and toolbar buttons appropriately.
 */
- (void) resetWebView;

@end
