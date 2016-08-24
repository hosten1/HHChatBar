//
//  NSString+LDStringAttribute.m
//  Linkdood
//
//  Created by VRV2 on 16/8/12.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import "NSString+LDStringAttribute.h"

@implementation NSString (LDStringAttribute)
- (CGFloat)heightForContent:(NSString *)content withWidth:(CGFloat)width font:(UIFont*)sysFont
{
    CGSize contentSize;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] > 7.0) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        //        NSDictionary *attributes = @{NSFontAttributeName:CELL_CONTENT_FONT_SIZE, NSParagraphStyleAttributeName:paragraphStyle.copy};
        NSDictionary *attributes = @{NSFontAttributeName:sysFont};
        
        contentSize = [content boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    }
    else{
        contentSize = [content sizeWithFont:sysFont
                          constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)
                              lineBreakMode:NSLineBreakByWordWrapping];
    }
    
    
    
    return contentSize.height;
}
-(NSString*)subURLStr:(NSString *)URLString

{
    
    NSError *error;
    
    //可以识别url的正则表达式
    
    NSString *regulaStr = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                  
                                                                           options:NSRegularExpressionCaseInsensitive
                                  
                                                                             error:&error];
    
    NSArray *arrayOfAllMatches = [regex matchesInString:URLString options:0 range:NSMakeRange(0, [URLString length])];
    
    //NSString *subStr;
    
    NSMutableArray *arr=[[NSMutableArray alloc]init];
    
    NSArray *rangeArr=[[NSMutableArray alloc]init];
    
    
    if(arrayOfAllMatches.count > 0){
        for (NSTextCheckingResult *match in arrayOfAllMatches)
            
        {
            
            NSString* substringForMatch;
            
            substringForMatch = [URLString substringWithRange:match.range];
            
            [arr addObject:substringForMatch];
            
            
            
        }
        
        NSString *subStr=URLString;
        
        for (NSString *str in arr)
            
        {
            
            subStr= str;
            
        }
        
        
        return subStr;

    }else{
        return nil;
    }
    
    
    
}

//获取查找字符串在母串中的NSRange

- (NSArray *)rangesOfString:(NSString *)searchString inString:(NSString *)str{
    
    
    
    NSMutableArray *results = [NSMutableArray array];
    
    
    
    NSRange searchRange = NSMakeRange(0, [str length]);
    
    
    
    NSRange range;
    
    
    
    while ((range = [str rangeOfString:searchString options:0 range:searchRange]).location != NSNotFound) {
        
        
        
        [results addObject:[NSValue valueWithRange:range]];
        
        
        
        searchRange = NSMakeRange(NSMaxRange(range), [str length] - NSMaxRange(range));
        
        
        
    }
    
    
    
    return results;
    
}

-(NSAttributedString*)checkStringHasURlWithString:(NSString*)reString andTextView:(UITextView*)textView{
    NSString *sub = [reString subURLStr:reString];
    NSString *sub1;
    NSString *sub2;
    NSRange subStringRange;
    if (sub) {
        subStringRange = [[[sub rangesOfString:sub inString:reString] firstObject] rangeValue];
        sub1 = [reString substringToIndex:subStringRange.location];
        sub2 = [reString substringFromIndex:(subStringRange.location+subStringRange.length)];
        
    }
    NSAttributedString *att = [[NSAttributedString alloc]initWithString:sub];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",sub1,sub2]];
    [attributedString insertAttributedString:att atIndex:sub1.length];
    
    NSDictionary *linkAttributes = @{NSForegroundColorAttributeName: [UIColor blueColor],
                                     NSUnderlineColorAttributeName: [UIColor blueColor],
                                     NSUnderlineStyleAttributeName: @(NSUnderlinePatternSolid)};
    
    // assume that textView is a UITextView previously created (either by code or Interface Builder)
    if (textView) {
        textView.linkTextAttributes = linkAttributes; // customizes the appearance of links
        textView.attributedText = attributedString;
        textView.editable = NO;   // 非编辑状态下才可以点击Url
    }
    return attributedString;
}

@end
