import 'one.dart';

List<Money> getertop() {
  Money snapfood = Money();
  snapfood.time = 'jan 30,2022';
  snapfood.image = 'mac.jpg';
  snapfood.buy = true;
  snapfood.fee = '- \$ 100';
  snapfood.name = 'macdonald';
  Money snap = Money();
  snap.image = 'cre.png';
  snap.time = 'today';
  snap.buy = true;
  snap.name = 'Transfer';
  snap.fee = '- \$ 60';

  return [snapfood, snap];
}
