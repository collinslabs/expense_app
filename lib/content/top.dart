import 'package:expense_app/data/1.dart';


List<money> geter_top() {
  money snapFood = money();
  snapFood.time = 'jan 30 2024';
  snapFood.image = 'jtn.png';
  snapFood.buy = true;
  snapFood.fee = '-\$ 100';
  snapFood.name = 'snap food';

  money snap = money();
  snap.image = "jr.jpg";
  snap.time = 'today';
  snap.buy = true;
  snap.name = 'Transfer';
  snap.fee = '- \$ 60';

  return [snapFood, snap];
}
