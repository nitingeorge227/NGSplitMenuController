//
//  NGSplitMenuController.h
//  NGSplitMenuController
//
//  Created by Nitin George on 8/19/15.
//  Copyright (c) 2015 Nitin George. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NGSplitMenuController : UIViewController

- (instancetype)initWithMasterViewController:(UIViewController*)masterController andDetailController:(UIViewController*)detailViewController;
- (void)setMasterListWidth:(CGFloat)width;
- (void)setDetailListWidth:(CGFloat)width;


@end
