//
//  MainViewController.m
//  Colors
//
//  Created by Ignacio Romero Z. on 6/19/14.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//

#import "MainViewController.h"
#import "ColorViewCell.h"
#import "UIColor+Random.h"

#import "DZNEmptyDataSet.h"

static NSString *CellIdentifier = @"ColorViewCell";

@interface MainViewController () <DZNScrollViewDataSetDelegate, DZNScrollViewDataSetSource>
@property (nonatomic, strong) NSMutableArray *colors;
@property (nonatomic) NSInteger columnCount;

@property (nonatomic) NSIndexPath *selectedIndexPath;
@end

@implementation MainViewController

+ (instancetype)new
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 2.0;
    layout.minimumInteritemSpacing = 2;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    return [[MainViewController alloc] initWithCollectionViewLayout:layout];
}

- (id)initWithCollectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithCollectionViewLayout:layout];
    if (self) {
        
    }
    return self;
}

#pragma mark - View lifecycle

- (void)loadView
{
    [super loadView];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    CGFloat inset = layout.minimumLineSpacing*1.5;
    
    self.collectionView.backgroundView = [UIView new];
    self.collectionView.backgroundView.backgroundColor = [UIColor whiteColor];
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self.collectionView.contentInset = UIEdgeInsetsMake(inset, 0, inset, 0);
    self.collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    
    self.collectionView.dataSetSource = self;
    self.collectionView.dataSetDelegate = self;
    
    [self.collectionView registerClass:[ColorViewCell class] forCellWithReuseIdentifier:CellIdentifier];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Colors";
    self.columnCount = 5;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reloadContent)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (void)reloadContent
{
    [self loadContent];
    
    [self.collectionView reloadData];
}

- (void)loadContent
{
    _colors = nil;
    _colors = [NSMutableArray new];
    
    for (int i = 0; i < 80; i++) {
        UIColor *color = [UIColor randomColor];
        [_colors addObject:color];
    }
    
    [self.collectionView reloadData];
}

- (CGSize)cellSize
{
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    CGFloat size = (self.navigationController.view.bounds.size.width/self.columnCount) - flowLayout.minimumLineSpacing;
    return CGSizeMake(size, size);
}


#pragma mark - UICollectionViewDataSource methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _colors.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ColorViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.tag = indexPath.row;
    
    cell.backgroundColor = _colors[indexPath.row];
    
    if ([indexPath isEqual:_selectedIndexPath]) {
        cell.textLabel.text = [cell.backgroundColor hexFromColor];
    }
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}


#pragma mark - UICollectionViewDataDelegate methods

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedIndexPath = indexPath;
    
    ColorViewCell *cell = (ColorViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.textLabel.text = [_colors[indexPath.row] hexFromColor];
    cell.selected = YES;
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedIndexPath = nil;
    
    ColorViewCell *cell = (ColorViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.textLabel.text = nil;
    cell.selected = NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath;
{
    
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath;
{
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self cellSize];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeZero;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{

}


#pragma mark - DZNTableViewDataSetDataSource Methods

- (NSAttributedString *)titleForScrollViewDataSet:(UITableView *)tableView
{
    return nil;
}

- (NSAttributedString *)descriptionForScrollViewDataSet:(UITableView *)tableView
{
    NSString *text = @"No colors loaded yet.";
    
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:17.0],
                                 NSForegroundColorAttributeName: [UIColor colorWithRed:170/255.0 green:171/255.0 blue:179/255.0 alpha:1.0],
                                 NSParagraphStyleAttributeName: paragraphStyle};
    
    return [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIColor *)backgroundColorForScrollViewDataSet:(UITableView *)tableView
{
    return [UIColor whiteColor];
}

//- (UIView *)customViewForScrollViewDataSet:(UITableView *)tableView
//{
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
//    view.backgroundColor = [UIColor redColor];
//    return view;
//}


#pragma mark - View lifeterm

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}


#pragma mark - View Auto-Rotation

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

@end