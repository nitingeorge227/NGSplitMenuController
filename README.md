## NGSplitMenuController

This is a menu driven Split view controller for iOS 7 and above.The sidemenu on the left is used to select from the diffrent master views.The third section shows the details corresponding to each master view.

![NGSPLIT](https://raw.githubusercontent.com/nitingeorge227/NGSplitMenuController/master/Screenshots/iOS Simulator Screen Shot Aug 23, 2015, 12.05.15 AM.png)

![NGSPLITGIF](https://raw.githubusercontent.com/nitingeorge227/NGSplitMenuController/master/Example/NGSplitMenuController/Assets/NGSplitMenu.gif)

## Requirements

* iOS 7.0 or later
* ARC

## Demo

Build and run the Example project in Xcode to see `NGSplitMenuController` in action.

## Usage

All you need to do is drop `NGSplitMenu` files into your project, and add `#include "NGSplitMenu.h"` to the top of classes that will use it.

In your AppDelegate's `- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions`,set the default options to `NGSplitViewManager` to configure various attributes of the split menucontroller

`````````
[[NGSplitViewManager sharedInstance]setDefaultOptions:@{kNGMenuBackgroundColorKey : [UIColor colorWithRed:0.212f green:0.212f blue:0.212f alpha:1.00f],
                                                            kNGMenuItemFontKey             : [UIFont fontWithName:@"HelveticaNeue-Light" size:18.0f],
                                                            kNGMenuItemFontColorKey     :[UIColor whiteColor],
                                                            kNGMenuitemSelectionColorKey        : [UIColor colorWithRed:0.890f green:0.494f blue:0.322f alpha:1.00f],
                                                            kNGMenuSeperatorColorKey  : [UIColor colorWithWhite:0.841 alpha:1.000],
                                                            kNGMenuLineSeperatorKey     : @(NO),
                                                            }];
``````````````

Create the view controllers and set the master and detail views

``````
MainViewController *mainView = [[MainViewController alloc]init];
MasterViewController *masterView = [[MasterViewController alloc]init];
DetailViewController *detailView = [[DetailViewController alloc]init];
    
[[NGSplitViewManager sharedInstance]setRootViewController:mainView masterViewController:masterView   detailViewController:detailView];
    
``````
Set the menu items

`````````
NSMutableArray *menuItems = [NSMutableArray array];
NGMenuItem *menuItem1 = [[NGMenuItem alloc]init];
menuItem1.itemDescription = @"Home";
menuItem1.itemImage = [UIImage imageNamed:@"icon-name"];
[menuItems addObject:menuItem1];
[[NGSplitViewManager sharedInstance]setMenuItems:menuItem];
    
````````````

`````````
self.window.rootViewController = mainView;
``````````

To toggle between the splitviews,use:

```````
[[NGSplitViewManager sharedInstance]toggleMenu];
```````

In `MainViewController.m`, listen to `kMenuItemSelectesNotification` for callback on menu item clicks.

`````
[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(menuItemSelected:) name:kMenuItemSelectesNotification object:nil];
````````

Extract `NGMenuItem` from the notification using the key `kNGMenuItemKey`.

Set the master view in `MainViewController`

```````
- (void)menuItemSelected:(NSNotification*)notification{
    
    NSDictionary *userInfo = notification.userInfo;
    
    NGMenuItem *menuItem = [userInfo objectForKey:kNGMenuItemKey];
    
    if (menuItem) {
        if (menuItem.menuIndex == kHome) {
            [[NGSplitViewManager sharedInstance]setMasterViewController:masterViewController];
        }
    }
}
````````````
Set the detail view in `MasterViewController`

`````````
DetailViewController *detail = [[DetailViewController alloc]initWithNibName:@"DetailViewController" bundle:nil];
    [[NGSplitViewManager sharedInstance]setDetailViewController:detail];
    
``````````````


## Author

Nitin George nitingeorge227@yahoo.com

## License

NGSplitMenuController is available under the MIT license.

Copyright © 2015 Nitin George.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
