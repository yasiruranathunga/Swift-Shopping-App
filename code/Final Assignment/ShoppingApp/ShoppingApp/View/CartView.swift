import SwiftUI

struct CartView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \CartMealItem.id, ascending: true)],
        animation: .default) var cartItems: FetchedResults<CartMealItem>

    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                VStack {
                    List {
                        ForEach(cartItems, id: \.self) { item in
                            //item image and meal name
                            HStack {
                                Image(item.meal!.image!)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 50, height: 50)
                                    .clipped()
                                    .cornerRadius(16)
                                Spacer().frame(width: 16)
                                Text(item.meal!.mealName!)
                                    .font(.headline)
                                    .frame(width: 70)
                                    .font(.system(size: 12))
                                    .multilineTextAlignment(.center)
                                Spacer().frame(width: 20)
                                HStack {
                                    Button {
                                        if item.quantity != 0 {
                                            item.quantity -= 1
                                            try? viewContext.save()
                                        }
                                    } label: {
                                        Image(systemName: "minus.circle.fill")
                                    }.buttonStyle(BorderlessButtonStyle())
                                    Text("\(item.quantity)")
                                        .frame(width: 25)
                                        .font(.system(size: 11))
                                    Button {
                                        item.quantity += 1
                                        try? viewContext.save()
                                    } label: {
                                        Image(systemName: "plus.circle.fill")
                                    }.buttonStyle(BorderlessButtonStyle())
                                }
                                //each item price
                                Spacer()
                                //use Model and Double+Extension swift
                                Text(item.total.currency)
                                    .font(.system(size: 13))
                                    .minimumScaleFactor(0.3)
                            }
                            .swipeActions(allowsFullSwipe: false) {
                                Button(role: .destructive) {
                                    delete(cartItem: item)
                                } label: {
                                    Text("Delete")
                                }
                            }
                        }
                    }

                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Dismiss") {
                                dismiss()
                            }
                        }
                    }
                    HStack {
                        Spacer()
                        Text("Total:")
                        Spacer().frame(width: 50)
                        Text(cartItems.map({$0.total}).reduce(0, +).currency)
                            .font(.headline)
                    }
                    .padding(.trailing, 30)
                }
            }
        }
    }

    private func delete(cartItem: CartMealItem) {
        withAnimation {
            viewContext.delete(cartItem)
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

}

struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        CartView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
