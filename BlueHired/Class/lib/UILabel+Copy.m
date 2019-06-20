//
//  UILabel+Copy.m
//  BlueHired
//
//  Created by iMac on 2019/4/1.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "UILabel+Copy.h"
#import <objc/runtime.h>

@implementation UILabel (Copy)

- (BOOL)copyable {
    return [objc_getAssociatedObject(self, @selector(copyable)) boolValue];
}

- (void)setCopyable:(BOOL)copyable {
    objc_setAssociatedObject(self, @selector(copyable),
                             [NSNumber numberWithBool:copyable], OBJC_ASSOCIATION_ASSIGN);
    [self addLongPressGestureRecognizer];
}
- (BOOL)Deleteable{
    return [objc_getAssociatedObject(self, @selector(Deleteable)) boolValue];

}
- (void)setDeleteable:(BOOL)Deleteable{
    objc_setAssociatedObject(self, @selector(Deleteable),
                             [NSNumber numberWithBool:Deleteable], OBJC_ASSOCIATION_ASSIGN);
    [self addLongPressGestureRecognizer];
}

- (LPUILabelDeleteBlock)DeleteBlock{
    return  objc_getAssociatedObject(self, @selector(DeleteBlock)) ;

}
- (void)setDeleteBlock:(LPUILabelDeleteBlock)DeleteBlock{
    objc_setAssociatedObject(self, @selector(DeleteBlock),
                              DeleteBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addLongPressGestureRecognizer];
}
- (LPUILabelDeleteBlock)CopyBlock{
    return  objc_getAssociatedObject(self, @selector(CopyBlock)) ;
    
}

- (void)setCopyBlock:(LPUILabelDeleteBlock)CopyBlock{
    objc_setAssociatedObject(self, @selector(CopyBlock),
                             CopyBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addLongPressGestureRecognizer];
}

- (LPUILabelTouchBlock)TouchBlock{
    return  objc_getAssociatedObject(self, @selector(TouchBlock)) ;
}

- (void)setTouchBlock:(LPUILabelTouchBlock)TouchBlock{
    objc_setAssociatedObject(self, @selector(TouchBlock),
                             TouchBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addLongPressGestureRecognizer];
}


#pragma mark - 添加长按手势和菜单消失的通知
- (void)addLongPressGestureRecognizer {
    self.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
//    longPress.minimumPressDuration = 2.0;
    [self addGestureRecognizer:longPress];
    if (self.Deleteable == NO) {
        UITapGestureRecognizer *TapGestureRecognizerimageBg = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TouchCellSelect:)];
        [self addGestureRecognizer:TapGestureRecognizerimageBg];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuControllerWillHide) name:UIMenuControllerWillHideMenuNotification object:nil];
}

#pragma mark 长按手势处理
- (void)longPress:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self becomeFirstResponder];
        UIMenuItem *copyItem = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyAction)];
        [[UIMenuController sharedMenuController] setMenuItems:@[copyItem]];

        if (self.Deleteable) {
            UIMenuItem *DeleteItem = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(DeleteAction)];
            [[UIMenuController sharedMenuController] setMenuItems:@[copyItem,DeleteItem]];
        }
        
        [[UIMenuController sharedMenuController] setTargetRect:self.frame inView:self.superview];
        [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
        self.backgroundColor = [UIColor colorWithHexString:@"#d1d1d1"];
    }
}
#pragma mark 点击手势回调
-(void)TouchCellSelect:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (self.TouchBlock) {
            self.TouchBlock();
        }
    }
}

#pragma mark 菜单消失 处理界面
- (void)menuControllerWillHide {
    [self resignFirstResponder];
    self.backgroundColor = [UIColor clearColor];
}

#pragma mark 使Label能陈伟第一响应者
- (BOOL)canBecomeFirstResponder {
    return [objc_getAssociatedObject(self, @selector(copyable)) boolValue];
}

#pragma mark 指定Label可以响应的方法（这里只用到复制）
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(copyAction)) {
        return YES;
    }else if (action == @selector(DeleteAction)){
        return YES;
    }
    return NO;
}

#pragma mark 点击复制按钮后的处理
- (void)copyAction {
    [self resignFirstResponder];
    
    //UIPasteboard 的string只能接受 NSString 类型，当Label设置的是attributedText时需要进行转换
    UIPasteboard *pastboard = [UIPasteboard generalPasteboard];
    if (self.text) {
        pastboard.string = self.text;
    }else{
        pastboard.string = self.attributedText.string;
    }
    
    if (self.CopyBlock) {
        self.CopyBlock(self);
    }
    
    self.backgroundColor = [UIColor clearColor];
}
-(void)DeleteAction{
    if (self.DeleteBlock) {
        self.DeleteBlock(self);
    }
    self.backgroundColor = [UIColor clearColor];

}

#pragma mark
- (void)dealloc {
    [self resignFirstResponder];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIMenuControllerWillHideMenuNotification object:nil];
}

 
@end
