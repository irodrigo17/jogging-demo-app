//
//  FiltersViewController.h
//  Jogging
//
//  Created by Ignacio Rodrigo on 12/9/14.
//  Copyright (c) 2014 Ignacio Rodrigo. All rights reserved.
//

#import "XLFormViewController.h"


@protocol FiltersViewControllerDelegate;


@interface FiltersViewController : XLFormViewController

@property (weak, nonatomic) id<FiltersViewControllerDelegate> delegate;
@property (strong, nonatomic) NSDictionary *filters;

@end


@protocol FiltersViewControllerDelegate <NSObject>

@required

- (void)filtersViewController:(FiltersViewController*)viewController didApplyFilters:(NSDictionary*)filters;
                               
@end