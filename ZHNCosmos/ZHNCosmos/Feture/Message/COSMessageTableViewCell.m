//
//  COSMessageTableViewCell.m
//  ZHNCosmos
//
//  Created by 连伟钦 on 2018/2/1.
//  Copyright © 2018年 zhn. All rights reserved.
//

#import "COSMessageTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "ZHNThemeManager.h"

@implementation COSMessageTableViewCell {
	UIImageView* _portrait;
	UILabel* _nameLabel;
	UILabel* _commentTextLabel;
	UILabel* _dateLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		_portrait = [[UIImageView alloc] initWithFrame:CGRectMake(16, 15, 50, 50)];
		_portrait.layer.cornerRadius = 25;
		_portrait.clipsToBounds = YES;
		[self.contentView addSubview:_portrait];
		
		_nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 15, viewWidth() - 100, 18)];
		_nameLabel.textColor = [ZHNThemeManager zhn_getThemeColor];
		_nameLabel.font = [UIFont systemFontOfSize:16];
		[self.contentView addSubview:_nameLabel];
		
		_dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
		_dateLabel.dk_textColorPicker = [DKColor grayColor];
		_dateLabel.font = [UIFont systemFontOfSize:12];
		[self.contentView addSubview:_dateLabel];
		
		_commentTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 32, viewWidth() - 100, 16)];
		_commentTextLabel.dk_textColorPicker = DKColorPickerWithKey(CellTextColor);
		_commentTextLabel.font = [UIFont systemFontOfSize:15];
		[self.contentView addSubview:_commentTextLabel];
		
		self.contentView.dk_backgroundColorPicker = DKColorPickerWithKey(CellBG);
		@weakify(self);
		self.extraNightVersionChangeHandle = ^{
			@strongify(self);
			UIView *selectView = [[UIView alloc] init];
			selectView.dk_backgroundColorPicker = DKColorPickerWithKey(CellSelectedColor);
			self.selectedBackgroundView = selectView;
		};
	}
	return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
	_commentTextLabel.dk_textColorPicker = DKColorPickerWithKey(CellTextColor);
	_commentTextLabel.font = [UIFont systemFontOfSize:15];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// setter
- (void)setComment:(ZHNTimelineComment *)comment {
	// update ui
	[_portrait sd_setImageWithURL:[NSURL URLWithString:comment.user.avatarLarge]];
	_commentTextLabel.text = comment.text;
	_nameLabel.text = comment.user.name;
	
	_dateLabel.text = comment.dateAndSourceStr;
	[_dateLabel sizeToFit];
	_dateLabel.right = viewWidth() - 15;
	_dateLabel.centerY = _nameLabel.centerY;
	
	_commentTextLabel.top = _nameLabel.bottom + 8;
}

@end
