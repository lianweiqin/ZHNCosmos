//
//  RRGlobalMetrics.m
//  RRExtension
//
//  Created by 连伟钦 on 16/3/1.
//  Copyright © 2016年 Panda. All rights reserved.
//
#import "RRGlobalMetrics.h"

CGRect RRScreenBounds() {
	CGRect bounds = [UIScreen mainScreen].bounds;
	return bounds;
}

// 默认 rrscrollview 和 tableview 的frame 从 导航栏底部开始
CGRect RRNavigationFrame() {
	CGRect frame = [UIScreen mainScreen].bounds;
	
	// 普通的20 iPhone X 是44
	CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
	CGFloat naviHeight = 44;
	CGRect rect =  CGRectMake(0, statusBarHeight + naviHeight, frame.size.width, frame.size.height - (statusBarHeight + naviHeight));
	return rect;
}

CGFloat screenHeight() {
	static CGFloat screenHeight = 0;
	if (screenHeight == 0) {
		screenHeight = RRScreenBounds().size.height;
	}
	
	return screenHeight;
}


CGFloat viewWidth() {
	static CGFloat viewWidth = 0;
	if (viewWidth == 0) {
		viewWidth = RRScreenBounds().size.width;
	}
	
	return viewWidth;
}

CGFloat viewHeight() {
	static CGFloat viewHeight = 0;
	if (viewHeight == 0) {
		viewHeight = RRScreenBounds().size.height;
	}
	
	return viewHeight;
}

CGFloat viewRatio320(){
	static CGFloat viewRatio320 = 0;
	if (viewRatio320 == 0){
		viewRatio320 = viewWidth() / 320;
	}
	return viewRatio320;
}

CGFloat viewRatio375(){
	static CGFloat viewRatio375 = 0;
	if (viewRatio375 == 0){
		viewRatio375 = viewWidth() / 375;
	}
	return viewRatio375;
}

CGRect NIRectInset(CGRect rect, UIEdgeInsets insets) {
	return CGRectMake(rect.origin.x + insets.left,
					  rect.origin.y + insets.top,
					  rect.size.width - insets.left - insets.right,
					  rect.size.height - insets.top - insets.bottom);
}
