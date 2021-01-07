import 'package:duepay/models/menu.dart';
import 'package:flutter/material.dart';

const DUMMY_MENU = {
  '1': const Menu(
    title: 'Extrato',
    subtitle: 'Consulte suas últimas transações',
    icon: Icon(Icons.access_alarm),
    tap: getExtrato,
  ),
  '2': const Menu(
    title: 'Boleto',
    subtitle: 'faça seus pagamentos',
    icon: Icon(Icons.access_alarm),
    tap: getBoleto,
  ),
};

getExtrato() {}
getBoleto() {}
