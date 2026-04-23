import SwiftUI

/// Apple-Wallet-style card stack.
///
/// Frame budget (identical to the original 624 pt so HomeView layout is unaffected):
///   peekAbove(24) + expandedHeight(480) + peekBelow(2) × collapsedHeight(60) = 624 pt
///
/// Zones inside the clip frame:
///   y = 0 … 24          — bottom sliver of the previous card (peek-above)
///   y = 24 … 504         — active card, full height
///   y = 504 … 564        — first collapsed strip below
///   y = 564 … 624        — second collapsed strip below
///
/// Shadow is applied AFTER .clipped() so it cannot bleed onto adjacent cards.
/// BrandCardView's own shadow is disabled (showShadow: false).
struct CardStackView: View {
    let cards: [Card]
    @Binding var activeIndex: Int
    var onSelect: (Int) -> Void
    var onPresent: (Int) -> Void
    var onReorder: (Int, Int) -> Void = { _, _ in }
    var width: CGFloat = 320

    @GestureState private var dragOffset: CGFloat = 0
    @GestureState private var reorderDragY: CGFloat = 0
    @State private var reorderingIdx: Int?

    private let expandedHeight:  CGFloat = 420
    private let collapsedHeight: CGFloat = 54   // tighter strip; 22pt padding + 34pt icon row fits
    private let peekAbove:       CGFloat = 22   // bottom sliver of the card above the active one
    private let peekBelow:       Int     = 2    // collapsed accordion strips below active
    private let reorderStep:     CGFloat = 50   // drag distance per reorder step

    /// 24 + 480 + 2×60 = 624 pt — same footprint as the previous design.
    private var frameHeight: CGFloat {
        peekAbove + expandedHeight + CGFloat(peekBelow) * collapsedHeight
    }

    var body: some View {
        ZStack(alignment: .top) {
            ForEach(Array(cards.enumerated()), id: \.element.id) { idx, card in
                cardLayer(idx: idx, card: card)
            }
        }
        .frame(width: width, height: frameHeight, alignment: .top)
        .clipped()
        .gesture(
            DragGesture(minimumDistance: 20)
                .updating($dragOffset) { value, state, _ in
                    state = value.translation.height
                }
                .onEnded { value in
                    let t = value.translation.height
                    if t < -40 { step(1) }
                    else if t > 40 { step(-1) }
                }
        )
    }

    // MARK: - Card layer

    @ViewBuilder
    private func cardLayer(idx: Int, card: Card) -> some View {
        let isActive = idx == activeIndex
        let isReordering = reorderingIdx == idx
        // Cards below the active one collapse to a header strip.
        // Cards above (including the peek card) stay full height — the clip frame
        // hides everything above y = 0.
        let slotHeight: CGFloat = idx > activeIndex ? collapsedHeight : expandedHeight

        BrandCardView(
            card: card,
            width: width,
            height: expandedHeight,
            qrSize: 210,
            showShadow: false
        )
        .frame(height: slotHeight, alignment: .top)
        .clipped()
        // Shadow only on the active card (or whichever card is being reordered),
        // applied after clip so it cannot bleed.
        .shadow(
            color: (isActive || isReordering) ? .black.opacity(isReordering ? 0.55 : 0.45) : .clear,
            radius: isReordering ? 28 : (isActive ? 22 : 0),
            y: isReordering ? 22 : (isActive ? 18 : 0)
        )
        .scaleEffect(isReordering ? 1.03 : 1.0)
        .offset(y: cardY(for: idx) + (isReordering ? reorderDragY : 0))
        .zIndex(isReordering ? 999 : cardZIndex(for: idx))
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: reorderingIdx)
        .onTapGesture {
            if isActive {
                onPresent(idx)
            } else if idx > activeIndex {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.82)) {
                    onSelect(idx)
                }
            }
        }
        .gesture(reorderGesture(for: idx))
    }

    // MARK: - Reorder gesture

    private func reorderGesture(for idx: Int) -> some Gesture {
        LongPressGesture(minimumDuration: 0.4)
            .sequenced(before: DragGesture(minimumDistance: 0))
            .updating($reorderDragY) { value, state, _ in
                if case .second(true, let drag?) = value {
                    state = drag.translation.height
                }
            }
            .onChanged { value in
                if case .second(true, _) = value, reorderingIdx != idx {
                    reorderingIdx = idx
                    #if canImport(UIKit)
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    #endif
                }
            }
            .onEnded { value in
                guard case .second(true, let drag?) = value else {
                    reorderingIdx = nil
                    return
                }
                let steps = Int((drag.translation.height / reorderStep).rounded())
                let to = max(0, min(cards.count - 1, idx + steps))
                reorderingIdx = nil
                if to != idx {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.82)) {
                        onReorder(idx, to)
                    }
                }
            }
    }

    // MARK: - Geometry

    private func cardY(for idx: Int) -> CGFloat {
        let drag = limitedDrag
        if idx == activeIndex {
            return peekAbove + drag
        } else if idx < activeIndex {
            let stepsAbove = activeIndex - idx
            if stepsAbove == 1 {
                // Position so the card's bottom edge sits exactly at y = peekAbove.
                // That exposes the bottom `peekAbove` pt of the full-height card:
                //   card top  = peekAbove − expandedHeight  (above clip, hidden)
                //   card bottom = peekAbove                 (visible sliver)
                return peekAbove - expandedHeight + drag
            } else {
                // Cards two or more steps above: push completely off screen.
                return -(CGFloat(stepsAbove - 1) * collapsedHeight + expandedHeight) + drag
            }
        } else {
            // Accordion below: stepsBelow == 1 places the strip immediately under active.
            let stepsBelow = idx - activeIndex
            return peekAbove + expandedHeight + CGFloat(stepsBelow - 1) * collapsedHeight + drag
        }
    }

    private func cardZIndex(for idx: Int) -> Double {
        if idx == activeIndex { return Double(cards.count + 1) }
        if idx > activeIndex  { return Double(cards.count + 1 - (idx - activeIndex)) }
        return Double(idx) // above cards: low z, mostly hidden
    }

    private var limitedDrag: CGFloat {
        if dragOffset > 0 && activeIndex == 0               { return 0 }
        if dragOffset < 0 && activeIndex == cards.count - 1 { return 0 }
        return dragOffset
    }

    private func step(_ direction: Int) {
        let next = activeIndex + direction
        guard cards.indices.contains(next) else { return }
        withAnimation(.spring(response: 0.4, dampingFraction: 0.82)) {
            activeIndex = next
        }
    }
}
