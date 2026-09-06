import 'dono.dart';

enum TipoRegistro { adocao, perdido, resgate }

extension RotuloTipo on TipoRegistro {
  String get rotulo {
    switch (this) {
      case TipoRegistro.adocao:
        return 'adoção';
      case TipoRegistro.perdido:
        return 'perdidos';
      case TipoRegistro.resgate:
        return 'resgate';
    }
  }
}

enum StatusAnimal { disponivel, adotado }

extension RotuloStatus on StatusAnimal {
  String get rotulo =>
      this == StatusAnimal.disponivel ? 'disponível' : 'adotado';
}

class Animal {
  final String nome;
  final String especie;
  final String raca;
  final String sexo;
  final String porte;
  final String idade;
  final String peso;
  final String cor;
  final String bairro;
  final String cidade;
  final TipoRegistro tipo;
  final StatusAnimal status;
  final bool castrado;
  final bool vacinado;
  final bool vermifugado;
  final String observacoes;
  final Dono dono;
  final List<String> fotos;
  final DateTime publicadoEm;
  // Salva a localização do aparelho quando a pessoa tocou no botão de localização
  // Fica vazio quando o endereço foi digitado à mão
  final double? latitude;
  final double? longitude;

  Animal({
    required this.nome,
    required this.especie,
    required this.raca,
    required this.sexo,
    required this.porte,
    required this.idade,
    required this.peso,
    required this.cor,
    required this.bairro,
    required this.cidade,
    required this.tipo,
    this.status = StatusAnimal.disponivel,
    this.castrado = false,
    this.vacinado = false,
    this.vermifugado = false,
    this.observacoes = '',
    required this.dono,
    this.fotos = const [],
    required this.publicadoEm,
    this.latitude,
    this.longitude,
  });

  // A capa do animal é a primeira foto
  String get foto => fotos.isEmpty ? '' : fotos.first;

  // Os mapas só conseguem desenhar o animal quando as duas coordenadas existem
  bool get temPonto => latitude != null && longitude != null;

  // Descrição curta do animal, exibida embaixo do nome no card do feed.
  String get resumo =>
      [sexo, 'porte $porte', idade].map(_comMaiuscula).join(' · ');

  // Há quanto tempo o animal foi publicado, no formato que vai no card.
  // Compara só o dia, porque a hora não interessa a quem lê o feed.
  String publicadoHa(DateTime agora) {
    final hoje = DateTime(agora.year, agora.month, agora.day);
    final dia = DateTime(publicadoEm.year, publicadoEm.month, publicadoEm.day);
    final dias = hoje.difference(dia).inDays;

    if (dias <= 0) return 'hoje';
    if (dias == 1) return 'ontem';
    if (dias <= 30) return 'há $dias dias';

    final meses = dias ~/ 30;
    return meses == 1 ? 'há 1 mês' : 'há $meses meses';
  }

  static String _comMaiuscula(String texto) =>
      texto.isEmpty ? texto : texto[0].toUpperCase() + texto.substring(1);
}
