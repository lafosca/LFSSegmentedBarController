//
//  LFSSegmentedControl.m
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

#import "LFSSegmentedControl.h"

#define kAnimationDuration 0.125f

@interface LFSSegmentedControl()

@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, assign) NSUInteger selectedButton;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIView *fullWidthLine;
@property (nonatomic, assign) CGFloat totalWidth;

@end

@implementation LFSSegmentedControl

#pragma mark - Initializers

- (id)init
{
    self = [super init];
    if (self) {
        [self setupDefaultValues];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupDefaultValues];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self setupDefaultValues];
    }
    return self;
}

- (void)setupDefaultValues {
    self.showFullWithLine = YES;
    self.highlightLineHeight = 1.5f;
    self.lineTintColor = self.tintColor;
    self.textColor = [UIColor blackColor];
    self.selectedTextColor = [UIColor blackColor];
}

#pragma mark - Getters & Setters

-(void)setDatasource:(id<LFSSegmentedControlDataSource>)datasource {
    _datasource = datasource;
    [self reloadData];
}

-(void)setHighlightLineHeight:(CGFloat)highlightLineHeight {
    _highlightLineHeight = highlightLineHeight;
    
    if ([self.buttons count]>0){
        [self.lineView setFrame:CGRectMake(self.lineView.frame.origin.x,
                                           self.lineView.frame.origin.y,
                                           self.lineView.frame.size.width,
                                           highlightLineHeight)];
    }
    
}

-(void)setShowFullWithLine:(BOOL)showFullWithLine {
    _showFullWithLine = showFullWithLine;
    [self.fullWidthLine setHidden:!showFullWithLine];
}

-(void)setLineTintColor:(UIColor *)lineTintColor {
    _lineTintColor = lineTintColor;
    
    [self.fullWidthLine setBackgroundColor:lineTintColor];
}

-(void)setTintColor:(UIColor *)tintColor {
    [super setTintColor:tintColor];
    
    for (UIView *view in self.subviews) {
        [view setTintColor:tintColor];
    }
}

-(void)setSelectedSectionLineTintColor:(UIColor *)selectedSectionLineTintColor forItemAtIndex:(NSUInteger)index{
    _selectedSectionLineTintColors[index] = selectedSectionLineTintColor;
}

-(void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    
    for (UIButton *button in self.buttons) {
        [button setTitleColor:textColor forState:UIControlStateNormal];
    }
}

-(void)setSelectedTextColor:(UIColor *)selectedTextColor {
    _selectedTextColor = selectedTextColor;
    
    for (UIButton *button in self.buttons) {
        [button setTitleColor:selectedTextColor forState:UIControlStateSelected];
    }
}
-(void)setScrollView:(UIScrollView *)scrollView {
    _scrollView = scrollView;
    [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

- (void)reloadData{
    [self resetOldViews];
    NSUInteger numberOfItems = [self.datasource numberOfButtonsInSegmentedControl:self];
    if (self.datasource && numberOfItems > 0){
        self.selectedSectionLineTintColors = [NSMutableArray arrayWithCapacity:numberOfItems];
        for (int i=0; i< numberOfItems; i++){
            self.selectedSectionLineTintColors[i] = self.tintColor;
        }
        [self createButtons];
        [self selectButtonByDefault];
        [self centerButtons];
        [self createHighlightedView];
        [self createBottomLine];
    }
}

- (void)resetOldViews {
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
    self.fullWidthLine = nil;
    [self.buttons removeAllObjects];
    self.lineView = nil;
}

-(NSMutableArray *)buttons {
    if (!_buttons){
        _buttons = [[NSMutableArray alloc] init];
    }
    return _buttons;
}

- (void)createBottomLine {
    if (self.showFullWithLine){
        self.fullWidthLine = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                      self.lineView.frame.size.height + self.lineView.frame.origin.y,
                                                                      self.frame.size.width, 0.5)];
        [self.fullWidthLine setBackgroundColor:self.lineTintColor];
        [self addSubview:self.fullWidthLine];
    }
}

- (void)createButtons {
    if (![self.datasource respondsToSelector:@selector(numberOfButtonsInSegmentedControl:)]){
        NSAssert(true, @"You must implement numberOfButtonsInSegmentedControl in your datasource");
    }
    NSUInteger numberOfButtons = [self.datasource numberOfButtonsInSegmentedControl:self];
    CGFloat x = 0.0;
    for (int i = 0; i < numberOfButtons; i++) {
        NSString *title = [self.datasource segmentedControl:self titleForButtonAtIndex:i];
        UIButton *button =[self createButtonWithTitle:title andOrigin:x];
        [button setFrame:CGRectMake(x, button.frame.origin.y, ceilf(self.frame.size.width / numberOfButtons), button.frame.size.height + 10.0f)];
        x = button.frame.size.width + button.frame.origin.x ;
    }
    [self updateTotalWidth];
}

- (void)updateTotalWidth {
    UIButton *lastButton = [self.buttons lastObject];
    CGFloat componentWidth = lastButton.frame.size.width + lastButton.frame.origin.x ;
    self.totalWidth = componentWidth;
}

- (void)createHighlightedView {
    self.lineView = [[UIView alloc] init];
    [self.lineView setBackgroundColor:self.selectedSectionLineTintColors[self.selectedButton]];
    [self updateHighlightedViewToIndex:self.selectedButton animated:YES];
    [self addSubview:self.lineView];
}

- (UIButton *)createButtonWithTitle:(NSString *)title andOrigin:(CGFloat)originX{
    UIButton *customButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [customButton setTitle:title forState:UIControlStateNormal];
    [customButton addTarget:self action:@selector(buttonSelected:) forControlEvents:UIControlEventTouchUpInside];
    [customButton setTintColor:self.tintColor];
    [customButton setFrame:CGRectMake(originX, 0, 0, 0)];
    [customButton setTitleColor:self.textColor forState:UIControlStateNormal];
    [customButton setTitleColor:self.selectedTextColor forState:UIControlStateSelected];
    [customButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    
    //We size the button for the selected font
    [customButton.titleLabel setFont:[self fontForSelectedButton]];
    [customButton sizeToFit];
    [customButton.titleLabel setFont:[self fontForButtons]];
    [customButton setFrame:CGRectMake(customButton.frame.origin.x,
                                      customButton.frame.origin.y,
                                      customButton.frame.size.width + 9.0, customButton.frame.size.height + 24.0)];
    
    [self addSubview:customButton];
    [[self buttons] addObject:customButton];
    return customButton;
}

- (UIFont *)fontForButtons {
    if ([self.datasource respondsToSelector:@selector(preferredFontForSegmentedControl:)]){
        return [self.datasource preferredFontForSegmentedControl:self];
    } else {
        return [UIFont fontWithName:@"HelveticaNeue-Light" size:15.0];
    }
}

- (UIFont *)fontForSelectedButton {
    if ([self.datasource respondsToSelector:@selector(preferredFontForSelectedSegmentedControl:)]){
        return [self.datasource preferredFontForSelectedSegmentedControl:self];
    } else {
        return [UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0];
    }
}

- (void)selectButtonByDefault {
    NSUInteger index;
    if ([self.datasource respondsToSelector:@selector(selectedIndexForSegmentedControl:)]){
        index = [self.datasource selectedIndexForSegmentedControl:self];
    } else {
        index = 0;
    }
    [self selectButtonAtIndex:index shouldCallDelegate:NO animated:NO];
}

- (void)centerButtons {
    CGFloat distanceToMove = (self.frame.size.width - self.totalWidth) / 2.0;
    for (UIButton *button in [self buttons]) {
        CGRect buttonFrame = button.frame;
        buttonFrame.origin.x = buttonFrame.origin.x + distanceToMove;
        [button setFrame:buttonFrame];
    }
}

- (void)selectButtonAtIndex:(NSUInteger)index animated:(BOOL)animated {
    [self selectButtonAtIndex:index shouldCallDelegate:YES animated:animated];
}

- (void)selectButtonAtIndex:(NSUInteger)index shouldCallDelegate:(BOOL)shouldCallDelegate animated:(BOOL)animated{
    //Restore Font to previous selected button
    UIButton *previousSelectedButtton = [self.buttons objectAtIndex:self.selectedButton];
    [previousSelectedButtton.titleLabel setFont:[self fontForButtons]];
    [previousSelectedButtton setSelected:NO];
    self.selectedButton = index;
    
    UIButton *selectedButtton = [self.buttons objectAtIndex:self.selectedButton];
    
    if (!self.scrollView){
        [self updateHighlightedViewToIndex:index animated:animated];
        [self.lineView setBackgroundColor:self.selectedSectionLineTintColors[index]];
    }
    
    if (animated){
        [UIView animateWithDuration:kAnimationDuration animations:^{
            [selectedButtton setSelected:YES];
            [selectedButtton.titleLabel setFont:[self fontForSelectedButton]];
        } completion:^(BOOL finished) {
            if (shouldCallDelegate && [self.delegate respondsToSelector:@selector(segmentedControl:didSelectItemAtIndex:animated:)]){
                [self.delegate segmentedControl:self didSelectItemAtIndex:index animated:animated];
            }
        }];
    } else {
        [selectedButtton setSelected:YES];
        [selectedButtton.titleLabel setFont:[self fontForSelectedButton]];
        if (shouldCallDelegate && [self.delegate respondsToSelector:@selector(segmentedControl:didSelectItemAtIndex:animated:)]){
            [self.delegate segmentedControl:self didSelectItemAtIndex:index animated:animated];
        }
    }
}

- (void)setTitleToButtonWithInformation:(NSDictionary *)information
{
    NSAttributedString *title = information[@"Title"];
    UIButton *button = information[@"Button"];
    [button setAttributedTitle:title forState:UIControlStateNormal];
}

- (void)updateHighlightedViewToIndex:(NSUInteger)index animated:(BOOL)animated {
    if (!self.lineView) return;
    
    UIButton *selectedButtton = [self.buttons objectAtIndex:self.selectedButton];
    if (self.lineView.frame.size.width == 0){
        [self positionLineForButton:selectedButtton];
    } else {
        if (animated){
            [UIView animateWithDuration:kAnimationDuration animations:^{
                [self positionLineForButton:selectedButtton];
            }];
        } else {
            [self positionLineForButton:selectedButtton];
        }
    }
    
}

- (void)positionLineForButton:(UIButton *)button {
    [self.lineView setFrame:CGRectMake(button.frame.origin.x,
                                       button.frame.origin.y + button.frame.size.height - 20.0,
                                       button.frame.size.width, self.highlightLineHeight)];
}

- (void)buttonSelected:(UIButton *)sender {
    NSUInteger index = [self.buttons indexOfObject:sender];
    [self selectButtonAtIndex:index shouldCallDelegate:YES animated:YES];
}

#pragma mark - ScrollView Observing

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(UIScrollView *)scrollView change:(NSDictionary *)change context:(void *)context {

    NSUInteger numberOfPages = scrollView.contentSize.width / scrollView.frame.size.width;
    CGFloat lineX = scrollView.contentOffset.x / numberOfPages;
    
    [self.lineView setFrame:CGRectMake(ceilf(lineX) ,
                                       self.lineView.frame.origin.y,
                                       self.lineView.frame.size.width,
                                       self.highlightLineHeight)];
    
    CGFloat width = scrollView.frame.size.width;
    NSInteger page = (scrollView.contentOffset.x + (0.5f * width)) / width;
    
    [self.lineView setBackgroundColor:[self lineColorForXPosition:scrollView.contentOffset.x andWidth:width]];

    if (self.selectedButton != page && scrollView.isDecelerating){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.25f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self selectButtonAtIndex:page shouldCallDelegate:YES animated:YES];
        });
    }
}

- (UIColor *)lineColorForXPosition:(CGFloat)xPosition andWidth:(CGFloat)width {
    CGFloat page = xPosition / width;
    NSUInteger numberOfPages = [self.datasource numberOfButtonsInSegmentedControl:self];
    int intPage = (int)page;
    if (intPage + 1 < numberOfPages){
        CGFloat progress = page - intPage;
        UIColor *firstPageColor = self.selectedSectionLineTintColors[intPage];
        UIColor *secondPageColor = self.selectedSectionLineTintColors[intPage+1];
        return [self interpolateRGBColorFrom:firstPageColor to:secondPageColor withFraction:progress];
    }
    return self.selectedSectionLineTintColors[intPage];
}

- (UIColor *)interpolateRGBColorFrom:(UIColor *)start to:(UIColor *)end withFraction:(float)f {
    
    f = MAX(0, f);
    f = MIN(1, f);
    
    const CGFloat *c1 = CGColorGetComponents(start.CGColor);
    const CGFloat *c2 = CGColorGetComponents(end.CGColor);
    
    CGFloat r = c1[0] + (c2[0] - c1[0]) * f;
    CGFloat g = c1[1] + (c2[1] - c1[1]) * f;
    CGFloat b = c1[2] + (c2[2] - c1[2]) * f;
    CGFloat a = c1[3] + (c2[3] - c1[3]) * f;
    
    return [UIColor colorWithRed:r green:g blue:b alpha:a];
}

@end
