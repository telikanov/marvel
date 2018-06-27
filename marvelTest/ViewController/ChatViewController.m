//
//  ChatViewController.m
//  marvelTest
//
//  Created by Алексей Теликанов on 26.06.2018.
//  Copyright © 2018 Алексей Теликанов. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatRLMObject.h"
#import "DataManager.h"
#import "DialogCharasterView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ChatViewController () {
    DataManager *dataManager;
}
@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    dataManager = [DataManager new];
    self.chatRLMObject = [dataManager getDialogWithID:self.idCharaster];
    [self.navigationItem setTitle:[NSString stringWithFormat:@"%@", self.chatRLMObject.name]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(firstMessageFrom)
                                                 name:@"FirsDialog"
                                               object:nil];
    
    [self firstMessageFrom];
}

- (void)firstMessageFrom {
    DialogCharasterView *dialogView = [[[NSBundle mainBundle] loadNibNamed:@"DialogCharasterView" owner:self options:nil] objectAtIndex:0];
    
    SDImageCache* myCache = [SDImageCache sharedImageCache];
    UIImage* avatar = [myCache imageFromDiskCacheForKey:self.chatRLMObject.avatarPath];
    dialogView.avatarImageView.image = avatar;
    dialogView.textLabel.text = [NSString stringWithFormat:@"Привет, мой друг, меня зовут %@",self.chatRLMObject.name];
    
    [self.dialogStackView addArrangedSubview:dialogView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
