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

#import "JSQMessagesToolbarButtonFactory.h"

#import "UIColor+JSQMessages.h"
#import "UIImage+JSQMessages.h"
#import "NSBundle+JSQMessages.h"


@implementation JSQMessagesToolbarButtonFactory

+ (UIButton *)defaultAccessoryButtonItem
{
    UIImage *accessoryImage = [UIImage jsq_defaultAccessoryImage];
    UIImage *normalImage = [accessoryImage jsq_imageMaskedWithColor:[UIColor lightGrayColor]];
    UIImage *highlightedImage = [accessoryImage jsq_imageMaskedWithColor:[UIColor darkGrayColor]];

    UIButton *accessoryButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, accessoryImage.size.width, 30.0f)];
    [accessoryButton setImage:normalImage forState:UIControlStateNormal];
    [accessoryButton setImage:highlightedImage forState:UIControlStateHighlighted];

    accessoryButton.contentMode = UIViewContentModeScaleAspectFit;
    accessoryButton.backgroundColor = [UIColor clearColor];
    accessoryButton.tintColor = [UIColor lightGrayColor];

    return accessoryButton;
}

+ (UIButton *)defaultSendButtonItem
{
    UIImage *sendImage = [UIImage jsq_defaultSendImage];
    UIImage *normalImage = [sendImage jsq_imageMaskedWithColor:[UIColor lightGrayColor]];
    UIImage *highlightedImage = [sendImage jsq_imageMaskedWithColor:[UIColor darkGrayColor]];
    
    UIButton *sendButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, sendImage.size.width, 30.0f)];
    [sendButton setImage:normalImage forState:UIControlStateNormal];
    [sendButton setImage:highlightedImage forState:UIControlStateHighlighted];
    
    sendButton.contentMode = UIViewContentModeScaleAspectFit;
    sendButton.backgroundColor = [UIColor clearColor];
    sendButton.tintColor = [UIColor lightGrayColor];
    return sendButton;
    
//    NSString *sendTitle = [NSBundle jsq_localizedStringForKey:@"send"];
//
//    UIButton *sendButton = [[UIButton alloc] initWithFrame:CGRectZero];
//    [sendButton setTitle:sendTitle forState:UIControlStateNormal];
//    [sendButton setTitleColor:[UIColor jsq_messageBubbleBlueColor] forState:UIControlStateNormal];
//    [sendButton setTitleColor:[[UIColor jsq_messageBubbleBlueColor] jsq_colorByDarkeningColorWithValue:0.1f] forState:UIControlStateHighlighted];
//    [sendButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
//
//    sendButton.titleLabel.font = [UIFont boldSystemFontOfSize:17.0f];
//    sendButton.titleLabel.adjustsFontSizeToFitWidth = YES;
//    sendButton.titleLabel.minimumScaleFactor = 0.85f;
//    sendButton.contentMode = UIViewContentModeCenter;
//    sendButton.backgroundColor = [UIColor clearColor];
//    sendButton.tintColor = [UIColor jsq_messageBubbleBlueColor];
//
//    CGFloat maxHeight = 30.0f;
//
//    CGRect sendTitleRect = [sendTitle boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, maxHeight)
//                                                   options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
//                                                attributes:@{ NSFontAttributeName : sendButton.titleLabel.font }
//                                                   context:nil];
//
//    sendButton.frame = CGRectMake(0.0f,
//                                  0.0f,
//                                  CGRectGetWidth(CGRectIntegral(sendTitleRect)),
//                                  maxHeight);
//
//    return sendButton;
}

#pragma mark extend
+ (UIButton *)defaultPhotoButtonItem
{
    UIImage *photoImage = [UIImage jsq_defaultPhotoImage];
    UIImage *normalImage = [photoImage jsq_imageMaskedWithColor:[UIColor lightGrayColor]];
    UIImage *highlightedImage = [photoImage jsq_imageMaskedWithColor:[UIColor darkGrayColor]];
    UIImage *seletedImage = [photoImage jsq_imageMaskedWithColor:[UIColor colorWithRed:0 green:160 blue:190 alpha:1.0]];
    
    UIButton *photoButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, photoImage.size.width, 30.0f)];
    [photoButton setImage:normalImage forState:UIControlStateNormal];
    [photoButton setImage:highlightedImage forState:UIControlStateHighlighted];
    [photoButton setImage:seletedImage forState:UIControlStateSelected];
    
    photoButton.contentMode = UIViewContentModeScaleAspectFit;
    photoButton.backgroundColor = [UIColor clearColor];
    photoButton.tintColor = [UIColor lightGrayColor];
    return photoButton;
}

+ (UIButton *)defaultAudioButtonItem
{
    UIImage *audioImage = [UIImage jsq_defaultAudioImage];
    UIImage *normalImage = [audioImage jsq_imageMaskedWithColor:[UIColor lightGrayColor]];
    UIImage *highlightedImage = [audioImage jsq_imageMaskedWithColor:[UIColor darkGrayColor]];
    UIImage *seletedImage = [audioImage jsq_imageMaskedWithColor:[UIColor colorWithRed:0 green:160 blue:190 alpha:1.0]];
    
    UIButton *audioButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, audioImage.size.width, 30.0f)];
    [audioButton setImage:normalImage forState:UIControlStateNormal];
    [audioButton setImage:highlightedImage forState:UIControlStateHighlighted];
    [audioButton setImage:seletedImage forState:UIControlStateSelected];
    
    audioButton.contentMode = UIViewContentModeScaleAspectFit;
    audioButton.backgroundColor = [UIColor clearColor];
    audioButton.tintColor = [UIColor lightGrayColor];
    return audioButton;
}

+ (UIButton *)defaultExpressionButtonItem
{
    UIImage *expressionImage = [UIImage jsq_defaultExpressionImage];
    UIImage *normalImage = [expressionImage jsq_imageMaskedWithColor:[UIColor lightGrayColor]];
    UIImage *highlightedImage = [expressionImage jsq_imageMaskedWithColor:[UIColor darkGrayColor]];
    UIImage *seletedImage = [expressionImage jsq_imageMaskedWithColor:[UIColor colorWithRed:0 green:160 blue:190 alpha:1.0]];
    
    UIButton *expressionButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, expressionImage.size.width, 30.0f)];
    [expressionButton setImage:normalImage forState:UIControlStateNormal];
    [expressionButton setImage:highlightedImage forState:UIControlStateHighlighted];
    [expressionButton setImage:seletedImage forState:UIControlStateSelected];
    
    expressionButton.contentMode = UIViewContentModeScaleAspectFit;
    expressionButton.backgroundColor = [UIColor clearColor];
    expressionButton.tintColor = [UIColor lightGrayColor];
    return expressionButton;
}

+ (UIButton *)defaultLocationButtonItem
{
    UIImage *locationImage = [UIImage jsq_defaultLocationImage];
    UIImage *normalImage = [locationImage jsq_imageMaskedWithColor:[UIColor lightGrayColor]];
    UIImage *highlightedImage = [locationImage jsq_imageMaskedWithColor:[UIColor darkGrayColor]];
    UIImage *seletedImage = [locationImage jsq_imageMaskedWithColor:[UIColor colorWithRed:0 green:160 blue:190 alpha:1.0]];
    
    UIButton *locationButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, locationImage.size.width, 30.0f)];
    [locationButton setImage:normalImage forState:UIControlStateNormal];
    [locationButton setImage:highlightedImage forState:UIControlStateHighlighted];
    [locationButton setImage:seletedImage forState:UIControlStateSelected];
    
    locationButton.contentMode = UIViewContentModeScaleAspectFit;
    locationButton.backgroundColor = [UIColor clearColor];
    locationButton.tintColor = [UIColor lightGrayColor];
    return locationButton;
}

+ (UIButton *)defaultDirectiveButtonItem
{
    UIImage *directiveImage = [UIImage jsq_defaultDirectiveImage];
    UIImage *normalImage = [directiveImage jsq_imageMaskedWithColor:[UIColor lightGrayColor]];
    UIImage *highlightedImage = [directiveImage jsq_imageMaskedWithColor:[UIColor darkGrayColor]];
    UIImage *seletedImage = [directiveImage jsq_imageMaskedWithColor:[UIColor colorWithRed:0 green:160 blue:190 alpha:1.0]];
    
    UIButton *cardButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, directiveImage.size.width, 30.0f)];
    [cardButton setImage:normalImage forState:UIControlStateNormal];
    [cardButton setImage:highlightedImage forState:UIControlStateHighlighted];
    [cardButton setImage:seletedImage forState:UIControlStateSelected];
    
    cardButton.contentMode = UIViewContentModeScaleAspectFit;
    cardButton.backgroundColor = [UIColor clearColor];
    cardButton.tintColor = [UIColor lightGrayColor];
    return cardButton;
}

+ (UIButton *)defaultMoreButtonItem
{
    UIImage *moreImage = [UIImage jsq_defaultMoreImage];
    UIImage *normalImage = [moreImage jsq_imageMaskedWithColor:[UIColor lightGrayColor]];
    UIImage *highlightedImage = [moreImage jsq_imageMaskedWithColor:[UIColor darkGrayColor]];
    UIImage *seletedImage = [moreImage jsq_imageMaskedWithColor:[UIColor colorWithRed:0 green:160 blue:190 alpha:1.0]];
    
    UIButton *moreButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, moreImage.size.width, 30.0f)];
    [moreButton setImage:normalImage forState:UIControlStateNormal];
    [moreButton setImage:highlightedImage forState:UIControlStateHighlighted];
    [moreButton setImage:seletedImage forState:UIControlStateSelected];
    
    moreButton.contentMode = UIViewContentModeScaleAspectFit;
    moreButton.backgroundColor = [UIColor clearColor];
    moreButton.tintColor = [UIColor lightGrayColor];
    return moreButton;
}
+(UIButton *)defaultLeftButtonItem{
    UIImage *leftImage = [UIImage jsq_defauLeftImage];
    UIImage *normalImage = [leftImage jsq_imageMaskedWithColor:[UIColor lightGrayColor]];
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, leftImage.size.width, 30.0f)];
    [leftButton setImage:normalImage forState:UIControlStateNormal];
    
    leftButton.contentMode = UIViewContentModeScaleAspectFit;
    leftButton.backgroundColor = [UIColor clearColor];
    leftButton.tintColor = [UIColor lightGrayColor];
    return leftButton;
 
}
@end
