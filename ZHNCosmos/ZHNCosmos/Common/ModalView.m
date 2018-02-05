//
//  ModalView.m
//  RRExtension
//
//  Created by 连伟钦 on 16/3/4.
//  Copyright © 2016年 Panda. All rights reserved.
//

#import "ModalView.h"
#import "UIView+Frame.h"
#import "RRGlobalMetrics.h"

static NSInteger gNumberOfModalViewShowing = 0;
static UIWindow *gWindow;

@implementation ModalView {
	__weak UIView *_backView;
	BOOL _showing;
	BOOL _inWindow;
	ModalViewShowDirection _direction;
	NSDictionary *_result;
}

// 用一个独立的window来展示这些弹窗，否则弹窗可能被加到系统弹窗用的window，意外消失
+ (UIWindow *)window {
	if (gWindow == nil) {
		gWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
		gWindow.windowLevel = UIWindowLevelNormal + 1;
	}
	gWindow.hidden = NO;
	return gWindow;
}

+ (void)hideWindow {
	if (gWindow.subviews.count == 0) {
		gWindow.hidden = YES;
		//		gWindow = nil;
		
		// 这里如果把gWindow设为nil在ios7上会导致未知问题
	}
}

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		_direction = kShowModalViewNone;
		_tapBackgroundToDismiss = YES;
	}
	return self;
}

- (void)dealloc {
	[self clean];
}

- (BOOL)showing {
	return _showing;
}

- (void)show {
	[self show:kShowModalViewFromBottom inWindow:YES];
}

- (void)createContainer:(BOOL)inWindow {
	_inWindow = inWindow;
	
	UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth(), [UIScreen mainScreen].bounds.size.height)];
	
	// 取消
	UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, viewWidth(), view.height)];
	if (gNumberOfModalViewShowing == 0) {
		if (self.windowBackgroundColor) {
			[cancelBtn setBackgroundColor:self.windowBackgroundColor];
		}
		else {
			[cancelBtn setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5]];
		}
	}
	else {
		[cancelBtn setBackgroundColor:[UIColor clearColor]];
	}
	[view addSubview:cancelBtn];
	[cancelBtn addTarget:self action:@selector(cancelTapped) forControlEvents:UIControlEventTouchUpInside];
	
	_backView = view;
	
	if (inWindow) {
		[[ModalView window] addSubview:_backView];
	}
	else {
		_backView.frame = [[UIApplication sharedApplication].delegate window].rootViewController.view.bounds;
		[[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:_backView];
	}
}

- (void)show:(ModalViewShowDirection)direction inWindow:(BOOL)inWindow {
	if (_showing) {
		return;
	}
	
	[self createContainer:inWindow];
	
	_direction = direction;
	
	if (direction == kShowModalViewFromBottom) {
		[self showFromBottom];
	}
	else if (direction == kShowModalViewFromCenter) {
		[self showFromCenter];
	}
	else if (direction == kShowModalViewNormal) {
		[self setInitCenter];
		
		[_backView addSubview:self];
		
		[self didShow];
	}
}

- (void)showFromBottom {
	[_backView addSubview:self];
	self.top = _backView.bottom;
	[UIView animateWithDuration: 0.3
					 animations: ^{
						 self.bottom = _backView.height;
						 [self didShow];
					 }];
	gNumberOfModalViewShowing++;
	_showing = YES;
}

- (void)showFromCenter {
	[self setInitCenter];
	
	self.transform = CGAffineTransformMakeScale(0.1, 0.1);
	[_backView addSubview:self];
	[UIView animateWithDuration:0.3 animations:^{
		self.transform = CGAffineTransformIdentity;
	} completion:^(BOOL finished) {
		self.transform = CGAffineTransformIdentity;
		[self didShow];
	}];
	++gNumberOfModalViewShowing;
	_showing = YES;
}

- (void)setInitCenter {
	self.center = CGPointMake(_backView.width / 2, _backView.height / 2);
	if (self.yOffsetWhenPresented > 0) {
		self.center = CGPointMake(_backView.width / 2, self.yOffsetWhenPresented);
	}
}

- (void)cancelTapped {
	if (self.tapBackgroundToDismiss) {
		[self dismiss];
	}
}

- (void)dismiss {
	[self dismissWithResult:nil];
}

- (void)dismissWithResult:(NSDictionary*)result {
	_result = result;
	
	switch (_direction) {
		case kShowModalViewFromCenter:
			[self dismissToCenter];
			break;
		case kShowModalViewFromBottom:
			[self dismissToBottom];
			break;
		case kShowModalViewNormal:
			[self didDismissed];
			break;
		default:
			break;
	}
}

- (void)dismissToBottom {
	[UIView animateWithDuration: 0.3
					 animations: ^{
						 self.top = _backView.height;
					 }
					 completion: ^(BOOL finished) {
						 [self didDismissed];
					 }];
}

- (void)dismissToCenter {
	_backView.hidden = YES;
	[self didDismissed];
}

- (void)didDismissed {
	if (self.userInfo) {
		NSMutableDictionary *result = [_result mutableCopy];
		[result addEntriesFromDictionary:self.userInfo];
		_result = result;
	}
	
	// clean up
	[self clean];
	
	[_backView removeFromSuperview];
	
	if (_inWindow) {
		[ModalView hideWindow];
	}
	// 通知客户端
	if (self.dismissBlock) {
		self.dismissBlock(self, _result);
	}
	else if ([self.delegate respondsToSelector:@selector(modalView:didDismissWithResult:)]) {
		[self.delegate modalView:self didDismissWithResult:_result];
	}
	_result = nil;
	
}

- (void)clean {
	if (_showing) {
		--gNumberOfModalViewShowing;
		_showing = NO;
		
		//		_result = nil;
	}
}

- (void)setBackViewHidden{
	_backView.hidden = YES;
}

- (void)setBackViewShow{
	_backView.hidden = NO;
}

- (void)didShow {
	
}

@end