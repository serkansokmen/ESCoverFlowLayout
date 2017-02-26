# ESCoverFlowLayout
Ported to Swift 3 from [YRCoverFLowLayout][yrcfl]

[![CI Status](http://img.shields.io/travis/serkansokmen/ESCoverFlowLayout.svg?style=flat)](https://travis-ci.org/serkansokmen/ESCoverFlowLayout)
[![Version](https://img.shields.io/cocoapods/v/ESCoverFlowLayout.svg?style=flat)](http://cocoapods.org/pods/ESCoverFlowLayout)
[![License](https://img.shields.io/cocoapods/l/ESCoverFlowLayout.svg?style=flat)](http://cocoapods.org/pods/ESCoverFlowLayout)
[![Platform](https://img.shields.io/cocoapods/p/ESCoverFlowLayout.svg?style=flat)](http://cocoapods.org/pods/ESCoverFlowLayout)

## Example

Check Example project for implementation.

## Installation

ESCoverFlowLayout is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "ESCoverFlowLayout"
```

## Customization

Make sure your custom layout extends from `ESCoverFlowLayout`.
**Vertical scrolling is not supported yet.**

```swift
// Max degree of rotation for items. Default to 22.5. This means that item on a left side of screen
// will be rotated 22.5 degrees around y and item on a right side will be rotated -22.5 degrees around y.
public var maxCoverDegree: CGFloat

// This property means how neighbour items are placed to in relation to currently displayed item.
// Default to 1/8. This means that item on left will cover 1/8 of current displayed item
// and item from right will also cover 1/8 of current item. Value should be in 0..1 range.
// Negative values seperate cells from each other.
public var coverDensity: CGFloat

// Min opacity that can be applied to individual item. Default to 0.4 (alpha 40%).
public var minCoverOpacity: CGFloat

// Min scale that can be applied to individual item. Default to 1.0 (no scale).
public var minCoverScale: CGFloat

// Cell snapping behavior can be toggled, default is enabled.
public var isSnapEnabled: Bool
```

## Author

serkansokmen, e.serkan.sokmen@gmail.com

## License

ESCoverFlowLayout is available under the MIT license. See the LICENSE file for more info.



[yrcfl]: <https://github.com/solomidSF/YRCoverFlowLayout/>
