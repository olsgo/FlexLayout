# macOS Support for FlexLayout

This document describes the changes made to add macOS support to FlexLayout.

## Overview

FlexLayout now supports macOS (10.15+) in addition to iOS and tvOS. The implementation maintains full source compatibility with existing iOS code while providing a parallel API for NSView-based applications on macOS.

## Architecture

### Platform Abstraction

A `FlexHostView` typealias provides a unified interface:
- iOS/tvOS: `FlexHostView = UIView`
- macOS: `FlexHostView = NSView`

### Key Changes

#### 1. Swift Sources

**Files Modified:**
- `Sources/Swift/FlexLayout.swift` - Core Flex class with platform conditionals
- `Sources/Swift/Impl/UIView+FlexLayout.swift` - Added NSView extension for macOS
- `Sources/Swift/Impl/FlexHostView.swift` - New platform abstraction layer
- `Sources/Swift/Impl/FlexLayout+Enum.swift` - Platform-conditional imports
- `Sources/Swift/Impl/FlexLayout+Private.swift` - Platform-conditional imports
- `Sources/Swift/Percent.swift` - Platform-conditional imports

**Changes:**
- All `import UIKit` statements now conditional: `#if os(iOS) || os(tvOS) ... #elseif os(macOS)`
- `UIView` references changed to `FlexHostView` where appropriate
- Added parallel `NSView` extension with identical API

#### 2. YogaKit (Objective-C++ Bridge)

**Files Modified:**
- `Sources/YogaKit/include/YogaKit/YGLayout.h` - Platform-conditional UIKit/AppKit imports
- `Sources/YogaKit/include/YogaKit/UIView+Yoga.h` - Added NSView category for macOS
- `Sources/YogaKit/include/YogaKit/YGLayout+Private.h` - Platform-specific initWithView signatures
- `Sources/YogaKit/UIView+Yoga.mm` - Platform-conditional implementation
- `Sources/YogaKit/YGLayout.mm` - Extensive macOS support
- `Sources/Swift/Public/FlexLayout.h` - Platform-conditional framework header

**YGLayout.mm Changes:**
- Platform-specific type macros: `YGView`, `YGScreen`, `YGLabel`, etc.
- Screen scale handling: `UIScreen.scale` vs `NSScreen.backingScaleFactor`
- Text control baseline functions (iOS-only, as NSTextField/NSTextView differ)
- All view hierarchy functions updated to use `YGView`

#### 3. Package Configuration

**Package.swift:**
```swift
platforms: [
  .iOS(.v13),
  .macOS(.v10_15),  // NEW
]
```

## API Usage

### iOS (Unchanged)
```swift
import UIKit
import FlexLayout

class MyViewController: UIViewController {
    let containerView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()

        containerView.flex.direction(.column).define { flex in
            flex.addItem(UILabel())
                .height(50)
                .marginBottom(10)
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        containerView.flex.layout(mode: .fitContainer)
    }
}
```

### macOS (New)
```swift
import AppKit
import FlexLayout

class MyView: NSView {
    let containerView = NSView()

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)

        containerView.flex.direction(.column).define { flex in
            flex.addItem(NSTextField(labelWithString: "Hello"))
                .height(50)
                .marginBottom(10)
        }
    }

    override func layout() {
        super.layout()
        containerView.flex.layout(mode: .fitContainer)
    }
}
```

## Implementation Details

### Platform Detection

The implementation uses standard platform macros:

**Swift:**
- `#if os(iOS) || os(tvOS)` - For iOS/tvOS
- `#elseif os(macOS)` - For macOS

**Objective-C:**
- `#if TARGET_OS_IPHONE || TARGET_OS_TV` - For iOS/tvOS
- `#elif TARGET_OS_OSX` - For macOS

### Differences Between Platforms

#### Screen Scale
- iOS: `UIScreen.mainScreen().scale`
- macOS: `NSScreen.mainScreen().backingScaleFactor`

#### Text Controls
- iOS: Baseline functions set for `UILabel`, `UITextField`, `UITextView`
- macOS: No baseline functions (different layout model)

#### View Hierarchy
- Both platforms use `subviews`, `addSubview()`, `frame`, `bounds`
- These APIs are compatible between UIView and NSView

### Known Limitations

1. **Baseline Alignment**: Text baseline alignment may behave differently on macOS due to NSTextField/NSTextView architecture differences.

2. **Safe Area**: iOS `safeAreaInsets` has no direct macOS equivalent. Code relying on this should add platform-specific handling.

3. **Auto Layout**: FlexLayout replaces manual frame-setting. Apps using Auto Layout alongside FlexLayout need careful integration on both platforms.

## Testing

A sample macOS application is provided in `Examples/macOS/FlexLayoutMacOSExample.swift` demonstrating:
- NSView hierarchy with FlexLayout
- Column and row layouts
- Margins, padding, alignment
- Dynamic layout on window resize

### Building for macOS

```bash
# Build the package
swift build

# Run tests (if available)
swift test

# Build for specific platform
swift build --arch arm64
```

## Migration Guide

Existing iOS code requires no changes. To add macOS support to your app:

1. **Import AppKit instead of UIKit** on macOS:
   ```swift
   #if os(iOS) || os(tvOS)
   import UIKit
   #elseif os(macOS)
   import AppKit
   #endif
   ```

2. **Use platform-specific view types**:
   ```swift
   #if os(iOS) || os(tvOS)
   let label = UILabel()
   #elseif os(macOS)
   let label = NSTextField(labelWithString: "")
   #endif
   ```

3. **Layout in appropriate method**:
   - iOS: `viewDidLayoutSubviews()`
   - macOS: `layout()`

4. **FlexLayout API is identical** across platforms for all layout properties.

## Compatibility

- **iOS**: 13.0+
- **macOS**: 10.15+
- **tvOS**: Existing support maintained
- **Swift**: 5.5+
- **Yoga**: 3.2.1+

## Contributing

When adding features:
- Test on both iOS and macOS
- Use platform conditionals for platform-specific code
- Maintain API consistency across platforms
- Update this document with any platform-specific behavior

## Credits

Original FlexLayout by Luc Dion and contributors.
macOS support added by extending the UIView-based implementation to NSView.
