//
//  ModalView.h
//  RRExtension
//
//  Created by 连伟钦 on 16/3/4.
//  Copyright © 2016年 Panda. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, ModalViewShowDirection) {
	kShowModalViewFromCenter,
	kShowModalViewFromBottom,
	kShowModalViewNormal,
	kShowModalViewNone
};

@class ModalView;

@protocol ModalViewDelegate <NSObject>

@optional
- (void)modalView:(nonnull ModalView *)modalView didDismissWithResult:(nullable NSDictionary *)result;

@end

typedef void(^ModalViewDismissBlock)(ModalView* _Nonnull modalView, NSDictionary* _Nullable result);

// 继承该类，可以实现浮层弹出窗口
@interface ModalView : UIView

@property (nullable, nonatomic, strong) ModalViewDismissBlock dismissBlock;
@property (nullable, nonatomic, weak) id<ModalViewDelegate> delegate;
@property (nonatomic, assign) CGFloat yOffsetWhenPresented;
@property (nullable, nonatomic, strong) NSDictionary *userInfo;
@property (nonatomic, readonly) BOOL showing;
@property (nullable, nonatomic, strong) UIColor *windowBackgroundColor;
@property (nonatomic, assign) BOOL tapBackgroundToDismiss;

+ (nonnull UIWindow *)window;
+ (void)hideWindow;

- (void)show:(ModalViewShowDirection)direction inWindow:(BOOL)inWindow;
- (void)dismiss;
- (void)dismissWithResult:(nullable NSDictionary *)result;

- (void)didShow;

- (void)setBackViewHidden;
- (void)setBackViewShow;

@end
