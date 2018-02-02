//
//  COSMessageTableViewCell.m
//  ZHNCosmos
//
//  Created by 连伟钦 on 2018/2/1.
//  Copyright © 2018年 zhn. All rights reserved.
//

#import "COSMessageTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation COSMessageTableViewCell {
	UIImageView* _portrait;
	UILabel* _commentTextLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		_portrait = [[UIImageView alloc] initWithFrame:CGRectMake(16, 5, 50, 50)];
		_portrait.layer.cornerRadius = 25;
		_portrait.clipsToBounds = YES;
		_commentTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 18, 300, 16)];
		_commentTextLabel.dk_textColorPicker = DKColorPickerWithKey(CellTextColor);
		_commentTextLabel.font = [UIFont systemFontOfSize:15];
		[self.contentView addSubview:_portrait];
		[self.contentView addSubview:_commentTextLabel];
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

// getter
- (void)setComment:(ZHNTimelineComment *)comment {
	// update ui
	[_portrait sd_setImageWithURL:[NSURL URLWithString:comment.user.avatarLarge]];
	_commentTextLabel.text = comment.text;
}

@end
