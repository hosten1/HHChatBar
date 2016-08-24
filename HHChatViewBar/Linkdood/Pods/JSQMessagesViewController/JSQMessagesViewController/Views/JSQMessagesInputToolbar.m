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

#import "JSQMessagesInputToolbar.h"

#import "JSQMessagesComposerTextView.h"

#import "JSQMessagesToolbarButtonFactory.h"

#import "UIColor+JSQMessages.h"
#import "UIImage+JSQMessages.h"
#import "UIView+JSQMessages.h"

static void * kJSQMessagesInputToolbarKeyValueObservingContext = &kJSQMessagesInputToolbarKeyValueObservingContext;


@interface JSQMessagesInputToolbar ()

@property (assign, nonatomic) BOOL jsq_isObserving;

//是否点击已选中图标
@property (assign, nonatomic) BOOL jsq_tapSelectedBtn;

- (void)jsq_leftBarButtonPressed:(UIButton *)sender;
- (void)jsq_rightBarButtonPressed:(UIButton *)sender;

- (void)jsq_addObservers;
- (void)jsq_removeObservers;

@end



@implementation JSQMessagesInputToolbar

@dynamic delegate;

#pragma mark - Initialization

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];

    self.jsq_isObserving = NO;
    self.sendButtonOnRight = YES;
    self.jsq_robotChat = YES;
    self.preferredDefaultHeight = 80.0f;

    JSQMessagesToolbarContentView *toolbarContentView = [self loadToolbarContentView];
    toolbarContentView.frame = self.frame;
    [self addSubview:toolbarContentView];
    [self jsq_pinAllEdgesOfSubview:toolbarContentView];
    [self setNeedsUpdateConstraints];
    _contentView = toolbarContentView;
    [self jsq_addObservers];

    self.contentView.leftBarButtonItem = [JSQMessagesToolbarButtonFactory defaultLeftButtonItem];
    self.contentView.rightBarButtonItem = [JSQMessagesToolbarButtonFactory defaultSendButtonItem];
    self.contentView.extendButtons = nil;
//    [self.contentView hiddenClearBarButton:NO];

    [self toggleSendButtonEnabled];
}

- (JSQMessagesToolbarContentView *)loadToolbarContentView
{
    NSArray *nibViews = [[NSBundle bundleForClass:[JSQMessagesInputToolbar class]] loadNibNamed:NSStringFromClass([JSQMessagesToolbarContentView class])owner:nil  options:nil];
    
    return nibViews.firstObject;
}

- (void)dealloc
{
    [self jsq_removeObservers];
    _contentView = nil;
}

#pragma mark - Setters

- (void)setPreferredDefaultHeight:(CGFloat)preferredDefaultHeight
{
//    NSParameterAssert(preferredDefaultHeight > 0.0f);
    _preferredDefaultHeight = preferredDefaultHeight;
}

#pragma mark - Actions

- (void)jsq_leftBarButtonPressed:(UIButton *)sender
{
    [self.delegate messagesInputToolbar:self didPressLeftBarButton:sender];
}

- (void)jsq_rightBarButtonPressed:(UIButton *)sender
{
    [self.delegate messagesInputToolbar:self didPressRightBarButton:sender];
}

- (void)jsq_extendButtonPressed:(UIButton *)sender
{
    //图标状态调整
    _jsq_tapSelectedBtn = sender.isSelected;
    if (sender.isSelected) {
        if (_jsq_showExtendView) {
            [sender setSelected:NO];
        }
    }else{
        for (UIButton *button in _contentView.extendButtonsContainerView.subviews) {
            [button setSelected:NO];
        }
        [sender setSelected:YES];
    }
    
    //如果是文本输入状态,则切换到扩展面板状态
    if (self.contentView.textView.isFirstResponder) {
        [self.contentView.textView resignFirstResponder];
    }
    
    //触发各面板
    if (sender.tag == 3003520) {
        [self.delegate messagesInputToolbar:self didPressPhotoBarButton:sender];
    }
    if (sender.tag == 3003521) {
        [self.delegate messagesInputToolbar:self didPressAudioBarButton:sender];
    }
    if (sender.tag == 3003522){
        [self.delegate messagesInputToolbar:self didPressExpressionBarButton:sender];
    }
    
    if (sender.tag == 3003523){
        [self.delegate messagesInputToolbar:self didPressLocationBarButton:sender];
    }
    
    if (sender.tag == 3003524) {
        [self.delegate messagesInputToolbar:self didPressDirectiveBarButton:sender];
    }
    
    if (sender.tag == 3003525) {
        [self.delegate messagesInputToolbar:self didPressMoreBarButton:sender];
    }
}

#pragma mark - Input toolbar

- (void)toggleSendButtonEnabled
{
    BOOL hasText = [self.contentView.textView hasText];

    if (self.sendButtonOnRight) {
        self.contentView.rightBarButtonItem.enabled = hasText;
    }
    
}

#pragma mark - Key-value observing

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == kJSQMessagesInputToolbarKeyValueObservingContext) {
        if (object == self.contentView) {

            if ([keyPath isEqualToString:NSStringFromSelector(@selector(leftBarButtonItem))]) {
                
                [self.contentView.leftBarButtonItem removeTarget:self
                                                          action:NULL
                                                forControlEvents:UIControlEventTouchUpInside];

                [self.contentView.leftBarButtonItem addTarget:self
                                                       action:@selector(jsq_leftBarButtonPressed:)
                                             forControlEvents:UIControlEventTouchUpInside];
            }
            else if ([keyPath isEqualToString:NSStringFromSelector(@selector(rightBarButtonItem))]) {
                [self.contentView.rightBarButtonItem removeTarget:self
                                                           action:NULL
                                                 forControlEvents:UIControlEventTouchUpInside];

                [self.contentView.rightBarButtonItem addTarget:self
                                                        action:@selector(jsq_rightBarButtonPressed:)
                                              forControlEvents:UIControlEventTouchUpInside];
            }
            else if([keyPath isEqualToString:NSStringFromSelector(@selector(extendButtons))]){
                for (UIButton *button in self.contentView.extendButtons) {
                    [button removeTarget:self
                                  action:NULL
                        forControlEvents:UIControlEventTouchUpInside];
                    
                    [button addTarget:self
                               action:@selector(jsq_extendButtonPressed:)
                     forControlEvents:UIControlEventTouchUpInside];
                }
            }

            [self toggleSendButtonEnabled];
            self.contentView.leftBarButtonItem.enabled = YES;
        }
    }
}

- (void)jsq_addObservers
{
    if (self.jsq_isObserving) {
        return;
    }

    [self.contentView addObserver:self
                       forKeyPath:NSStringFromSelector(@selector(leftBarButtonItem))
                          options:0
                          context:kJSQMessagesInputToolbarKeyValueObservingContext];

    [self.contentView addObserver:self
                       forKeyPath:NSStringFromSelector(@selector(rightBarButtonItem))
                          options:0
                          context:kJSQMessagesInputToolbarKeyValueObservingContext];
    
    [self.contentView addObserver:self
                       forKeyPath:NSStringFromSelector(@selector(extendButtons))
                          options:0
                          context:kJSQMessagesInputToolbarKeyValueObservingContext];

    self.jsq_isObserving = YES;
}

- (void)jsq_removeObservers
{
    if (!_jsq_isObserving) {
        return;
    }

    @try {
        [_contentView removeObserver:self
                          forKeyPath:NSStringFromSelector(@selector(leftBarButtonItem))
                             context:kJSQMessagesInputToolbarKeyValueObservingContext];

        [_contentView removeObserver:self
                          forKeyPath:NSStringFromSelector(@selector(rightBarButtonItem))
                             context:kJSQMessagesInputToolbarKeyValueObservingContext];
        
        [_contentView removeObserver:self
                          forKeyPath:NSStringFromSelector(@selector(extendButtons))
                             context:kJSQMessagesInputToolbarKeyValueObservingContext];
    }
    @catch (NSException *__unused exception) { }
    
    _jsq_isObserving = NO;
}



#pragma mark - Custom method
- (void)textViewShowedBeginEditing
{
    if (_jsq_showExtendView) {
        [self hideExtendViewWithAnimated:YES];
    }
}

- (void)showExtendView:(UIView*)view
{
    for (UIView *child in _contentView.extendPanelContainerView.subviews) {
        [child removeFromSuperview];
    }
    [view setFrame:(CGRect){0,0,[UIScreen mainScreen].bounds.size.width,view.frame.size.height}];
    [_contentView.extendPanelContainerView addSubview:view];
    [view setNeedsUpdateConstraints];
    [view layoutSubviews];
    [self show:view withAnimated:YES];
}

- (void)show:(UIView*)extendView withAnimated:(BOOL)animated
{
    if (_jsq_showExtendView && _jsq_tapSelectedBtn) {
        [self hideExtendViewWithAnimated:YES];
        return;
    }
//    //先去掉旧的扩展面板高度
//    CGFloat height = _preferredDefaultHeight - _contentView.extendPanelConstraint.constant;
//    //重新设置扩展面板高度
//    _contentView.extendPanelConstraint.constant = extendView.frame.size.height;
//    //重置面板高度
//    height = height + _contentView.extendPanelConstraint.constant;
//    [self setPreferredDefaultHeight:height];
//    
//    _jsq_showExtendView = true;
    
    [UIView animateWithDuration:0.3 animations:^{
        //先去掉旧的扩展面板高度
        CGFloat height = _preferredDefaultHeight - _contentView.extendPanelConstraint.constant;
        //重新设置扩展面板高度
        _contentView.extendPanelConstraint.constant = extendView.frame.size.height;
        //重置面板高度
        height = height + _contentView.extendPanelConstraint.constant;
        [self setPreferredDefaultHeight:height];
    } completion:^(BOOL finished) {
        _jsq_showExtendView = true;
    }];
}

- (void)hideExtendViewWithAnimated:(BOOL)animated
{
    [UIView animateWithDuration:0.3 animations:^{
        CGFloat height = _preferredDefaultHeight - _contentView.extendPanelConstraint.constant;
        _contentView.extendPanelConstraint.constant = 0;
        [self setPreferredDefaultHeight:height];
    } completion:^(BOOL finished) {
        for (UIView *child in _contentView.extendPanelContainerView.subviews) {
            [child removeFromSuperview];
        }
        _jsq_showExtendView = false;
    }];
}

-(void)removeAllSubview{
    NSArray *arr =  self.subviews;
    for (NSInteger i = 0; i < self.subviews.count; i++) {
        UIView *view = self.subviews[i];
        [view removeFromSuperview];
    }
}
@end
