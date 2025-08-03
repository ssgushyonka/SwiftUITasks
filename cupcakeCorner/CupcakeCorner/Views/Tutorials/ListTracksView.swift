import SwiftUI

struct ListTracksView : View {
    @State private var results = [Result]()
    
    func loadData() async {
        // 1. Create the URL we want to read
        guard let url = URL(
            string: "https://itunes.apple.com/search?term=daft+punk&entity=song"
        ) else {
            print("Invalid URL")
            return
        }
        
        // 2. Fetch the data for the URL
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            //data and metadata of how request went.
            // note the `await` keyword there
            
            if let decodedResponse = try? JSONDecoder().decode(
                Response.self,
                from: data
            ) {
                results = decodedResponse.results
            }
        } catch {
            print("Invalid data")
        }
        
        // 3. Decode the result of that data into a `Response` struct
        
    }
    
    var body : some View {            
        List(results, id: \.trackId) { item in
            VStack(alignment: .leading) {
                Text(item.trackName)
                    .font(.headline)
                Text(item.collectionName)
            }
        }.task {
            await loadData()
        }
    }
}

#Preview {
    ListTracksView()
}

