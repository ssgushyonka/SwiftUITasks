import SwiftUI

struct AsyncImageShowcaseView : View {
    var body : some View {
        AsyncImage(
            url: URL(string: "https://hws.dev/img/logo.png"),
            scale: 3
        )
        
    }
}

struct AsyncImgView2 : View {
    var body : some View {
        AsyncImage(
            url: URL(string: "https://hws.dev/img/logo.png")
        ) { image in
            image.resizable()
                .scaledToFit()
        } placeholder: {
            //Color.red
            ProgressView()
            // You can also leave this blank
        }
        .frame(width: 200, height: 200)
    }
}

struct AsyncImgView3 : View {
    var body : some View {
        AsyncImage(
            url: URL(string: "https://hws.dev/img/logo.png")
        ) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .scaledToFit()
            } else if phase.error != nil {
                Text("There was an error loading the image.")
            } else {
                ProgressView()
            }
        }
        .frame(width: 200, height: 200)
    }
}

#Preview {
    AsyncImgView3()
}
