//
//  CommentViewController.m
//  ZHNCosmos
//
//  Created by 连伟钦 on 2018/2/5.
//  Copyright © 2018年 zhn. All rights reserved.
//

#import "CommentViewController.h"
#import <HMEmoticonManager.h>
#import <HMEmoticonTextView.h>
#import "SINPublishToolBar.h"
#import "IQKeyboardManager.h"
#import "PostManager.h"

@interface CommentViewController()<YYTextKeyboardObserver, UINavigationControllerDelegate>
@property (weak, nonatomic) HMEmoticonTextView *postTextView;
@property (weak, nonatomic) SINPublishToolBar *publishTooBar;
@end

@implementation CommentViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	[self.postTextView becomeFirstResponder];
	
	[(UIButton *)self.lmj_navgationBar.rightView setEnabled:NO];
	
	[self publishTooBar];
	
	
}

- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	IQKeyboardManager.sharedManager.enable = NO;
}

- (void)textViewDidChange:(HMEmoticonTextView *)textView {
	[(UIButton *)self.lmj_navgationBar.rightView setEnabled:textView.emoticonText.length >= 5];
}

- (HMEmoticonTextView *)postTextView {
	if (_postTextView == nil) {
		HMEmoticonTextView *postTextView = [[HMEmoticonTextView alloc] init];
		[self.view addSubview:postTextView];
		_postTextView = postTextView;
		
		// 1> 使用表情视图
		postTextView.useEmoticonInputView = YES;
		// 2> 设置占位文本

		postTextView.placeholder = @"发表评论";
		if (self.comment.user.name != nil) {
			postTextView.placeholder = [NSString stringWithFormat:@"回复%@", self.comment.user.name];
		}
		// 3> 设置最大文本长度
		postTextView.maxInputLength = 200;
		
		//        与原生键盘之间的切换
		//        _textView.useEmoticonInputView = !_textView.isUseEmoticonInputView;
		
		[postTextView mas_makeConstraints:^(MASConstraintMaker *make) {
			
			make.top.offset([self lmjNavigationHeight:self.lmj_navgationBar]);
			make.left.right.offset(0);
			make.height.equalTo(self.view).multipliedBy(0.4);
		}];
	}
	return _postTextView;
}

- (SINPublishToolBar *)publishTooBar
{
	if(_publishTooBar == nil)
	{
		SINPublishToolBar *publishTooBar = [SINPublishToolBar publishToolBar];
		[self.view addSubview:publishTooBar];
		_publishTooBar = publishTooBar;
		
		publishTooBar.frame = CGRectMake(0, screenHeight() - 40, viewWidth(), 40);
		
		[[YYTextKeyboardManager defaultManager] addObserver:self];
		
		@weakify(self);
		publishTooBar.selectInput = ^(SINPublishToolBarClickType type) {
			@strongify(self);
			if (type == SINPublishToolBarClickTypeKeyboard) {
				
				self.postTextView.useEmoticonInputView = NO;
				
			}else if (type == SINPublishToolBarClickTypeEmos) {
				self.postTextView.useEmoticonInputView = YES;
				
			}
			
			BOOL isf = self.postTextView.isFirstResponder;
			
			if (!isf) {
				[self.postTextView becomeFirstResponder];
			}
		};
	}
	return _publishTooBar;
}

- (void)keyboardChangedWithTransition:(YYTextKeyboardTransition)transition {
	//    typedef struct {
	//        BOOL fromVisible; ///< Keyboard visible before transition.
	//        BOOL toVisible;   ///< Keyboard visible after transition.
	//        CGRect fromFrame; ///< Keyboard frame before transition.
	//        CGRect toFrame;   ///< Keyboard frame after transition.
	//        NSTimeInterval animationDuration;       ///< Keyboard transition animation duration.
	//        UIViewAnimationCurve animationCurve;    ///< Keyboard transition animation curve.
	//        UIViewAnimationOptions animationOption; ///< Keybaord transition animation option.
	//    } YYTextKeyboardTransition;
	
	[UIView animateWithDuration:transition.animationDuration animations:^{
		
		[UIView setAnimationBeginsFromCurrentState:YES];
		
		[UIView setAnimationCurve:transition.animationCurve];
		
		
		self.publishTooBar.y += transition.toFrame.origin.y - transition.fromFrame.origin.y;
	}];
}


#pragma mark - LMJNavUIBaseViewControllerDataSource

- (UIReturnKeyType)textViewControllerLastReturnKeyType:(LMJTextViewController *)textViewController
{
	return UIReturnKeySend;
}

- (BOOL)textViewControllerEnableAutoToolbar:(LMJTextViewController *)textViewController
{
	return NO;
}
- (void)textViewController:(LMJTextViewController *)textViewController inputViewDone:(id)inputView {
	[self rightButtonEvent:nil navigationBar:self.lmj_navgationBar];
}


/** 导航条左边的按钮 */
- (UIImage *)lmjNavigationBarLeftButtonImage:(UIButton *)leftButton navigationBar:(LMJNavigationBar *)navigationBar
{
	[leftButton setTitle:@"取消" forState:UIControlStateNormal];
	[leftButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
	[leftButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
	
	return nil;
}


- (UIImage *)lmjNavigationBarRightButtonImage:(UIButton *)rightButton navigationBar:(LMJNavigationBar *)navigationBar
{
	[rightButton setTitle:@"发表" forState:UIControlStateNormal];
	[rightButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
	[rightButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
	[rightButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
	
	return nil;
}

- (NSMutableAttributedString *)lmjNavigationBarTitle:(LMJNavigationBar *)navigationBar
{
	NSMutableAttributedString *faweibo = [[NSMutableAttributedString alloc] initWithString:@"发评论"];
	
	[faweibo addAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:16], NSForegroundColorAttributeName : [UIColor blackColor]} range:NSMakeRange(0, faweibo.length)];
	return faweibo;
}

#pragma mark - LMJNavUIBaseViewControllerDelegate
/** 左边的按钮的点击 */
-(void)leftButtonEvent:(UIButton *)sender navigationBar:(LMJNavigationBar *)navigationBar {
	[self dismissPopUpViewController:DDPopUpAnimationTypeFade];
}

- (void)rightButtonEvent:(UIButton *)sender navigationBar:(LMJNavigationBar *)navigationBar {
//#warning 发表评论
	[PostManager postComment:self.postTextView.emoticonText weiboId:self.comment.originStatus.statusID commentId:self.comment.ID];
	[self dismissPopUpViewController:DDPopUpAnimationTypeFade];
}

- (void)dealloc {
	[[YYTextKeyboardManager defaultManager] removeObserver:self];
}

@end
