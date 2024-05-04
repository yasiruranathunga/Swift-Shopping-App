import SwiftUI
import CoreData

struct HomeView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var lang: String

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Meal.mealName, ascending: true)],
        animation: .default) var meals: FetchedResults<Meal>

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \CartMealItem.id, ascending: true)],
        animation: .default) var cartItems: FetchedResults<CartMealItem>
    
    @State private var showCart = false

    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                ScrollViewReader(content: { proxy in
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVStack {
                            ForEach(meals) { meal in
                                ZStack {
                                    VStack {
                                        Image(meal.image!)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: geometry.size.width * 0.8, height: geometry.size.width * 0.4)
                                            .clipped()
                                            .cornerRadius(16)
                                        Spacer().frame(height: 16)
                                        HStack {
                                            //meal name and price for each item
                                            Text(meal.mealName!).font(.headline)
                                            Text(meal.priceString).font(.body)
                                            Spacer()
                                            Button {
                                                if let index = cartItems.firstIndex(where: {$0.meal!.id == meal.id}) {
                                                    cartItems[index].quantity += 1
                                                } else {
                                                    let item = CartMealItem(context: viewContext)
                                                    item.id = UUID().uuidString
                                                    item.meal = meal
                                                    item.quantity = 1
                                                    try? viewContext.save()
                                                }
                                            } label: {
                                                Text("Add to cart")
                                            }
                                            .buttonStyle(.borderedProminent)
                                        }
                                        .padding([.leading, .trailing], 40)
                                        Spacer().frame(height: 50)
                                    }
                                }
                            }
                        }
                      //cart
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                ZStack {
                                    HStack {
                                        //item count in cart
                                        Image(systemName: "cart.fill")
                                            .foregroundColor(.blue)
                                        if (cartItems.map({$0.quantity}).reduce(0, +) != 0) {
                                            Text("\(cartItems.map({$0.quantity}).reduce(0, +))")
                                                .font(.system(size: 11))
                                                .foregroundColor(.white)
                                                .frame(width: 20, height: 20, alignment: .center)
                                                .background(Color.red)
                                                .clipShape(Capsule())
                                                .minimumScaleFactor(0.3)
                                        }
                                    }
                                    Button("") {
                                        showCart.toggle()
                                    }
                                }
                            }
                            
                            //localization icon
                            ToolbarItem(placement: .navigationBarLeading) {
                                ZStack {
                                    Button {
                                        LocalizationService.shared.toggleLanguage()
                                        lang = LocalizationService.shared.language.rawValue
                                    } label: {
                                        Image(LocalizationService.shared.language.icon)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 30, height: 30)
                                            .clipShape(Circle())
                                    }

                                }
                            }
                    }
                        .sheet(isPresented: $showCart) {
                            CartView()
                                .environment(\.locale, .init(identifier: lang))
                        }
                    }
                })
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper(lang: .init(initialValue: "en"))
    }

    struct PreviewWrapper:View {
        @State(initialValue: "en") var lang: String

        var body: some View{
            HomeView(lang: $lang)
                .environment(\.locale, .init(identifier: lang))
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}
