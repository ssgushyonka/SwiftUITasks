import SwiftUI

struct CheckoutView : View {
    var order: Order
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    func placeOrder() async {
        // 1. Convert our `order` into JSON
        guard let encoded = try? JSONEncoder().encode(order) else {
            print("Failed to encode order")
            return
        }
        // 2. Tell Swift how to send that data over a net call
        let url = URL(string: "https://reqres.in/api/cupcakes")
        guard let urlUnwrapped = url else {
            print("URL invalid")
            return
        }
        var request = URLRequest(url : urlUnwrapped)
        //Must force URL, otherwise type is `URL?`
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //request.httpMethod = "POST"
        
        // 3. Run that request and process the response.
        do {
            let (data, _) = try await URLSession.shared.upload(
                for: request,
                from: encoded
            )
            let decodedOrder = try JSONDecoder().decode(
                Order.self,
                from: data
            )
            alertTitle = "Thank you!"
            alertMessage = "Your order for \(decodedOrder.quantity)x \(Order.types[decodedOrder.type].lowercased()) cupcakes is on its way!"
            
        } catch {
            print("Checkout failed : \(error.localizedDescription)")
            alertTitle = "Checkout Failed."
            alertMessage = "Order processing failed due to an unexpected error."
        }
        showingAlert = true
    }
    
    var body : some View {
        ScrollView {
            VStack {
                
                AsyncImage(
                    url: URL(string: "https://hws.dev/img/cupcakes@3x.jpg"),
                    scale: 3
                ) { image in
                    image
                        .resizable()
                        .scaledToFit()
                    
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 233)
                
                Text("Your total is \(order.cost, format: .currency(code: "USD"))")
                    .font(.title)
                
                Button("Place order") {
                    Task {
                        await placeOrder()
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Check Out")
        .navigationBarTitleDisplayMode(.inline)
        .scrollBounceBehavior(.basedOnSize)
        .alert(alertTitle, isPresented: $showingAlert) {
            Button("OK") { }
        } message : {
            Text(alertMessage)
        }
    }.onAppear {
        order.saveUserInfoLocally()
    }
}

#Preview {
    NavigationStack {
        CheckoutView(order: Order())
    }
}
