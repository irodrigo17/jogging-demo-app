//
//  JogCell.m
//  Jogging
//
//  Created by Ignacio Rodrigo on 12/2/14.
//  Copyright (c) 2014 Ignacio Rodrigo. All rights reserved.
//

#import "JogCell.h"

static NSString * const kJogCellReuseIdentifier = @"JogCell";

@implementation JogCell

- (void)updateWithJog:(Jog*)jog
{
    if(jog){
        self.timeAndDistanceLabel.text = [jog description];
        self.dateLabel.text = [jog formattedDate];
    }
    else{
        self.timeAndDistanceLabel.text = @"No jogs yet, go for a run!";
        self.dateLabel.text = @"";
    }
}

@end
