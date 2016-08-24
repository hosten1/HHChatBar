//
//  LDEditNoteModelViewController.m
//  Linkdood
//
//  Created by VRV2 on 16/8/3.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import "LDEditNoteModelViewController.h"

@interface LDEditNoteModelViewController ()<UITextViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titieLable;
@property (weak, nonatomic) IBOutlet UITextField *keyWordLable;

@property (weak, nonatomic) IBOutlet UILabel *contentLable;
@property (weak, nonatomic) IBOutlet UITextField *titileFiled;
@property (weak, nonatomic) IBOutlet UITextField *keyWorldFiled;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@end

@implementation LDEditNoteModelViewController
-(void)awakeFromNib{
    NSLog(@"在这里初始所有数据");
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"记事本编辑";
    if (self.noteModel) {
        self.titileFiled.text = _noteModel.title;
        self.keyWorldFiled.text = _noteModel.keyword;
        if (self.noteModel.type == NOTE_TYPE_TEXT) {
            self.contentTextView.editable = YES;
            self.contentTextView.text = _noteModel.content;
        }else{
           
            self.contentTextView.editable = NO;
            self.contentTextView.text = @"该笔记不是文本类型，内容暂不支持编辑";
        }
        
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //注册通知,监听键盘出现
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleKeyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    //注册通知，监听键盘消失事件
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleKeyboardDidHidden) name:UIKeyboardDidHideNotification object:nil];

}
//监听事件
- (void)handleKeyboardDidShow:(NSNotification*)paramNotification
{
    //获取键盘高度
    NSValue *keyboardRectAsObject=[[paramNotification userInfo]objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect;
    [keyboardRectAsObject getValue:&keyboardRect];
    
    self.contentTextView.contentInset=UIEdgeInsetsMake(0, 0,keyboardRect.size.height, 0);
}

- (void)handleKeyboardDidHidden
{
    self.contentTextView.contentInset=UIEdgeInsetsZero;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark  --修改成功返回
- (IBAction)submitChange:(id)sender {
        self.noteModel.title = self.titileFiled.text;
        self.noteModel.keyword = self.keyWorldFiled.text;
        self.noteModel.content = self.contentTextView.text;
        [_noteList editNote:_noteModel completion:^(NSError *error) {
           if (!error) {
               [self.navigationController popViewControllerAnimated:YES];
           }
      }];
}
#pragma mark -- textFiled 代理方法
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
#pragma  mark --textView代理方法
-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range

 replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        
        return NO;
        
    }
    
    return YES;
    
}
@end
