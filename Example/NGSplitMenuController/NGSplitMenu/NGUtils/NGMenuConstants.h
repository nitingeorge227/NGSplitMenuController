//
//  NGMenuConstants.h
//  NGSplitMenuController

//NGSplitMenu is available under the MIT license.
//
//Copyright © 2015 Nitin George.
//
//Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


#ifndef NGSplitMenuController_NGMenuConstants_h
#define NGSplitMenuController_NGMenuConstants_h

static  NSString *kMenuItemSelectesNotification           = @"MenuItemSelectesNotification";
static  NSString *kNGMenuItemKey                          = @"NGMenuItemKey";

//Menu attributes

static NSString * kNGMenuBackgroundColorKey                 = @"kNGMenuBackgroundColorKey";
static NSString * kNGMenuItemFontKey                        = @"kNGMenuItemFontKey";
static NSString * kNGMenuItemFontColorKey                   = @"kNGMenuItemFontColorKey";

static NSString * kNGMenuitemSelectionColorKey              = @"kNGMenuitemSelectionColorKey";
static NSString * kNGMenuSeperatorColorKey                  = @"kNGMenuSeperatorColorKey";
static NSString * kNGMenuLineSeperatorKey                   = @"kNGMenuLineSeperatorKey";

//Default values

#define kNGMenubackgroundColor [UIColor colorWithRed:0.212f green:0.212f blue:0.212f alpha:1.00f]
#define kNGMenuItemFont [UIFont fontWithName:@"HelveticaNeue-Light" size:18.0f]
#define kNGFontColor [UIColor whiteColor]
#define kNGMenuItemSelectionColor  [UIColor colorWithRed:0.890f green:0.494f blue:0.322f alpha:1.00f]
#define kNGMenuSeperatorColor [UIColor colorWithWhite:0.841 alpha:1.000]
#define kNGMenuLineSeparator YES

#endif


