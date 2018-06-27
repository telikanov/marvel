//
//  ChatListViewController.m
//  marvelTest
//
//  Created by Алексей Теликанов on 25.06.2018.
//  Copyright © 2018 Алексей Теликанов. All rights reserved.
//

#import "ChatListViewController.h"
#import "CharacterTableViewCell.h"
#import "NetworkManager.h"
#import "DataManager.h"
#import "UIScrollView+RefreshControl.h"
#import "ChatViewController.h"

@interface ChatListViewController ()

@property (nonatomic, copy) NSArray *responseJSON;
@property (nonatomic, retain) NSMutableArray *data;
@property (nonatomic, strong) NSString *allPath;

@end

@implementation ChatListViewController

- (void)viewDidLoad {
    self.offsetCharacters = 0;
    self.limitCharacters = 30;
    
    self.data = [NSMutableArray array];
    [super viewDidLoad];
    [self charactersData];
    [self addRefreshBottom];
    
    [self.navigationItem setTitle:@"Герои Marvel"];
}

- (void)addRefreshBottom {
    __weak typeof(self) weakSelf = self;
    [self.tableView addBottomRefreshControlUsingBlock:^{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [weakSelf charactersData];
    });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
            [weakSelf.tableView bottomRefreshControlStopRefreshing];
        });
    } refreshControlPullType:RefreshControlPullTypeSensitive refreshControlStatusType:RefreshControlStatusTypeArrow];
}

- (void) charactersData {
    __weak __typeof__(self) weakSelf = self;
    [[NetworkManager sharedManager] getCharacters:@"1" limit:[NSString stringWithFormat:@"%ld", (long)self.limitCharacters] offset:[NSString stringWithFormat:@"%ld", (long)self.offsetCharacters] completionHandler:^(NSArray *array) {
        if (array) {
            weakSelf.responseJSON = [array valueForKey:@"data"];
            weakSelf.responseJSON = [weakSelf.responseJSON valueForKey:@"results"];
            [weakSelf.data addObjectsFromArray:weakSelf.responseJSON];
            weakSelf.offsetCharacters += 30;
            [[self tableView] reloadData];
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.data.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CharacterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    NSArray *arrayForCell = [self dataPreparationForCell:self.data cellForRowAtIndexPath:indexPath];
    
    return [cell cellFilling:[arrayForCell valueForKey:@"name"] urlImage:[self getFullPathImage:arrayForCell]];
}

-(NSArray *)dataPreparationForCell:(NSMutableArray *)dataMutableArray cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *responseObjectData = [NSArray arrayWithArray:dataMutableArray];
    responseObjectData = responseObjectData[indexPath.row];
    
    return responseObjectData;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *arrayForCell = [self dataPreparationForCell:self.data cellForRowAtIndexPath:indexPath];
    [[DataManager new] insertDataIntoDataBaseWithId:[arrayForCell valueForKey:@"id"] witchName:[arrayForCell valueForKey:@"name"] witchAvatar:[self getFullPathImage:arrayForCell]];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    ChatViewController *chatViewController = [ChatViewController new];
    chatViewController.idCharaster = [[arrayForCell valueForKey:@"id"] longLongValue];
    [self.navigationController pushViewController:chatViewController animated:YES];
}

- (NSString *)getFullPathImage:(NSArray *)arrayForCell {
    NSDictionary *imagePack = [arrayForCell valueForKey:@"thumbnail"];
    NSString *pathImage = [imagePack valueForKey:@"path"];
    NSString *extensionImage = [imagePack valueForKey:@"extension"];
    NSString *patchImage = [NSString stringWithFormat:@"%@.%@", pathImage, extensionImage];
    return patchImage;
}

@end
