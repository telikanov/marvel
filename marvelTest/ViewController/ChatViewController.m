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
    NSString *currentReplica;
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
    [self setMyReplicas];
}

- (void)firstMessageFrom {
    DialogCharasterView *dialogView = [[[NSBundle mainBundle] loadNibNamed:@"DialogCharasterView" owner:self options:nil] objectAtIndex:0];
    
    SDImageCache* myCache = [SDImageCache sharedImageCache];
    UIImage* avatar = [myCache imageFromDiskCacheForKey:self.chatRLMObject.avatarPath];
    dialogView.avatarImageView.image = avatar;
    dialogView.textLabel.text = [NSString stringWithFormat:@"Привет,герой, меня зовут %@",self.chatRLMObject.name];
    
    [self.dialogStackView addArrangedSubview:dialogView];
    
}

- (void)setMyReplicas {
    NSArray *myReplicas = [NSArray arrayWithObjects:@"Привет, я твой создатель!", @"Ты кто такой?", @"Хочу спать", nil];
    for(NSString *replicas in myReplicas) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:replicas forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor redColor]];
        [button addTarget:self
                   action:@selector(touchDown:)
         forControlEvents:UIControlEventTouchUpInside];
        CGRect      buttonFrame = button.frame;
        buttonFrame.size = CGSizeMake(150, 70);
        button.frame = buttonFrame;
        [self.variantsAnswersStackView addArrangedSubview:button];
    }
}

- (IBAction)touchDown:(id)sender {
    UIButton *button = (UIButton*)sender;
    DialogCharasterView *dialogView = [[[NSBundle mainBundle] loadNibNamed:@"DialogCharasterView" owner:self options:nil] objectAtIndex:0];
    
    dialogView.avatarImageView.hidden = YES;
    dialogView.textLabel.text = button.titleLabel.text;
    dialogView.containerText.backgroundColor = [UIColor grayColor];
    [dialogView.containerText.layer setCornerRadius:9];
    dialogView.layer.cornerRadius = 10;
    dialogView.clipsToBounds = true;
    
    
    [self.dialogStackView addArrangedSubview:dialogView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
