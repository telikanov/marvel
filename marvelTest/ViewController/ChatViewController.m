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

@interface ChatViewController () {
    DataManager *dataManager;
    ChatRLMObject *chatRLMObject;
}
@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dataManager = [DataManager new];
    chatRLMObject = [dataManager getDialogWithID:self.idCharaster];
    [self.navigationItem setTitle:[NSString stringWithFormat:@"%@", chatRLMObject.name]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didGetMyNotification)
                                                 name:@"FirsDialog"
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
