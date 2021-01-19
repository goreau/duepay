import 'package:duepay/models/proposta.dart';
import 'package:duepay/util/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class EmprestimoTile extends StatelessWidget {
  final LstProposta prop;

  const EmprestimoTile(this.prop);

  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: ListTile(
        title: Text(
          'Valor Solicitado: ${prop.valor}',
          style: TextStyle(
            fontSize: 14,
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Data: ${prop.dt_solicita}'),
            Text('Situação: ${trocaStatus(prop.status)}'),
          ],
        ),
      ),
      actions: <Widget>[
        IconSlideAction(
          caption: 'Detalhar',
          color: Colors.green,
          icon: Icons.edit,
          onTap: () => {
            Navigator.of(context).pushNamed(
              Routes.EMP_TIMELINE,
              arguments: int.parse(prop.operacao_ccb),
            )
          },
        ),
      ],
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Excluir',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: Text('Excluir solicitação'),
                content: Text('Confirma a operação?'),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Não'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  FlatButton(
                    child: Text('Sim'),
                    onPressed: () {
                      //excluir a proposta aqui
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            )
          },
        ),
      ],
    );
  }

  String trocaStatus(int stt) {
    String ret = '';
    switch (stt) {
      case 1:
        ret = 'Enviada a Solicitação';
        break;
      case 2:
        ret = 'Aguardando aprovação';
        break;
      case 3:
        ret = 'Aguardando envio de link';
        break;
      case 4:
        ret = 'Aguardando assinatura';
        break;
      case 5:
        ret = 'Aguardando Pagamento';
        break;
      default:
        ret = 'Pago';
    }

    return ret;
  }
}
