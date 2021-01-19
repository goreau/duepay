import 'dart:convert';

class Proposta {
  int _id;
  int _status;
  String _numRbm;
  String _time1;
  String _time2;
  String _time3;
  String _time4;
  String _time5;
  int _nsuHost;
  String _nsuData;
  int _nsuAutoriza;
  String _link;

  Proposta(
    this._id,
    this._status,
    this._numRbm,
    this._time1,
    this._time2,
    this._time3,
    this._time4,
    this._time5,
    this._nsuHost,
    this._nsuData,
    this._nsuAutoriza,
    this._link,
  );

  factory Proposta.fromJson(dynamic json) {
    return Proposta(
      int.parse(json['id_emprestimo_proposta'].toString()),
      int.parse(json['status'].toString()),
      json['num_rbm'],
      json['stt_1'],
      json['stt_2'],
      json['stt_3'],
      json['stt_4'],
      json['stt_5'],
      int.parse(json['nsu_host'].toString()),
      json['nsu_data'],
      int.parse(json['nsu_autoriza'].toString()),
      json['contrato_lk'],
    );
  }

  int get status => _status;
  String get time1 => _time1;
  String get time2 => _time2;
  String get time3 => _time3;
  String get time4 => _time4;
  String get time5 => _time5;
  String get numRbm => _numRbm;
}

class LstProposta {
  int id;
  String dt_solicita;
  int status;
  String operacao_ccb;
  String valor;

  LstProposta(
    this.id,
    this.dt_solicita,
    this.status,
    this.operacao_ccb,
    this.valor,
  );

  factory LstProposta.fromJson(dynamic json) {
    var prop = jsonDecode(json['dados_proposta']);
    return LstProposta(
      int.parse(json['id_emprestimo_proposta'].toString()),
      json['dt_solicita'],
      int.parse(json['status'].toString()),
      json['operacao_ccb'],
      'R\$ ${prop['valor_requerido'].toStringAsFixed(2)}',
    );
  }
}
