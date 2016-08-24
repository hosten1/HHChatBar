//
//  Created by Jesse Squires
//  http://www.jessesquires.com
//
//
//  Documentation
//  http://cocoadocs.org/docsets/JSQMessagesViewController
//
//
//  GitHub
//  https://github.com/jessesquires/JSQMessagesViewController
//
//
//  License
//  Copyright (c) 2014 Jesse Squires
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

#import "JSQMessagesToolbarContentView.h"
#import "UIView+JSQMessages.h"
#import "JSQMessagesToolbarButtonFactory.h"

const CGFloat kJSQMessagesToolbarContentViewHorizontalSpacingDefault = 8.0f;
const float kJSQMessagesDefaultExtendsStartTag = 3003520;


@interface JSQMessagesToolbarContentView ()

@property (weak, nonatomic) IBOutlet JSQMessagesComposerTextView *textView;
@property (weak, nonatomic) IBOutlet UIView *rightBarButtonContainerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightBarButtonContainerViewWidthConstraint;

#pragma mark extend
@property (weak, nonatomic) IBOutlet UIView *extendButtonsContainerView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftButtonWidthConstraint;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *leftBarButtonContainerView;
@end

@implementation JSQMessagesToolbarContentView

#pragma mark - Class methods

+ (UINib *)nib
{
    return [UINib nibWithNibName:NSStringFromClass([JSQMessagesToolbarContentView class])
                          bundle:[NSBundle bundleForClass:[JSQMessagesToolbarContentView class]]];
}

#pragma mark - Initialization

- (void)awakeFromNib
{
    [super awakeFromNib];
//    self.leftButtonView.bounds = CGRectMake(0, 0, 0, 0);
     _leftButtonWidthConstraint.constant = 0.0f;
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    _extendPanelConstraint.constant = 0;
    self.backgroundColor = [UIColor clearColor];
}

- (void)dealloc
{
    _textView = nil;
    _rightBarButtonItem = nil;
    _rightBarButtonContainerView = nil;
}

#pragma mark - Setters

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
    self.leftBarButtonContainerView.backgroundColor = backgroundColor;
    self.rightBarButtonContainerView.backgroundColor = backgroundColor;
    self.extendButtonsContainerView.backgroundColor = backgroundColor;
    self.extendPanelContainerView.backgroundColor = backgroundColor;
}
-(void)setLeftBarButtonWidth:(CGFloat)leftBarButtonWidth{
    self.leftButtonWidthConstraint.constant = leftBarButtonWidth;
    [self needsUpdateConstraints];
}
-(void)setLeftBarButtonItem:(UIButton *)leftBarButtonItem{
    
    if (_leftBarButtonItem) {
        [_leftBarButtonItem removeFromSuperview];
    }
    if (!leftBarButtonItem) {
        _leftBarButtonItem = nil;
        self.leftBarButtonWidth = 0.0f;
        self.leftBarButtonContainerView.hidden = YES;
        return;
    }
    if (CGRectEqualToRect(leftBarButtonItem.frame, CGRectZero)) {
        leftBarButtonItem.frame = self.leftBarButtonContainerView.bounds;
    }
    
    self.leftBarButtonContainerView.hidden = NO;
    self.leftBarButtonWidth = CGRectGetWidth(leftBarButtonItem.frame);
    
    [leftBarButtonItem setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.leftBarButtonContainerView addSubview:leftBarButtonItem];
    [self.leftBarButtonContainerView jsq_pinAllEdgesOfSubview:leftBarButtonItem];
    [self setNeedsUpdateConstraints];
    _leftBarButtonItem = leftBarButtonItem;
    self.leftBarButtonItem.transform = CGAffineTransformRotate(self.leftBarButtonItem.transform, M_PI);//旋转
}
- (void)setRightBarButtonItem:(UIButton *)rightBarButtonItem
{
    if (_rightBarButtonItem) {
        [_rightBarButtonItem removeFromSuperview];
    }

    if (!rightBarButtonItem) {
        _rightBarButtonItem = nil;
        self.rightBarButtonItemWidth = 0.0f;
        self.rightBarButtonContainerView.hidden = YES;
        return;
    }

    if (CGRectEqualToRect(rightBarButtonItem.frame, CGRectZero)) {
        rightBarButtonItem.frame = self.rightBarButtonContainerView.bounds;
    }

    self.rightBarButtonContainerView.hidden = NO;
    self.rightBarButtonItemWidth = CGRectGetWidth(rightBarButtonItem.frame);

    [rightBarButtonItem setTranslatesAutoresizingMaskIntoConstraints:NO];

    [self.rightBarButtonContainerView addSubview:rightBarButtonItem];
    [self.rightBarButtonContainerView jsq_pinAllEdgesOfSubview:rightBarButtonItem];
    [self setNeedsUpdateConstraints];

    _rightBarButtonItem = rightBarButtonItem;
}

- (void)setRightBarButtonItemWidth:(CGFloat)rightBarButtonItemWidth
{
    self.rightBarButtonContainerViewWidthConstraint.constant = rightBarButtonItemWidth;
    [self setNeedsUpdateConstraints];
}

- (void)setExtendButtons:(NSArray *)extendButtons
{
    CGRect frame = self.extendButtonsContainerView.bounds;   
    frame.size.width = [UIScreen mainScreen].bounds.size.width - 2 * kJSQMessagesToolbarContentViewHorizontalSpacingDefault;
    if (!extendButtons) {
        _extendButtons = [NSArray arrayWithObjects:[JSQMessagesToolbarButtonFactory defaultPhotoButtonItem],[JSQMessagesToolbarButtonFactory defaultAudioButtonItem],[JSQMessagesToolbarButtonFactory defaultExpressionButtonItem],[JSQMessagesToolbarButtonFactory defaultLocationButtonItem],[JSQMessagesToolbarButtonFactory defaultDirectiveButtonItem],[JSQMessagesToolbarButtonFactory defaultMoreButtonItem], nil];
    }else{
        _extendButtons = [NSArray arrayWithArray:extendButtons];
    }
    int count = _extendButtons.count;
    CGFloat width = (CGRectGetWidth(frame) - (count - 1) * kJSQMessagesToolbarContentViewHorizontalSpacingDefault) / count;
    NSInteger tag = kJSQMessagesDefaultExtendsStartTag;
    for (int i = 0;i < count;i++) {
        UIButton *button = [_extendButtons objectAtIndex:i];
        [button setFrame:(CGRect){i * (kJSQMessagesToolbarContentViewHorizontalSpacingDefault + width) ,button.frame.origin.y,width,_extendButtonsContainerView.frame.size.height}];
        [button setTag:tag];
        tag += 1;
        [_extendButtonsContainerView addSubview:button];
    }
}
#pragma mark - Getters

- (CGFloat)rightBarButtonItemWidth
{
    return self.rightBarButtonContainerViewWidthConstraint.constant;
}

#pragma mark - UIView overrides

- (void)setNeedsDisplay
{
    [super setNeedsDisplay];
    [self.textView setNeedsDisplay];
}

- (void)clearText:(UIButton*)button
{
    [self.textView setText:@""];
}

@end
