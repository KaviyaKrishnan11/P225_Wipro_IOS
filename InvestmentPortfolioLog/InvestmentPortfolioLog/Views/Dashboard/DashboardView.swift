
import SwiftUI

struct DashboardView: View {

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {

                Text("Coding Practice Tracker")
                    .font(.largeTitle)
                    .bold()

                Text("Track your coding journey!")
                    .foregroundColor(.secondary)

                Text("Total Problems: 0")
                Text("Problems Solved: 0")
                Text("Revisit Later: 0")

                NavigationLink("View Problems") {
                    Text("Problem List Coming Soon")
                }

                NavigationLink("Add Problem") {
                    Text("Add Problem Coming Soon")
                }
            }
            .padding()
            .navigationTitle("Dashboard")
        }
    }
}

#Preview {
    DashboardView()
}

