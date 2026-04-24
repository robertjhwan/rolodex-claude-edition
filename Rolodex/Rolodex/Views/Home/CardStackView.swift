import SwiftUI

/// Apple-Wallet-style card stack.
///
/// Every card is rendered at its full expanded height. Below-active cards are
/// offset so only the top ~collapsedHeight pt peeks out; the *next* card's
/// rounded top sits in front and covers everything beneath. This matches the
/// way Apple Wallet stacks passes — no per-card bottom clip, so strips never
/// look "cut off" or pill-shaped.
///
/// Frame budget (unchanged so HomeView layout is unaffected):
///   peekAbove + expandedHeight + peekBelow × collapsedHeight
///
/// Z-order: active card is on top; below-active strips are layered so deeper
/// strips sit *above* shallower ones, letting each next card cover the tail
/// of the card it's peeking out from. Strip 1 is flush with the active card's
/// bottom — active's rounded-bottom corners remain visible (Wallet-style).
///
/// BrandCardView's own shadow is disabled (showShadow: false) — distinction
/// comes from each card's color and the stacking itself, Wallet-style.
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

    private let expandedHeight:  CGFloat = 410  // active card
    private let collapsedHeight: CGFloat = 50   // tighter strip; 22pt padding + 34pt icon row fits
    private let peekAbove:       CGFloat = 22   // bottom sliver of the card above the active one
    private let peekBelow:       Int     = 3    // collapsed accordion strips below active
    private let activeGap:       CGFloat = 10   // breathing room between active card and strip 1
    private let reorderStep:     CGFloat = 50   // drag distance per reorder step

    /// peekAbove + expandedHeight + activeGap + peekBelow × collapsedHeight.
    /// 22 + 410 + 10 + 3×50 = 592 pt.
    private var frameHeight: CGFloat {
        peekAbove + expandedHeight + activeGap + CGFloat(peekBelow) * collapsedHeight
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

        // Every card is laid out at full expanded height. For below-active
        // cards, only the top `collapsedHeight` peeks out — the next card's
        // rounded top sits in front and covers the rest. No per-card clip:
        // BrandCardView already rounds its corners internally, so the bottom
        // of each strip is simply covered by the strip below it (Wallet-style).
        BrandCardView(
            card: card,
            width: width,
            height: expandedHeight,
            qrSize: 210,
            showShadow: false
        )
        // Lift shadow while reordering only — no resting shadow, so strips below stay crisp.
        .shadow(
            color: isReordering ? .black.opacity(0.55) : .clear,
            radius: isReordering ? 28 : 0,
            y: isReordering ? 22 : 0
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
            // Accordion below, Wallet-style. Each card is rendered at full
            // height; only the top `collapsedHeight` pt peeks because the
            // *next* card sits in front and covers everything below. An
            // `activeGap` separates the active card from strip 1, giving the
            // featured card breathing room above the stack below.
            let stepsBelow = idx - activeIndex
            return peekAbove + expandedHeight + activeGap
                + CGFloat(stepsBelow - 1) * collapsedHeight + drag
        }
    }

    private func cardZIndex(for idx: Int) -> Double {
        // Active sits on top. Below-active: deeper strips get *higher* z so
        // each next card covers the one peeking out above it (Wallet-style).
        // Above-active: always at the back — they're hidden above y = 0 anyway.
        if idx == activeIndex { return Double(cards.count + 1) }
        if idx > activeIndex  { return Double(idx - activeIndex) }
        return -Double(cards.count - idx)
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
