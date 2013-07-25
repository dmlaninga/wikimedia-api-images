//
//  ViewController.m
//  test for Wikipedia API
//
//  Created by Daniel Laninga on 7/24/13.
//  Copyright (c) 2013 Daniel Laninga. All rights reserved.
//
#define kBGQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //1

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UISearchBar *searchBarText;

@property (strong, nonatomic) NSURL *wikiSearchAPI;
@property (strong, nonatomic) NSURL *wikiImageSearchAPI;


@end

@implementation ViewController


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    //REMOVES ALL OBJECTS TO REPEAT SEARCH
    [self.imageUrlArray removeAllObjects];
    
    self.wikiSearchAPI = [[NSURL alloc] initWithString:@"http://en.wikipedia.org/w/api.php?format=json&indexpageids&action=query&prop=images&titles="];
    [self.view endEditing:YES];
    
    NSString *bookName = [searchBar text];
    bookName = [bookName stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSString *wikiAPI  = @"http://en.wikipedia.org/w/api.php?format=json&indexpageids&action=query&prop=images&titles=";
    bookName = [wikiAPI stringByAppendingString:bookName];
    self.wikiSearchAPI = [NSURL URLWithString:bookName];
    
    
    dispatch_async(dispatch_get_main_queue(), ^(){
        NSData* data = [NSData dataWithContentsOfURL:self.wikiSearchAPI];
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    });
    
    
    
    
    
    
}



- (void)fetchedData: (NSData *)responseData {
    //parse out the json data
    NSError *error;
    NSDictionary *json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          options:kNilOptions
                          error:&error];
    
    NSDictionary *querySearch = [json objectForKey:@"query"];
    NSArray *queryPageIds = [querySearch objectForKey:@"pageids"];
    for (NSDictionary *pageIds in queryPageIds) {
        self.pageID = [NSString stringWithFormat:@"%@", pageIds];
        //NSLog(@"The page id is %@", self.pageID);
        
    }
    //NSLog(@"%@", querySearch);
    NSDictionary *queryPages = [querySearch objectForKey:@"pages"];
    //NSLog(@"%@", queryPages);
    NSDictionary *queriedPageId = [queryPages objectForKey:self.pageID];
    //NSLog(@"%@", queriedPageId);
    NSDictionary *queryImages = [queriedPageId objectForKey:@"images"];
    //NSLog(@"%@", queryImages);
    NSDictionary *imageFilenames = [queryImages valueForKey:@"title"];
    //NSLog(@"%@", imageFilenames);
    for (NSDictionary *image in imageFilenames) {
        //NSLog(@"%@", image);
        self.imageLocation = [NSString stringWithFormat:@"%@", image];
        //NSLog(@"%@", self.imageLocation);
        self.imageLocation = [self.imageLocation substringFromIndex:5];
        self.imageLocation = [self.imageLocation stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
       // NSLog(@"%@", self.imageLocation);
        
        
        
        
        NSString *wikiImageAPI = @"http://en.wikipedia.org/w/api.php?action=query&format=json&indexpageids&prop=imageinfo&iiprop=url&titles=Image:";
        self.imageLocation = [wikiImageAPI stringByAppendingString:self.imageLocation];

        
        self.wikiImageSearchAPI = [NSURL URLWithString:self.imageLocation];
        //NSLog(@"This is the WikiImageSearchAPI: %@", self.wikiImageSearchAPI);
        
        //find page ids for the image search API
        NSData* imageData = [NSData dataWithContentsOfURL:self.wikiImageSearchAPI];
        [self performSelectorOnMainThread:@selector(imageData:) withObject:imageData waitUntilDone:YES];
        
        
        
    }
    
    [self updateUI];


}

- (void)updateUI {
    NSLog(@"The array of urls: %@", self.imageUrlArray);
    
}




- (void)imageData: (NSData *)responseImageData {
    NSError *error;
    NSDictionary *jsonImage = [NSJSONSerialization JSONObjectWithData:responseImageData options:kNilOptions error:&error];
    
    NSDictionary *queryImageSearch = [jsonImage objectForKey:@"query"];
    NSDictionary *queryImagePageIds = [queryImageSearch objectForKey:@"pageids"];
    for (NSDictionary *imagePageIds in queryImagePageIds) {
        self.imagePageID = [NSString stringWithFormat:@"%@", imagePageIds];
        //NSLog(@"The image page is is %@", self.imagePageID);
        
        NSDictionary *queryImagePages = [queryImageSearch objectForKey:@"pages"];
        NSDictionary *queryImagePageId = [queryImagePages objectForKey:self.imagePageID];
        NSDictionary *queryImageInfo = [queryImagePageId objectForKey:@"imageinfo"];
        
        
        NSDictionary *imageUrlInfo = [queryImageInfo valueForKey:@"url"];
        
        for (NSDictionary *finalImageUrl in imageUrlInfo) {
            self.imageUrlFinal = [NSString stringWithFormat:@"%@", finalImageUrl];
            NSLog(@"The URL for the image is is:%@", self.imageUrlFinal);
            if ([self.imageUrlFinal hasSuffix:@".jpg"]) {
                [self.imageUrlArray addObject:self.imageUrlFinal];
            }
        
        }
        
       
    
    }
    
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.wikiImageSearchAPI = [[NSURL alloc] initWithString:@"http://en.wikipedia.org/w/api.php"];
    self.wikiSearchAPI = [[NSURL alloc] initWithString:@"http://en.wikipedia.org/w/api.php"];
    self.imageUrlArray = [[NSMutableArray alloc] init];
    self.images = [[UIImageView alloc] init];
    self.imageUrl = [[NSURL alloc] init];
    }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
