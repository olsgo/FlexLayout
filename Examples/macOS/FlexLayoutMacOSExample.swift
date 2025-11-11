//
//  FlexLayoutMacOSExample.swift
//  FlexLayout
//
//  Created for macOS support validation
//  Copyright © 2025 FlexLayout. All rights reserved.
//

#if os(macOS)
import AppKit
import FlexLayout

/// Example demonstrating FlexLayout usage on macOS with NSView
class FlexLayoutExampleView: NSView {

    private let containerView = NSView()
    private let headerLabel = NSTextField(labelWithString: "FlexLayout on macOS")
    private let contentView = NSView()
    private let button1 = NSButton(title: "Button 1", target: nil, action: nil)
    private let button2 = NSButton(title: "Button 2", target: nil, action: nil)
    private let footerLabel = NSTextField(labelWithString: "Footer")

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setupViews()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        setupLayout()
    }

    private func setupViews() {
        // Configure container
        containerView.wantsLayer = true
        containerView.layer?.backgroundColor = NSColor.windowBackgroundColor.cgColor

        // Configure header
        headerLabel.font = NSFont.systemFont(ofSize: 24, weight: .bold)
        headerLabel.alignment = .center

        // Configure content view
        contentView.wantsLayer = true
        contentView.layer?.backgroundColor = NSColor.controlBackgroundColor.cgColor

        // Configure buttons
        button1.bezelStyle = .rounded
        button2.bezelStyle = .rounded

        // Configure footer
        footerLabel.alignment = .center
        footerLabel.textColor = .secondaryLabelColor
    }

    private func setupLayout() {
        // Use FlexLayout to arrange subviews
        addSubview(containerView)

        containerView.flex.define { flex in
            flex.direction(.column)
            flex.padding(20)
            flex.justifyContent(.spaceBetween)

            // Header
            flex.addItem(headerLabel)
                .height(40)
                .marginBottom(20)

            // Content area with buttons
            flex.addItem(contentView).define { contentFlex in
                contentFlex.direction(.row)
                    .justifyContent(.spaceAround)
                    .alignItems(.center)
                    .padding(20)
                    .grow(1)

                contentFlex.addItem(button1)
                    .width(120)
                    .height(30)

                contentFlex.addItem(button2)
                    .width(120)
                    .height(30)
            }

            // Footer
            flex.addItem(footerLabel)
                .height(20)
                .marginTop(20)
        }
    }

    override func layout() {
        super.layout()

        // Apply FlexLayout
        containerView.frame = bounds
        containerView.flex.layout(mode: .fitContainer)
    }
}

/// Simple window controller for testing
class FlexLayoutExampleWindowController: NSWindowController {

    convenience init() {
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 600, height: 400),
            styleMask: [.titled, .closable, .miniaturizable, .resizable],
            backing: .buffered,
            defer: false
        )
        window.title = "FlexLayout macOS Example"
        window.center()

        let exampleView = FlexLayoutExampleView(frame: window.contentView!.bounds)
        exampleView.autoresizingMask = [.width, .height]
        window.contentView = exampleView

        self.init(window: window)
    }
}

#endif
