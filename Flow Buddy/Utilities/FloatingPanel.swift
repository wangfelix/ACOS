import AppKit

// Custom Panel that ALLOWS typing
class FloatingPanel: NSPanel {
    override var canBecomeKey: Bool { true } // Critical for TextField focus
    override var canBecomeMain: Bool { true }
}

