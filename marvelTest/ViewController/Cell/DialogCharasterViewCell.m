//
//  DialogCharasterViewCell.m
//  marvelTest
//
//  Created by Алексей Теликанов on 26.06.2018.
//  Copyright © 2018 Алексей Теликанов. All rights reserved.
//

#import "DialogCharasterViewCell.h"

@implementation DialogCharasterViewCell

/*
// Only override drawRect: if you perform cust  om drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
//
- (void)awakeFromNib {
    [super awakeFromNib];
    [self.avatarImageView.layer setCornerRadius:8];
    [self.textLabel.layer setCornerRadius:5];
}
//
//- (void)fillCellWithAvatar:(NSString *)avatarPatch withText:(NSString *)text{
//
//}

@end
