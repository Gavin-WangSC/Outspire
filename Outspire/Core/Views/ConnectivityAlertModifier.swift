import SwiftUI

struct ConnectivityAlertsViewModifier: ViewModifier {
    @ObservedObject var connectivityManager = ConnectivityManager.shared

    func body(content: Content) -> some View {
        content
            .alert("No Internet Connection", isPresented: $connectivityManager.showNoInternetAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Please check your internet connection and try again.")
            }
    }
}

extension View {
    func withConnectivityAlerts() -> some View {
        modifier(ConnectivityAlertsViewModifier())
    }
}
