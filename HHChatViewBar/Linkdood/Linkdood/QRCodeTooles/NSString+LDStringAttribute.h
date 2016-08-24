//
//  NSString+LDStringAttribute.h
//  Linkdood
//  用来处理字符串中包含连接的特殊情况
//  Created by VRV2 on 16/8/12.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (LDStringAttribute)
/**
 *  获取字符串的高度
 *
 *  @param content 字符串
 *  @param width   最大宽度
 *  @param sysFont font属性
 *
 *  @return 字符串高度
 */
- (CGFloat)heightForContent:(NSString *)content withWidth:(CGFloat)width font:(UIFont*)sysFont;
/**
 *  在字符串中查找URL字符串
 *
 *  @param URLString 包含url的字符串
 *
 *  @return url字符串
 */

-(NSString*)subURLStr:(NSString *)URLString;
/**
 *  获取查找字符串在母串中的NSRange
 *
 *  @param searchString  要搜索的字符串
 *  @param str           源字符串
 *
 *  @return 包含NSRange 的数组
 */
- (NSArray *)rangesOfString:(NSString *)searchString inString:(NSString *)str;
-(NSAttributedString*)checkStringHasURlWithString:(NSString*)reString andTextView:(UITextView*)textView;
@end
