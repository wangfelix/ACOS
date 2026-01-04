import SwiftUI

// MARK: - Glass Effect Fallback Modifiers
// Provides macOS 26+ glassEffect with .ultraThinMaterial fallback for older versions

struct GlassEffectFallback<S: Shape>: ViewModifier {
    let shape: S
    
    func body(content: Content) -> some View {
        if #available(macOS 26.0, *) {
            content.glassEffect(in: shape)
        } else {
            content
                .background(shape.fill(.ultraThinMaterial))
                .clipShape(shape)
        }
    }
}

struct CircleGlassEffectFallback: ViewModifier {
    func body(content: Content) -> some View {
        if #available(macOS 26.0, *) {
            content.glassEffect()
        } else {
            content
                .background(Circle().fill(.ultraThinMaterial))
                .clipShape(Circle())
        }
    }
}

extension View {
    func glassEffectWithFallback<S: Shape>(in shape: S) -> some View {
        modifier(GlassEffectFallback(shape: shape))
    }
    
    func circleGlassEffectWithFallback() -> some View {
        modifier(CircleGlassEffectFallback())
    }
}
