import 'package:flutter/material.dart';
import '../data.dart';
import '../ui.dart';

class AcessosScreen extends StatefulWidget {
  final Repo repo;
  final bool desktop;
  const AcessosScreen({super.key, required this.repo, required this.desktop});
  @override
  State<AcessosScreen> createState() => _AcessosScreenState();
}

class _AcessosScreenState extends State<AcessosScreen> {
  int sel = 0;

  Repo get repo => widget.repo;

  String get _titulo {
    final n = repo.pedidos.length;
    if (n == 0) return 'Ninguém espera';
    if (n == 1) return 'Uma pessoa espera';
    if (n == 2) return 'Duas pessoas esperam';
    if (n == 3) return 'Três pessoas esperam';
    return '$n pessoas esperam';
  }

  Widget _detalhe(Pedido p, {bool sheet = false}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
      Row(children: [
        logoDe(p.proj, 15),
        const SizedBox(width: 10),
        Text('pedido de acesso', style: inter(13, w: FontWeight.w500, c: C.mt)),
      ]),
      const SizedBox(height: 18),
      Text(p.nome, style: poppins(sheet ? 24 : 34, h: 1.1)),
      const SizedBox(height: 12),
      for (final l in p.linhas) Text(l, style: inter(sheet ? 13 : 16, c: C.mt, h: 1.6)),
      SizedBox(height: sheet ? 14 : 26),
      Text('Ao aprovar, o código de acesso chega no app dele e o teste de 14 dias começa agora.',
          style: inter(sheet ? 13 : 16, h: 1.55)),
      SizedBox(height: sheet ? 18 : 34),
      Btn('Aprovar e enviar código', () {
        repo.aprovar(p);
        if (sheet) Navigator.of(context).pop();
        setState(() => sel = 0);
      }, full: true),
      const SizedBox(height: 10),
      Btn('Recusar', () {
        repo.recusar(p);
        if (sheet) Navigator.of(context).pop();
        setState(() => sel = 0);
      }, primary: false, full: true),
      if (!sheet) ...[
        const SizedBox(height: 22),
        Text('Quem é recusado recebe um aviso gentil e pode pedir de novo depois.',
            style: inter(14, c: C.mt, h: 1.5)),
      ],
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final lista = repo.pedidos;
    if (sel >= lista.length) sel = 0;
    final vazio = Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Text('Nenhum pedido esperando. Quando alguém pedir acesso, aparece aqui.',
            style: inter(16, c: C.mt, h: 1.5)));

    if (widget.desktop) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(56, 28, 56, 28),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Tag('Pedidos de acesso'),
            const SizedBox(height: 14),
            Text(_titulo, style: poppins(44, h: 1.1)),
            RichText(
                text: TextSpan(style: poppins(44, h: 1.1), children: [
              const TextSpan(text: 'você '),
              TextSpan(text: 'decidir.', style: poppins(44, h: 1.1, c: C.pl)),
            ])),
            const SizedBox(height: 36),
            if (lista.isEmpty) vazio,
            for (int i = 0; i < lista.length; i++)
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => setState(() => sel = i),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                    decoration: BoxDecoration(
                        color: i == sel ? C.s2 : Colors.transparent,
                        borderRadius: BorderRadius.circular(22)),
                    child: Row(children: [
                      SizedBox(width: 90, child: Align(alignment: Alignment.centerLeft, child: logoDe(lista[i].proj, 14))),
                      Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(lista[i].nome, style: poppins(21)),
                        const SizedBox(height: 3),
                        Text(lista[i].sub, style: inter(15, c: C.mt)),
                      ])),
                      Text(lista[i].quando, style: inter(14, w: FontWeight.w500, c: C.mt)),
                    ]),
                  ),
                ),
              ),
          ])),
          const SizedBox(width: 48),
          SizedBox(
              width: 468,
              child: Container(
                padding: const EdgeInsets.fromLTRB(32, 34, 32, 34),
                decoration: BoxDecoration(color: C.s1, borderRadius: BorderRadius.circular(28)),
                child: lista.isEmpty
                    ? Text('Tudo em dia por aqui.', style: poppins(22))
                    : SingleChildScrollView(child: _detalhe(lista[sel])),
              )),
        ]),
      );
    }

    return ListView(padding: const EdgeInsets.fromLTRB(14, 22, 14, 24), children: [
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Acessos', style: poppins(26)),
            const SizedBox(height: 4),
            Text(lista.isEmpty ? 'Tudo em dia' : '$_titulo você', style: inter(12.5, c: C.mt)),
          ])),
      const SizedBox(height: 16),
      if (lista.isEmpty) Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: vazio),
      for (int i = 0; i < lista.length; i++)
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: i == 0 ? C.s2 : C.s1, borderRadius: BorderRadius.circular(20)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            logoDe(lista[i].proj, 13),
            const SizedBox(height: 8),
            Text(lista[i].nome, style: poppins(15)),
            const SizedBox(height: 2),
            Text('${lista[i].sub.split(',').first}, ${lista[i].quando}', style: inter(11.5, c: C.mt)),
            const SizedBox(height: 12),
            Row(children: [
              Btn('Aprovar', () => repo.aprovar(lista[i]), small: true),
              const SizedBox(width: 8),
              Btn('Ver pedido', () => _abrirSheet(lista[i]), primary: false, small: true),
            ]),
          ]),
        ),
    ]);
  }

  void _abrirSheet(Pedido p) {
    showModalBottomSheet(
      context: context,
      backgroundColor: C.s1,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(22, 14, 22, 28),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
              width: 38,
              height: 4,
              decoration: BoxDecoration(color: C.line, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 18),
          Align(alignment: Alignment.centerLeft, child: _detalhe(p, sheet: true)),
        ]),
      ),
    );
  }
}
