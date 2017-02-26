//
//  CoverflowLayout.swift
//  ESCoverFlowLayoutExample
//
//  Created by Serkan Sokmen on 25/02/2017.
//  Copyright © 2017 Serkan Sokmen. All rights reserved.
//
import UIKit


public class ESCoverFlowLayout: UICollectionViewFlowLayout {
    
    public var maxCoverDegree: CGFloat!
    public var coverDensity: CGFloat!
    public var minCoverOpacity: CGFloat!
    public var minCoverScale: CGFloat!
    public var isSnapEnabled: Bool = true
    
    fileprivate let kDistanceToProjectionPlane: CGFloat = 500.0
    fileprivate var cache = [UICollectionViewLayoutAttributes]()
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    override init() {
        super.init()
        self.commonInit()
    }
    
    func commonInit() {
        self.maxCoverDegree = 22.5
        self.coverDensity = 0.125 // 1/8
        self.minCoverOpacity = 0.4
        self.minCoverScale = 1.0
    }
    
    override public func prepare() {
        super.prepare()
        
        assert(self.collectionView?.numberOfSections == 1, "Multiple sections are not supported")
        assert(self.scrollDirection == .horizontal, "Vertical scrolling is not supported")
        
        cache.removeAll(keepingCapacity: false)
        for item in 0..<self.collectionView!.numberOfItems(inSection: 0) {
            guard let attributes = self.layoutAttributesForItem(at: IndexPath(item: item, section: 0)) else { return }
            cache.append(attributes)
        }
        
        self.collectionView?.decelerationRate = UIScrollViewDecelerationRateFast
    }
    
    override public func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        // return attributes from cache
        return self.indexPathsContained(inRect: rect).map { self.cache[$0.item] }
    }
    
    override public func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        guard let attributes = super.layoutAttributesForItem(at:indexPath) else { return nil }
        
        attributes.size = self.itemSize
        let centerX = self.collectionViewWidth * CGFloat(indexPath.row) + self.collectionViewWidth
        let centerY = self.collectionViewHeight / 2
        attributes.center = CGPoint(x: centerX, y: centerY)
        self.interpolateAttributes(attributes, forOffset: self.collectionView!.contentOffset.x)
        
        return attributes
    }
    
    override public func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let attributes = super.finalLayoutAttributesForDisappearingItem(at: itemIndexPath) else { return nil }
        attributes.transform = attributes.transform.translatedBy(x: 0, y: self.itemSize.height)
        attributes.alpha = 0.0
        
        return attributes
    }
    
    override public var collectionViewContentSize: CGSize {
        guard let collectionView = self.collectionView else { return .zero }
        let width = collectionView.bounds.size.width * CGFloat(collectionView.numberOfItems(inSection: 0))
        let height = collectionView.bounds.size.height
        return CGSize(width: width, height: height)
    }
    
    var collectionViewWidth: CGFloat {
        return self.collectionView?.bounds.size.width ?? 0.0
    }
    
    var collectionViewHeight: CGFloat {
        return self.collectionView?.bounds.size.height ?? 0.0
    }
    
    override public func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        let defaults = super.targetContentOffset(forProposedContentOffset: proposedContentOffset)
        guard self.isSnapEnabled else { return defaults }
        guard let collectionView = self.collectionView else { return defaults }
        
        // snap items to center after dragging
        var offsetAdjustment = CGFloat(MAXFLOAT)
        let horizontalCenter = proposedContentOffset.x + (collectionView.bounds.width / 2.0)
        let targetRect = CGRect(x: proposedContentOffset.x, y: 0.0, width: self.collectionViewWidth, height: self.collectionViewHeight)
        guard let array = self.layoutAttributesForElements(in: targetRect) else { return defaults }
        
        for attributes in array {
            let itemHorizontalCenter = self.itemCenter(forItem: attributes.indexPath.item).x
            if abs(itemHorizontalCenter - horizontalCenter) < abs(offsetAdjustment) {
                offsetAdjustment = itemHorizontalCenter - horizontalCenter
            }
        }
        
        return CGPoint(x: proposedContentOffset.x + offsetAdjustment, y: proposedContentOffset.y)
    }
}

// MARK: - Private
extension ESCoverFlowLayout {
    
    fileprivate func itemCenter(forItem item: Int) -> CGPoint {
        return CGPoint(x: CGFloat(item) * self.collectionViewWidth + self.collectionViewWidth / 2,
                       y: self.collectionViewHeight / 2)
    }
    
    private func minX(forItem item: Int) -> CGFloat {
        return self.itemCenter(forItem: item - 1).x + (1.0 / 2 - self.coverDensity) * self.itemSize.width
    }
    
    private func maxX(forItem item: Int) -> CGFloat {
        return self.itemCenter(forItem: item + 1).x - (1.0 / 2 - self.coverDensity) * self.itemSize.width
    }
    
    private func minXCenter(forItem item: Int) -> CGFloat {
        let halfWidth: CGFloat = self.itemSize.width / 2
        let maxRads: CGFloat = self.maxCoverDegree.degreesToRadians
        let center: CGFloat = self.itemCenter(forItem: item - 1).x
        let prevItemRightEdge: CGFloat = center + halfWidth
        let projectedLeftEdgeLocal: CGFloat = halfWidth * cos(maxRads) * kDistanceToProjectionPlane / (kDistanceToProjectionPlane + halfWidth * sin(maxRads))
        
        return prevItemRightEdge - self.coverDensity * self.itemSize.width + projectedLeftEdgeLocal
    }
    
    private func maxXCenter(forItem item: Int) -> CGFloat {
        let halfWidth: CGFloat = self.itemSize.width / 2
        let maxRads: CGFloat = self.maxCoverDegree.degreesToRadians
        let center: CGFloat = self.itemCenter(forItem: item + 1).x
        let nextItemLeftEdge: CGFloat = center - halfWidth
        let projectedRightEdgeLocal: CGFloat = fabs(halfWidth * cos(maxRads) * kDistanceToProjectionPlane / (-halfWidth * sin(maxRads) - kDistanceToProjectionPlane))
        
        return nextItemLeftEdge + self.coverDensity * self.itemSize.width - projectedRightEdgeLocal
    }
    
    fileprivate func indexPathsContained(inRect rect: CGRect) -> [IndexPath] {
        
        guard self.collectionView!.numberOfItems(inSection: 0) > 0 else {
            // nothing to do here when we don't have items
            return []
        }
        // find min and max rows that can be determined for sure
        var minRow: Int = max(Int(rect.origin.x / self.collectionViewWidth), 0)
        var maxRow: Int = Int(rect.maxX / self.collectionViewWidth)
        
        // additional check for rows that also can be included
        // (our rows are moving depending on content size)
        let candidateMinRow: Int = max(minRow - 1, 0)
        
        if self.maxX(forItem: candidateMinRow) >= rect.origin.x {
            // we have a row that is less than given minimum
            minRow = candidateMinRow
        }
        
        let candidateMaxRow: Int = min(maxRow + 1, self.collectionView!.numberOfItems(inSection: 0) - 1)
        if self.minX(forItem: candidateMaxRow) <= rect.maxX {
            maxRow = candidateMaxRow
        }
        
        // add index paths between min and max
        var resultingIdxPaths = [IndexPath]()
        
        for i in minRow...maxRow {
            resultingIdxPaths.append(IndexPath(item: i, section: 0))
        }
        
        return resultingIdxPaths
    }
    
    fileprivate func interpolateAttributes(_ attributes: UICollectionViewLayoutAttributes, forOffset offset: CGFloat) {
        let attributesPath = attributes.indexPath
        // interpolate offset for given attribute
        // for this task we need min max interval and min and max x allowed for item
        let minInterval: CGFloat = CGFloat(attributesPath.item - 1) * self.collectionViewWidth
        let maxInterval: CGFloat = CGFloat(attributesPath.item + 1) * self.collectionViewWidth
        
        let minX: CGFloat = self.minXCenter(forItem: attributesPath.item)
        let maxX: CGFloat = self.maxXCenter(forItem: attributesPath.item)
        let spanX: CGFloat = maxX - minX
        
        // interpolate by formula
        let interpolatedX: CGFloat = min(max(minX + ((spanX / (maxInterval - minInterval)) * (offset - minInterval)), minX), maxX)
        attributes.center = CGPoint(x: interpolatedX, y: attributes.center.y)
        var transform: CATransform3D = CATransform3DIdentity
        // add perspective
        transform.m34 = -1.0 / kDistanceToProjectionPlane
        // rotate
        let angle: CGFloat = -self.maxCoverDegree + CGFloat(interpolatedX - minX) * 2.0 * self.maxCoverDegree / spanX
        transform = CATransform3DRotate(transform, CGFloat(Double(angle) * M_PI / 180), 0, 1, 0)
        
        // then scale: 1 - abs(1 - Q - 2 * x * (1 - Q))
        let scale: CGFloat = 1.0 - abs(1.0 - self.minCoverScale - (interpolatedX - minX) * 2 * (1.0 - self.minCoverScale) / spanX)
        
        transform = CATransform3DScale(transform, scale, scale, scale)
        
        // apply transform
        attributes.transform3D = transform
        
        // Add opacity: 1 - abs(1 - Q - 2 * x * (1 - Q))
        let opacity: CGFloat = 1.0 - abs(1.0 - self.minCoverOpacity - (interpolatedX - minX) * 2 * (1.0 - self.minCoverOpacity) / spanX)
        attributes.alpha = opacity
        
        //        print("IDX: \(attributesPath.row). MinX: \(minX). MaxX: \(maxX). Interpolated: \(interpolatedX). Interpolated angle: \(angle)")
    }
}

extension Int {
    var degreesToRadians: Double { return Double(self) * .pi / 180 }
}
extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}
