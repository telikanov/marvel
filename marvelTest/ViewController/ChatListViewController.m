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
#import "UIScrollView+RefreshControl.h"

@interface ChatListViewController ()

@property (nonatomic, copy) NSArray *responseJSON;
@property (nonatomic, retain) NSMutableArray *data;

@end

@implementation ChatListViewController

- (void)viewDidLoad {
    self.offsetCharacters = 0;
    self.limitCharacters = 30;
    
    self.data = [NSMutableArray array];
    [super viewDidLoad];
    [self charactersData];
    [self addRefreshBottom];
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
    
    NSDictionary *imagePack = [arrayForCell valueForKey:@"thumbnail"];
    NSString *pathImage = [imagePack valueForKey:@"path"];
    NSString *extensionImage = [imagePack valueForKey:@"extension"];
    NSString *allPath = [NSString stringWithFormat:@"%@.%@", pathImage, extensionImage];
    
    return [cell cellFilling:[arrayForCell valueForKey:@"name"] urlImage:allPath];
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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
