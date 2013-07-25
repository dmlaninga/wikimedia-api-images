//
//  ViewController.h
//  test for Wikipedia API
//
//  Created by Daniel Laninga on 7/24/13.
//  Copyright (c) 2013 Daniel Laninga. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UISearchBarDelegate>
@property (weak, nonatomic) NSString *pageID;
@property (weak, nonatomic) NSString *imagePageID;
@property (strong, nonatomic) NSString *imageLocation;
@property (weak, nonatomic) NSString *imageUrlFinal;
@property (strong, nonatomic) NSMutableArray *imageUrlArray;
@property (strong, nonatomic) IBOutlet UIImageView *images;
@property (strong, nonatomic) NSURL *imageUrl;

@property (strong, nonatomic) IBOutletCollection(UICollectionView) NSArray *imageCollection;

@end
