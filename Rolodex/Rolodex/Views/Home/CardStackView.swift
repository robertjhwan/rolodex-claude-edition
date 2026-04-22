import SwiftUI

/// Apple Wallet accordion: cards stack vertically in natural order.
/// The active card is fully expanded; all others collapse to a header strip.
/// Tapping any collapsed card expands it in place (like Apple Wallet).
struct CardStackView: View {
    let cards: [Card]
    @Binding var activeIndex: Int
    var onSelect: (Int) -> Void
    var onPresent: (Int) -> Void
    var width: CGFloat = 320

    @GestureState private var dragOffset: CGFloat = 0

    private let expandedHeight: CGFloat = 480
    private let collapsedHeight: CGFloat = 72

    // Visible window: active card + 2 peeking cards below
    private var frameHeight: CGFloat { expandedHeight + 2 * collapsedHeight }

    // Slide the VStack so the active card sits at the top of the window
    private var stackOffset: CGFloat { -CGFloat(activeIndex) * collapsedHeight }

    var body: some View {
        VStack(spacing: 0) {
            ForEach(Array(cards.enumerated()), id: \.element.id) { idx, card in
                let isActive = idx == activeIndex
                BrandCardView(card: card, width: width, height: expandedHeight, qrSize: 210)
                    // Collapse non-active cards to just their header strip.
                    // withAnimation animates this height change → accordion expand/collapse.
                    .frame(height: isActive ? expandedHeight : collapsedHeight, alignment: .top)
                    .clipped()
                    .zIndex(isActive ? 1 : 0)
                    .onTapGesture {
                        if isActive {
                            onPresent(idx)
                        } else {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.82)) {
                                onSelect(idx)
                            }
                        }
                    }
            }
        }
        // Shift the stack so the active card is at the top of the frame.
        // withAnimation on activeIndex change animates both this offset AND
        // the height changes above simultaneously.
        .offset(y: stackOffset + limitedDrag)
        .frame(width: width, height: frameHeight, alignment: .top)
        .clipped()
        .gesture(
            DragGesture(minimumDistance: 20)
                .updating($dragOffset) { value, state, _ in
                    state = value.translation.height
                }
                .onEnded { value in
                    let threshold: CGFloat = 40
                    if value.translation.height < -threshold { step(1) }
                    else if value.translation.height > threshold { step(-1) }
                }
        )
    }

    private var limitedDrag: CGFloat {
        if dragOffset > 0 && activeIndex == 0 { return 0 }
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
