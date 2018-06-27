//
//  DialogCharasterViewCell.m
//  marvelTest
//
//  Created by Алексей Теликанов on 26.06.2018.
//  Copyright © 2018 Алексей Теликанов. All rights reserved.
//

#import "DialogCharasterView.h"

@implementation DialogCharasterView


- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.avatarImageView.layer setCornerRadius:30];
    [self.containerText.layer setCornerRadius:20];
}

@end
