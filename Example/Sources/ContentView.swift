import ImageLoader
import SwiftUI

struct ContentView: View {
    @State private var viewModel = ContentViewModel()

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach($viewModel.imageData, id: \.id) { $data in
                    CachedAsyncImage(
                        id: data.id,
                        url: data.url,
                        imageLoader: data.imageLoader
                    )
                    .frame(width: 100)
                }
            }
            .padding(16)
        }
    }
}

struct CachedAsyncImage: View {
    private let id: UUID
    private var url: URL
    private var contentMode: ContentMode

    @Bindable private var imageLoader: CachedImageLoader

    init(
        id: UUID,
        url: URL,
        imageLoader: CachedImageLoader,
        contentMode: ContentMode = .fit
    ) {
        print("\(id.uuidString): \(#function)")
        self.id = id
        self.url = url
        self.contentMode = contentMode
        self._imageLoader = Bindable(imageLoader)
    }

    var body: some View {
        Group {
            switch imageLoader.phase {
            case .idle:
                let _ = print("\(id.uuidString): .idle")
                Color.cyan
                    .onAppear {
                        imageLoader.load(from: url)
                    }

            case .loading:
                let _ = print("\(id.uuidString): .loading")
                Color.red

            case let .success(image):
                let _ = print("\(id.uuidString): .success")
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(nil, contentMode: contentMode)

            case .failure:
                let _ = print("\(id.uuidString): .failure")
                Color.gray
            }
        }
        .id(id)
    }
}

extension CachedAsyncImage: Equatable {
    static func == (lhs: CachedAsyncImage, rhs: CachedAsyncImage) -> Bool {
        lhs.url == rhs.url
    }
}
