class Usuario {
  final int id;
  final String usuario;
  final String nome;
  final String sobrenome;
  final String perfil;
  final int status;
  final int cartao_corporativo;
  final String token;
  final String senha;

  Usuario(this.id, this.usuario, this.nome, this.sobrenome, this.perfil,
      this.status, this.cartao_corporativo, this.token, this.senha);

  Map<String, dynamic> toJson() => {
        'id': id,
        'usuario': usuario,
        'nome': nome,
        'sobrenome': sobrenome,
        'perfil': perfil,
        'status': status,
        'cartao_corporativo': cartao_corporativo,
        'token': token,
        'senha': senha,
      };

  Usuario.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        usuario = json['usuario'],
        nome = json['nome'],
        sobrenome = json['sobrenome'],
        perfil = json['perfil'],
        status = json['status'],
        cartao_corporativo = json['cartao_corporativo'],
        token = json['token'],
        senha = json['senha'];
}
