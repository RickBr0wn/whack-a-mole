import SwiftUI

struct ContentView: View {
    @State private var loadingViewModel = LoadingViewModel()
    @State private var isLoadingComplete = false

    var body: some View {
        if isLoadingComplete {
            GameView()
        } else {
            LoadingView(viewModel: loadingViewModel)
                .task {
                    await loadingViewModel.start()
                    isLoadingComplete = true
                }
        }
    }
}

#Preview {
    ContentView()
}
