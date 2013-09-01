//
//  CatAnswerCell.m
//  PlayerTest
//
//  Created by doujingxuan on 13-9-1.
//  Copyright (c) 2013年 doujingxuan. All rights reserved.
//

#import "CatAnswerCell.h"

@implementation CatAnswerCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark 刷新cell 
-(void)updateCatAnswerCell:(CatAnswerModel *)model
{
    


}

@end
