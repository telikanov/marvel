//
//  ChatListViewController.h
//  marvelTest
//
//  Created by Алексей Теликанов on 25.06.2018.
//  Copyright © 2018 Алексей Теликанов. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatListViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) NSInteger currentCharacters;
@property (nonatomic, assign) NSInteger offsetCharacters;
@property (nonatomic, assign) NSInteger limitCharacters;
@property (nonatomic, assign) NSInteger totalCharacters;

@end
