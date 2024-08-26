import 'package:expense_app/content/1.dart';

List<money> geter() {
  money remotask = money();
  remotask.name = 'remotask';
  remotask.fee = '750';
  remotask.time = 'today';
  remotask.image = 'rm.jpg';
  remotask.buy = false;
  money starbucks = money();
  starbucks.buy = true;
  starbucks.fee = '20' ;
  starbucks.image = 'star.jpg';
  starbucks.name = 'starbucks';
  starbucks.time = 'today';
  money transfer = money();
  transfer.buy = true;
  transfer.fee = '100' ;
  transfer.image = 'jr.jpg';
  transfer.name = 'transfer for Kelvin';
  transfer.time = 'Aug 24, 2024';
  return [remotask, starbucks, transfer, remotask, starbucks, transfer];
}
