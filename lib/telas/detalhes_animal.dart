import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/barra_inferior.dart';

import '../modelos/dono.dart';
import '../modelos/animal.dart';
import '../tema/cores.dart';
import '../widgets/foto_animal.dart';

class DetalhesAnimal extends StatelessWidget {
  final Animal animal;

  const DetalhesAnimal({super.key, required this.animal});

  Future<void> _chamarNoWhatsApp(BuildContext context) async {
    final mensageiro = ScaffoldMessenger.of(context);
    final texto = Uri.encodeComponent(
      'Olá! Vi ${animal.nome} no Pata Amiga e queria saber mais.',
    );
    final endereco = Uri.parse(
      'https://wa.me/${animal.dono.numeroNoWhatsApp}?text=$texto',
    );

    final abriu = await launchUrl(
      endereco,
      mode: LaunchMode.externalApplication,
    );
    if (!abriu) {
      mensageiro
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('Não foi possível abrir o WhatsApp neste aparelho.'),
            duration: Duration(seconds: 3),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Cores.fundo,
        leadingWidth: 64,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            tooltip: 'Voltar',
            color: Cores.principal,
            onPressed: () => Navigator.maybePop(context),
          ),
        ),
        centerTitle: true,
        title: const Text(
          'DETALHES',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.8,
            color: Cores.principal,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FotoAnimal(caminho: animal.foto, altura: 280),
            const SizedBox(height: 12),

            // Cartão único: nome + selo + tabelas + saúde + contato
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Cores.cartao,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Cores.borda),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        animal.nome.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Cores.principalClara,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          animal.status.rotulo,
                          style: const TextStyle(
                            color: Cores.principal,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),
                  Table(
                    columnWidths: const {
                      0: IntrinsicColumnWidth(),
                      2: IntrinsicColumnWidth(),
                    },
                    defaultVerticalAlignment: TableCellVerticalAlignment.top,
                    children: [
                      _linhaTabela(
                        'ESPÉCIE',
                        animal.especie,
                        'PORTE',
                        animal.porte,
                      ),
                      _linhaTabela('RAÇA', animal.raca, 'SEXO', animal.sexo),
                      _linhaTabela('IDADE', animal.idade, 'PESO', animal.peso),
                      _linhaTabela('COR', animal.cor, 'CIDADE', animal.cidade),
                    ],
                  ),

                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      if (animal.castrado) _Selo('castrado'),
                      if (animal.vacinado) _Selo('vacinado'),
                      if (animal.vermifugado) _Selo('vermifugado'),
                    ],
                  ),

                  const SizedBox(height: 14),
                  Table(
                    columnWidths: const {0: IntrinsicColumnWidth()},
                    defaultVerticalAlignment: TableCellVerticalAlignment.top,
                    children: [
                      _linhaSimples('RESPONSÁVEL', animal.dono.nome),
                      _linhaSimples('TELEFONE', animal.dono.telefone),
                      _linhaSimples('OBS', animal.observacoes),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () => _chamarNoWhatsApp(context),
                  icon: const Icon(Icons.chat_bubble_outline),
                  label: const Text('Conversar no WhatsApp'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Cores.principal,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const BarraInferior(),
        ],
      ),
    );
  }
}

// Uma célula de texto da tabela: se for rótulo, ganha o ":" e o estilo fraco;
// se for valor, fica com o estilo normal e a linha embaixo.
Widget _celula(String texto, {bool rotulo = false, bool cortar = false}) =>
    Padding(
      padding: const EdgeInsets.only(bottom: 10, right: 10),
      child: rotulo
          ? Text(
              '$texto:',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Cores.textoFraco,
              ),
            )
          : Container(
              padding: const EdgeInsets.only(bottom: 2),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Cores.borda)),
              ),
              child: Text(
                texto,
                maxLines: cortar ? 1 : null,
                overflow: cortar ? TextOverflow.ellipsis : TextOverflow.visible,
                style: const TextStyle(fontSize: 14),
              ),
            ),
    );

// Uma linha da grade com dois pares rótulo/valor (ex.: espécie e porte)
TableRow _linhaTabela(
  String rotulo1,
  String valor1,
  String rotulo2,
  String valor2,
) {
  return TableRow(
    children: [
      _celula(rotulo1, rotulo: true),
      _celula(valor1, cortar: true),
      _celula(rotulo2, rotulo: true),
      _celula(valor2, cortar: true),
    ],
  );
}

// Uma linha com um único par rótulo/valor (ex.: responsável)
TableRow _linhaSimples(String rotulo, String valor) {
  return TableRow(children: [_celula(rotulo, rotulo: true), _celula(valor)]);
}

class _Selo extends StatelessWidget {
  final String texto;
  const _Selo(this.texto);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Cores.principalClara,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle, size: 14, color: Cores.principal),
          const SizedBox(width: 4),
          Text(
            texto,
            style: const TextStyle(
              color: Cores.principal,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
