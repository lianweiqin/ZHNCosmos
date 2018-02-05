//
//  CommentView.m
//  ZHNCosmos
//
//  Created by 连伟钦 on 2018/2/5.
//  Copyright © 2018年 zhn. All rights reserved.
//

#import "CommentView.h"

@implementation CommentView{
	UITextView* _textInputView;
}

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		_textInputView = [[UITextView alloc] initWithFrame:CGRectMake(15, 25, self.width - 30, self.height - 40)];
		_textInputView.layer.borderColor = RGBCOLOR(244, 244, 244).CGColor;
		_textInputView.font = [UIFont systemFontOfSize:16];
		[self addSubview:_textInputView];
	}
	return self;
}

@end
