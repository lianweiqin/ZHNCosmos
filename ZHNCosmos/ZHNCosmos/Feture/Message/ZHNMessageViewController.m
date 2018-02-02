//
//  ZHNMessageViewController.m
//  ZHNCosmos
//
//  Created by zhn on 2018/1/26.
//  Copyright © 2018年 zhn. All rights reserved.
//

#import "ZHNMessageViewController.h"
#import "ZHNUserMetaDataModel.h"
#import "ZHNCosmosConfigCommonModel.h"
#import "ZHNCosmosConfigManager.h"
#import "ZHNNetworkManager.h"
#import "COSMessageTableViewCell.h"
#import "ZHNTimelineComment.h"
#import "ZHNTimelineDetailContainViewController.h"

@interface ZHNMessageViewController ()<UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSMutableArray* messageList;
@end

@implementation ZHNMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息";
	_messageList = [NSMutableArray array];
    self.view.dk_backgroundColorPicker = DKColorPickerWithKey(NormalViewBG);
	
	[self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[[ZHNNetworkManager shareInstance] get:@"https://api.weibo.com/2/comments/to_me.json" params:[self getRequestParam]
							  responseType:ZHNResponseTypeJSON
								   success:^(id result, NSURLSessionDataTask *task) {
									   [_messageList removeAllObjects];
									   NSDictionary *resultDict;
									   if ([result isKindOfClass:[NSDictionary class]]) {
										   resultDict = result;
									   }
									   if ([result isKindOfClass:[NSData class]]) {
										   resultDict = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:nil];
									   }
									   NSArray* list = resultDict[@"comments"];
									   for (NSDictionary* dict in list) {
										   ZHNTimelineComment* item = [ZHNTimelineComment yy_modelWithDictionary:dict];
										   [_messageList addObject:item];
									   }
									   [self.tableView reloadData];
									   
								   } failure:^(NSError *error, NSURLSessionDataTask *task) {
									   
								   }];

}

- (NSDictionary *)getRequestParam {
	ZHNUserMetaDataModel *user = [ZHNUserMetaDataModel displayUserMetaData];
	ZHNCosmosConfigCommonModel *common = [ZHNCosmosConfigManager commonConfigModel];
	NSMutableDictionary *params = [NSMutableDictionary dictionary];
	[params zhn_safeSetObjetct:user.accessToken forKey:@"access_token"];
	[params zhn_safeSetObjetct:@(common.everytimeRefeshCount) forKey:@"count"];
	[params zhn_safeSetObjetct:@(1) forKey:@"page"];
	return params;
}

#pragma mark - delegate
#pragma mark - tableView datasource delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return self.messageList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	COSMessageTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"COSMessageTableViewCell"];
	if (cell == nil) {
		cell = [[COSMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"COSMessageTableViewCell"];
	}
	cell.comment = _messageList[indexPath.row];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	ZHNTimelineComment* item = _messageList[indexPath.row];
	ZHNTimelineDetailContainViewController *detailController = [[ZHNTimelineDetailContainViewController alloc]init];
	detailController.status = item.originStatus;
	detailController.defaultType = ZHNDefaultShowTypeComments;
	[self.navigationController pushViewController:detailController animated:YES];
}


#pragma mark - DZNEmptyDataSet datasource
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
	return [UIImage imageNamed:@"blank_data_placeholder"];
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
	return YES;
}

- (UITableView *)tableView {
	if (_tableView == nil) {
		_tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
		_tableView.dataSource = self;
		_tableView.delegate = self;
		_tableView.panGestureRecognizer.cancelsTouchesInView = NO;
		_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		_tableView.dk_backgroundColorPicker = DKColorPickerWithKey(CellBG);
		_tableView.estimatedRowHeight = 0;// Warning.... iOS11 estimatedRowHeight default is 'UITableViewAutomaticDimension' if u call `reloadRowsAtIndexPaths` method, tablview offset will change unordered. Set it to `0` will slove this.
		_tableView.showsVerticalScrollIndicator = NO;
		_tableView.emptyDataSetSource = self;
		_tableView.emptyDataSetDelegate = self;
	}
	return _tableView;
}
@end
