import ImageLoader
import SwiftUI

struct ContentView: View {
    @State private var viewModel = ContentViewModel()

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.imageData, id: \.id) { data in
                    CachedAsyncImage(
                        url: data.url,
                        loadingService: data.loadingService,
                    )
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(16)
        }
        .task {
            await viewModel.setup()
        }
    }
}

struct CachedAsyncImage: View {
    private let url: URL
    private let contentMode: ContentMode

    @State private var imageLoader: CachedImageLoader

    init(
        url: URL,
        loadingService: any ImageLoadingServiceProtocol,
        contentMode: ContentMode = .fit
    ) {
        self.url = url
        self.contentMode = contentMode
        self.imageLoader = CachedImageLoader(loadingService: loadingService)
    }

    var body: some View {
        switch imageLoader.phase {
        case .idle:
            Color.cyan
                .onAppear {
                    imageLoader.load(from: url)
                }

        case .loading:
            Color.red

        case .success(let image):
            Image(uiImage: image)
                .resizable()
                .aspectRatio(nil, contentMode: contentMode)

        case .failure:
            Color.gray
        }
    }
}

extension CachedAsyncImage: Equatable {
    static func == (lhs: CachedAsyncImage, rhs: CachedAsyncImage) -> Bool {
        lhs.url == rhs.url
    }
}
