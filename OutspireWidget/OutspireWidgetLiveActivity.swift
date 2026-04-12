import ActivityKit
import SwiftUI
import WidgetKit

// MARK: - Helpers

private func stateColor(_ state: ClassActivityAttributes.ContentState) -> Color {
    switch state.status {
    case .ongoing: SubjectColors.color(for: state.className)
    case .ending: .orange
    case .upcoming: .green
    case .break: SubjectColors.color(for: state.nextClassName ?? state.className)
    case .event: .purple
    }
}

private func countdownColor(_ state: ClassActivityAttributes.ContentState) -> Color {
    switch state.status {
    case .ongoing: .white
    case .ending: .orange
    default: .white.opacity(0.4)
    }
}

private func label(_ status: ClassActivityAttributes.ContentState.Status) -> String {
    switch status {
    case .ongoing, .ending: "ENDS IN"
    case .upcoming, .break: "STARTS IN"
    case .event: "TODAY"
    }
}

private func subtitle(_ state: ClassActivityAttributes.ContentState) -> String {
    if case .break = state.status { return state.nextClassName.map { "Next: \($0)" } ?? "" }
    return state.roomNumber
}

// MARK: - Lock Screen Banner

private struct LockScreenView: View {
    let state: ClassActivityAttributes.ContentState

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 3) {
                Text(state.className)
                    .font(.system(size: 17, weight: .bold, design: .rounded))
                    .foregroundStyle(stateColor(state))
                    .lineLimit(1)

                let sub = subtitle(state)
                if !sub.isEmpty {
                    Text(sub)
                        .font(.system(size: 11, weight: .semibold, design: .rounded))
                        .foregroundStyle(.white.opacity(0.4))
                }
            }

            Spacer(minLength: 16)

            VStack(alignment: .trailing, spacing: 2) {
                Text(label(state.status))
                    .font(.system(size: 11, weight: .semibold, design: .rounded))
                    .foregroundStyle(.white.opacity(0.4))

                Text(timerInterval: state.periodStart...state.periodEnd, countsDown: true)
                    .font(.system(size: 32, weight: .semibold, design: .rounded).monospacedDigit())
                    .foregroundStyle(countdownColor(state))
            }
        }
        .padding()
    }
}

// MARK: - Widget

struct OutspireWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: ClassActivityAttributes.self) { context in
            // Lock Screen banner
            LockScreenView(state: context.state)
                .activityBackgroundTint(Color(white: 0.11))
                .activitySystemActionForegroundColor(.white)

        } dynamicIsland: { context in
            DynamicIsland {
                // --- Expanded ---
                DynamicIslandExpandedRegion(.leading) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(context.state.className)
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                            .lineLimit(1)

                        let sub = subtitle(context.state)
                        if !sub.isEmpty {
                            Text(sub)
                                .font(.system(size: 10, weight: .semibold, design: .rounded))
                                .foregroundStyle(.white.opacity(0.4))
                        }
                    }
                }

                DynamicIslandExpandedRegion(.trailing) {
                    VStack(alignment: .trailing, spacing: 1) {
                        Text(label(context.state.status))
                            .font(.system(size: 9, weight: .semibold, design: .rounded))
                            .foregroundStyle(.white.opacity(0.4))

                        Text(timerInterval: context.state.periodStart...context.state.periodEnd, countsDown: true)
                            .font(.system(size: 20, weight: .semibold, design: .rounded).monospacedDigit())
                            .foregroundStyle(stateColor(context.state))
                    }
                }

                DynamicIslandExpandedRegion(.bottom) {
                    EmptyView()
                }

            } compactLeading: {
                // --- Compact leading: colored dot ---
                Circle()
                    .fill(stateColor(context.state))
                    .frame(width: 8, height: 8)

            } compactTrailing: {
                // --- Compact trailing: countdown only ---
                Text(timerInterval: context.state.periodStart...context.state.periodEnd, countsDown: true)
                    .font(.system(size: 13, weight: .semibold, design: .rounded).monospacedDigit())
                    .foregroundStyle(stateColor(context.state))

            } minimal: {
                Circle()
                    .fill(stateColor(context.state))
                    .frame(width: 8, height: 8)
            }
            .widgetURL(URL(string: "outspire://today"))
        }
    }
}
