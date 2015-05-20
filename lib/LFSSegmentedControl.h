//
//  LFSSegmentedControl.h
//
// Copyright (c) 2015 Lafosca (http://lafosca.cat/)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


#import <UIKit/UIKit.h>

@class LFSSegmentedControl;

typedef enum{
    LFSSegmentedControlAnimationDirectionLeft = 0,
    LFSSegmentedControlAnimationDirectionRight
} LFSSegmentedControlAnimationDirection;

@protocol LFSSegmentedControlDataSource <NSObject>

- (NSUInteger)numberOfButtonsInSegmentedControl:(LFSSegmentedControl *)segmentedControl;
- (NSString *)segmentedControl:(LFSSegmentedControl *)segmentedControl titleForButtonAtIndex:(NSUInteger)index;
@optional
- (UIFont *)preferredFontForSegmentedControl:(LFSSegmentedControl *)segmentedControl;
- (UIFont *)preferredFontForSelectedSegmentedControl:(LFSSegmentedControl *)segmentedControl;
- (NSUInteger)selectedIndexForSegmentedControl:(LFSSegmentedControl *)segmentedControl;

@end

@protocol LFSSegmentedControlDelegate <NSObject>

-(void)segmentedControl:(LFSSegmentedControl *)segmentedControl didSelectItemAtIndex:(NSUInteger)index animated:(BOOL)animated;

@end


@interface LFSSegmentedControl : UIView

@property (nonatomic, weak) id<LFSSegmentedControlDataSource>datasource;
@property (nonatomic, weak) id<LFSSegmentedControlDelegate>delegate;

@property (nonatomic, strong) UIColor *lineTintColor;
@property (nonatomic, strong) NSMutableArray *selectedSectionLineTintColors;

@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *selectedTextColor;

@property (nonatomic, assign) CGFloat highlightLineHeight;

@property (nonatomic, assign) BOOL showFullWithLine;

@property (nonatomic, strong) UIScrollView *scrollView;

-(void)setSelectedSectionLineTintColor:(UIColor *)selectedSectionLineTintColor forItemAtIndex:(NSUInteger)index;
- (void)selectButtonAtIndex:(NSUInteger)index animated:(BOOL)animated;
- (void)reloadData;

@end
