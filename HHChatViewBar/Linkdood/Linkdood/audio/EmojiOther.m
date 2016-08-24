//
//  EmojiOther.m
//  IM
//
//  Created by vrvdeveloper on 14-8-22.
//  Copyright (c) 2014年 VRV. All rights reserved.
//

#import "EmojiOther.h"

@implementation EmojiOther

+ (NSArray *)allOther{
    NSMutableArray *array = [NSMutableArray new];
    ;
    NSArray *temp = @[@0x1F60C, @0x1F60F, @0x1F61A, @0x1F61C,
                      @0x1F61D, @0x1F62D, @0x1F601, @0x1F609,
                      @0x1F612, @0x1F614, @0x1F616, @0x1F618,
                      @0x1F621, @0x1F625, @0x1F628, @0x1F630,
                      @0x1F631, @0x1F632, @0x1F633, @0x1F637,
                      @0x1F446, @0x1F447, @0x1F448, @0x1F449,
                      @0x1F4AA, @0x1F44A, @0x1F44C, @0x1F44D,
                      @0x1F44E, @0x1F44F, @0x1F64F, @0x1F442,
                      @0x1F443, @0x1F444, @0x1F34A, @0x1F34E,
                      @0x1F349, @0x1F353, @0x1F35A, @0x1F35C,
                      @0x1F35D, @0x1F35E, @0x1F35F, @0x1F363,
                      @0x1F367, @0x1F440,
                      @0x1F6AC, @0x1F37A, @0x1F37B, @0x1F48A,
                      @0x1F48D, @0x1F49D, @0x1F334, @0x1F339,
                      @0x1F354, @0x1F359, @0x1F373, @0x1F378,
                      @0x1F380, @0x1F382, @0x1F384, @0x1F388,
                      @0x1F389, @0x1F451, @0x1F463, @0x1F514,
                      
                      @0x1F3C6, @0x1F4A3, @0x1F4A9, @0x1F4B0,
                      @0x1F4EB, @0x1F6A4, @0x1F6B2, @0x1F68C,
                      @0x1F40E, @0x1F31F, @0x1F435, @0x1F466,
                      @0x1F467, @0x1F468, @0x1F469, @0x1F489,
                      @0x1F511, @0x1F512, @0x1F680, @0x1F684,
                      @0x1F697,
                      @0x1F42D, @0x1F42E, @0x1F42F, @0x1F47B,
                      @0x1F47C, @0x1F414, @0x1F419, @0x1F420,
                      @0x1F424, @0x1F427, @0x1F428, @0x1F433,
                      @0x1F436, @0x1F437, @0x1F438, @0x1F452,
                      @0x1F457, @0x1F480, @0x1F484, @0x1F4A4,
                      @0x1F4A6, @0x1F4A8, @0x1F41A, @0x1F41B,
                      @0x1F3A4, @0x1F3A5, @0x1F3B0, @0x1F3B8,
                      @0x1F3E0, @0x1F3E5, @0x1F3E6, @0x1F3E7,
                      @0x1F3E8, @0x1F3EA,  @0x1F004,
                      @0x1F4BB, @0x1F4BF, @0x1F6A5, @0x1F6A7,
                      @0x1F6BD, @0x1F6C0, @0x1F52B, @0x1F488,
                      @0x1F493,
                      @0x1F4E0, @0x1F4F1, @0x1F4F7, @0x1F6B9,
                      @0x1F6BA, @0x1F45C, @0x1F45F, @0x1F302,
                      @0x1F319, @0x1F455, @0x1F459, @0x1F460,
                      @0x1F462];
    [temp enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [array addObject:[Emoji emojiWithCode:[obj intValue]]];
    }];
    return array;
}



EMOJI_METHOD(XXX0,1F60C);
EMOJI_METHOD(XXX1,1F60F);
EMOJI_METHOD(XXX2,1F61A);
EMOJI_METHOD(XXX3,1F61C);
EMOJI_METHOD(XXX4,1F61D);
EMOJI_METHOD(XXX5,1F62D);
EMOJI_METHOD(XXX6,1F601);
EMOJI_METHOD(XXX7,1F609);
EMOJI_METHOD(XXX8,1F612);
EMOJI_METHOD(XXX9,1F614);
EMOJI_METHOD(XXX10,1F616);
EMOJI_METHOD(XXX11,1F618);
EMOJI_METHOD(XXX12,1F621);
EMOJI_METHOD(XXX13,1F625);
EMOJI_METHOD(XXX14,1F628);
EMOJI_METHOD(XXX15,1F630);
EMOJI_METHOD(XXX16,1F631);
EMOJI_METHOD(XXX17,1F632);
EMOJI_METHOD(XXX18,1F633);
EMOJI_METHOD(XXX19,1F637);
EMOJI_METHOD(XXX20,1F446);
EMOJI_METHOD(XXX21,1F447);
EMOJI_METHOD(XXX22,1F448);
EMOJI_METHOD(XXX23,1F449);
EMOJI_METHOD(XXX24,1F4AA);
EMOJI_METHOD(XXX25,1F44A);
EMOJI_METHOD(XXX26,1F44C);
EMOJI_METHOD(XXX27,1F44D);
EMOJI_METHOD(XXX28,1F44E);
EMOJI_METHOD(XXX29,1F44F);
EMOJI_METHOD(XXX30,1F64F);
EMOJI_METHOD(XXX31,1F442);
EMOJI_METHOD(XXX32,1F443);
EMOJI_METHOD(XXX33,1F444);
EMOJI_METHOD(XXX34,1F34A);
EMOJI_METHOD(XXX35,1F34E);
EMOJI_METHOD(XXX36,1F349);
EMOJI_METHOD(XXX37,1F353);
EMOJI_METHOD(XXX38,1F35A);
EMOJI_METHOD(XXX39,1F35C);
EMOJI_METHOD(XXX40,1F35D);
EMOJI_METHOD(XXX41,1F35E);
EMOJI_METHOD(XXX42,1F35F);
EMOJI_METHOD(XXX43,1F363);
EMOJI_METHOD(XXX44,1F367);
EMOJI_METHOD(XXX45,1F440);
EMOJI_METHOD(XXX46,1F6AC);
EMOJI_METHOD(XXX47,1F37A);
EMOJI_METHOD(XXX48,1F37B);
EMOJI_METHOD(XXX49,1F48A);
EMOJI_METHOD(XXX50,1F48D);
EMOJI_METHOD(XXX51,1F49D);
EMOJI_METHOD(XXX52,1F334);
EMOJI_METHOD(XXX53,1F339);
EMOJI_METHOD(XXX54,1F354);
EMOJI_METHOD(XXX55,1F359);
EMOJI_METHOD(XXX56,1F373);
EMOJI_METHOD(XXX57,1F378);
EMOJI_METHOD(XXX58,1F380);
EMOJI_METHOD(XXX59,1F382);
EMOJI_METHOD(XXX60,1F384);
EMOJI_METHOD(XXX61,1F388);
EMOJI_METHOD(XXX62,1F389);
EMOJI_METHOD(XXX63,1F451);
EMOJI_METHOD(XXX64,1F463);
EMOJI_METHOD(XXX65,1F514);
EMOJI_METHOD(XXX66,1F3C6);
EMOJI_METHOD(XXX67,1F4A3);
EMOJI_METHOD(XXX68,1F4A9);
EMOJI_METHOD(XXX69,1F4B0);
EMOJI_METHOD(XXX70,1F4EB);
EMOJI_METHOD(XXX71,1F6A4);
EMOJI_METHOD(XXX72,1F6B2);
EMOJI_METHOD(XXX73,1F68C);
EMOJI_METHOD(XXX74,1F40E);
EMOJI_METHOD(XXX75,1F31F);
EMOJI_METHOD(XXX76,1F435);
EMOJI_METHOD(XXX77,1F466);
EMOJI_METHOD(XXX78,1F467);
EMOJI_METHOD(XXX79,1F468);
EMOJI_METHOD(XXX80,1F469);
EMOJI_METHOD(XXX81,1F489);
EMOJI_METHOD(XXX82,1F511);
EMOJI_METHOD(XXX83,1F512);
EMOJI_METHOD(XXX84,1F680);
EMOJI_METHOD(XXX85,1F684);
EMOJI_METHOD(XXX86,1F697);
EMOJI_METHOD(XXX87,1F42D);
EMOJI_METHOD(XXX88,1F42E);
EMOJI_METHOD(XXX89,1F42F);
EMOJI_METHOD(XXX90,1F47B);
EMOJI_METHOD(XXX91,1F47C);
EMOJI_METHOD(XXX92,1F414);
EMOJI_METHOD(XXX93,1F419);
EMOJI_METHOD(XXX94,1F420);
EMOJI_METHOD(XXX95,1F424);
EMOJI_METHOD(XXX96,1F427);
EMOJI_METHOD(XXX97,1F428);
EMOJI_METHOD(XXX98,1F433);
EMOJI_METHOD(XXX99,1F436);
EMOJI_METHOD(XXX100,1F437);
EMOJI_METHOD(XXX101,1F438);
EMOJI_METHOD(XXX102,1F452);
EMOJI_METHOD(XXX103,1F457);
EMOJI_METHOD(XXX104,1F480);
EMOJI_METHOD(XXX105,1F484);
EMOJI_METHOD(XXX106,1F4A4);
EMOJI_METHOD(XXX107,1F4A6);
EMOJI_METHOD(XXX108,1F4A8);
EMOJI_METHOD(XXX109,1F41A);
EMOJI_METHOD(XXX110,1F41B);
EMOJI_METHOD(XXX111,1F3A4);
EMOJI_METHOD(XXX112,1F3A5);
EMOJI_METHOD(XXX113,1F3B0);
EMOJI_METHOD(XXX114,1F3B8);
EMOJI_METHOD(XXX115,1F3E0);
EMOJI_METHOD(XXX116,1F3E5);
EMOJI_METHOD(XXX117,1F3E6);
EMOJI_METHOD(XXX118,1F3E7);
EMOJI_METHOD(XXX119,1F3E8);
EMOJI_METHOD(XXX120,1F3EA);
EMOJI_METHOD(XXX121,1F004);
EMOJI_METHOD(XXX122,1F4BB);
EMOJI_METHOD(XXX123,1F4BF);
EMOJI_METHOD(XXX124,1F6A5);
EMOJI_METHOD(XXX125,1F6A7);
EMOJI_METHOD(XXX126,1F6BD);
EMOJI_METHOD(XXX127,1F6C0);
EMOJI_METHOD(XXX128,1F52B);
EMOJI_METHOD(XXX129,1F488);
EMOJI_METHOD(XXX130,1F493);
EMOJI_METHOD(XXX131,1F4E0);
EMOJI_METHOD(XXX132,1F4F1);
EMOJI_METHOD(XXX133,1F4F7);
EMOJI_METHOD(XXX134,1F6B9);
EMOJI_METHOD(XXX135,1F6BA);
EMOJI_METHOD(XXX136,1F45C);
EMOJI_METHOD(XXX137,1F45F);
EMOJI_METHOD(XXX138,1F302);
EMOJI_METHOD(XXX139,1F319);
EMOJI_METHOD(XXX140,1F455);
EMOJI_METHOD(XXX141,1F459);
EMOJI_METHOD(XXX142,1F460);
EMOJI_METHOD(XXX143,1F462);

@end
