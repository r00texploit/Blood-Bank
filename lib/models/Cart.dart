import 'personlist.dart';

class Cart {
  final Person product;
  final int numOfItem;

  Cart({required this.product, required this.numOfItem});
}

//User Lists

List<Cart> demoCarts = [
  Cart(product: person.persons![0], numOfItem: 2),
  Cart(product: person.persons![1], numOfItem: 1),
  Cart(product: person.persons![3], numOfItem: 1),
];
