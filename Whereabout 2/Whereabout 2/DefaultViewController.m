//
//  DefaultViewController.m
//  Whereabout 2
//
//  Created by Nicolas Isaza GitHub on 4/25/15.
//  Copyright (c) 2015 Nicolas Isaza. All rights reserved.
//

#import "DefaultViewController.h"
#import "IntroPageContentViewController.h"

@interface DefaultViewController ()

@end

@implementation DefaultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _pageTitles = @[@"Log in using OneDrive", @"See what's going on nearby", @"Upload new or existing photos", @"Save any photo"];
    _pageImages = @[@"LoginPreview.PNG", @"StreamPreview.PNG", @"UploadPreview.PNG", @"EnlargeSavePreview.PNG"];
    
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    
    IntroPageContentViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    //self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 90);
    self.pageViewController.view.frame = CGRectMake(0, 0, screenRect.size.width, screenRect.size.height-45);
    
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
    // Do any additional setup after loading the view.
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

- (IBAction)beginWalkthrough:(id)sender {
    IntroPageContentViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:^(BOOL finished) {
        
    }];
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((IntroPageContentViewController *) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((IntroPageContentViewController *) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.pageTitles count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (IntroPageContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.pageTitles count] == 0) || (index >= [self.pageTitles count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    IntroPageContentViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageContentViewController"];
    
    NSLog(@"Image array: %@    Title array: %@", self.pageImages, self.pageTitles);
    
    pageContentViewController.pageImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", self.pageImages[index]]];
    UIImageView *pageImageView = [[UIImageView alloc] init];
    pageImageView.contentMode = UIViewContentModeScaleAspectFit;
    pageImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", self.pageImages[index]]];
    
    [pageContentViewController.view addSubview:pageImageView];
    
    [pageContentViewController.pageTitle setText:[NSString stringWithFormat:@"%@", self.pageTitles[index]]];
    
    pageContentViewController.pageImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", self.pageImages[index]]];
    
    NSLog(@"page title: %@", [NSString stringWithFormat:@"%@", self.pageTitles[index]]);
    
    pageContentViewController.pageIndex = index;
    
    return pageContentViewController;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.pageTitles count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

@end
