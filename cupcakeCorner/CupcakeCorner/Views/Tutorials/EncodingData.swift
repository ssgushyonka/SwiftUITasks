import SwiftUI

struct EncodingData1 : View {
    var body : some View {
        Button("Encode person", action: encodePerson)
    }
    
    func encodePerson() {
        let data = try! JSONEncoder().encode(User())
        let str = String(
            decoding: data,
            as: UTF8.self
        )
        print(str)
    }
}

#Preview {
    EncodingData1()
}

